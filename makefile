IMAGE_NAME=kubev
IMAGE_TAG=0.0.0

.PHONY: clear
clear:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: lint
lint:
	hadolint ./container-image/dockerfile 

.PHONY: build
build: lint
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./container-image/

.PHONY: run
run: build
	docker run -it -d \
		--restart=always \
		-p 8080:8080 \
		--hostname jumphost \
		-v $(PWD):/training \
		$(IMAGE_NAME):$(IMAGE_TAG)

# TODO compose? healthchecks?		

# .PHONY: ssh-controlplane-node
# ssh-controlplane-node:
# 	ssh -F /training/.secrets/ssh-config controlplane-node  

# .PHONY: ssh-worker-node
# ssh-worker-node:
# 	ssh -F /training/.secrets/ssh-config worker-node  

# .PHONY: restart
# restart:
# 	ssh -F /training/.secrets/ssh-config controlplane-node 'bash -s' < /training/99_teardown/teardown.sh
# 	ssh -F /training/.secrets/ssh-config worker-node 'bash -s' < /training/99_teardown/teardown.sh