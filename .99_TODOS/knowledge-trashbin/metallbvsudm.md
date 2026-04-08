# MetalLB L2-Mode und Unifi Dream Machine

## Was der UDM tatsächlich sieht

MetalLB L2 funktioniert so: der Kubernetes-Node antwortet auf ARP für die LoadBalancer-IP mit seiner eigenen MAC-Adresse.

```
UDM fragt:      "Wer hat 192.168.100.240?"
Node antwortet: "Ich! MAC aa:bb:cc:dd:ee:ff"
```

Der UDM sieht:
- Eine neue IP (`192.168.100.240`)
- Mit der **MAC-Adresse des Nodes** — nicht der VM

Im UDM-UI erscheint das entweder gar nicht als eigenes Gerät, oder als zweiter Eintrag mit derselben MAC wie der Node.

## Warum keine eigene VM im UDM

Die VM hat keine eigene MAC auf dem physischen Netz. Masquerade-Networking versteckt sie komplett hinter dem Node. Der UDM hat keine Ahnung dass dahinter eine VM steckt.

## VM als Service erreichbar machen (LoadBalancer)

```yaml
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer
  selector:
    kubevirt.io/vm: my-vm
  ports:
    - port: 22
```

MetalLB vergibt eine IP aus dem Pool, UDM lernt sie per ARP — aber sieht den Node, nicht die VM.

## Wann die VM wirklich als eigenes Gerät im UDM erscheint

Nur mit **Bridge-Networking via Multus** — dann bekommt die VM:
- Eine eigene MAC-Adresse
- Eine IP direkt aus dem physischen Netz (per DHCP vom UDM oder statisch)
- Eigener ARP-Eintrag → eigener Eintrag im UDM-UI

## Vergleich

| Ansatz | VM im UDM sichtbar | Aufwand |
|--------|--------------------|---------|
| MetalLB LoadBalancer Service | Nein (Node-MAC) | gering |
| Bridge-Networking via Multus | Ja (eigene MAC) | hoch |
