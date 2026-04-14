kubectl logs -f cdi-upload-tmp-pvc-c8032dc7-0e39-4808-a1a7-e2b082967e63
I0414 09:10:45.365445       1 uploadserver.go:81] Running server on 0.0.0.0:8443
I0414 09:10:58.337167       1 uploadserver.go:410] Content type header is "blockdevice-clone"
I0414 09:10:58.338447       1 file.go:230] copyWithSparseCheck to /dev/cdi-block-volume
E0414 09:10:58.339557       1 file.go:218] Error zeroing range in destination file: operation not
supported, will write zeros directly
I0414 09:10:58.339582       1 file.go:140] Writing 1015808 zero bytes at offset 32768

⏺ Der Upload-Server hat die Verbindung empfangen und angefangen zu schreiben. Das eigentliche Problem:

  Error zeroing range in destination file: operation not supported

  Das Longhorn Block Device (/dev/cdi-block-volume) unterstützt kein FALLOC_FL_ZERO_RANGE (sparse hole
   punching). Der Fallback "write zeros directly" funktioniert, ist aber deutlich langsamer — bei
  einem 10GB Image muss er alle Null-Bytes explizit schreiben.

  Was wahrscheinlich passiert ist: Der Upload-Server hat beim Schreiben der Zeros zu lange gebraucht →
   der Importer-Pod hat die Verbindung als dead angesehen und getrennt → connection reset by peer auf
  beiden Seiten.  

  Prüfe ob der Upload-Server noch läuft oder gecrasht ist:
  ! kubectl get pod cdi-upload-tmp-pvc-c8032dc7-0e39-4808-a1a7-e2b082967e63 -o wide
  ! kubectl logs cdi-upload-tmp-pvc-c8032dc7-0e39-4808-a1a7-e2b082967e63 --tail=50

  Mögliche Lösung — Timeout im DataVolume erhöhen:
  spec:
    source:
      http:
        url: "..."
    storage:
      resources:
        requests:
          storage: 10Gi
    # CDI Annotation für längeren Timeout:
  annotations:
    cdi.kubevirt.io/storage.pod.phase.deadline: "3600"

  Oder zeig mir dein my-vm.yaml, dann schaue ich mir die DataVolume-Spec an.

❯ brauche ich hier volume mode block

  Searched for 1 pattern, read 1 file (ctrl+o to expand)

⏺ Du hast volumeMode: Block — das ist der Grund für den Fehler. Die Logs zeigen /dev/cdi-block-volume
  und den operation not supported Fehler beim Sparse-Write, was beides typisch für Block-Mode ist.

  Für ein VM-Rootdisk brauchst du das nicht. Filesystem mode (Standard) reicht völlig und funktioniert
   besser mit Longhorn:

  pvc:
    accessModes:
      - ReadWriteOnce
    volumeMode: Filesystem   # oder einfach weglassen, Filesystem ist default
    storageClassName: longhorn
    resources:
      requests:
        storage: 10Gi

  Block-Mode macht Sinn wenn du z.B. ein raw block device direkt in die VM durchreichen willst — für  
  normale DataVolumes mit CDI-Import ist Filesystem die richtige Wahl.
