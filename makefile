IMAGE_NAME=kubev
IMAGE_TAG=0.0.0
CONTAINER_NAME=kubermatic-virtualization-workshop

.PHONY: clear
clear:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: lint
lint:
	hadolint ./container-image/dockerfile 

.PHONY: build
build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) ./container-image/

.PHONY: run
run: build
	docker run -it -d \
		--name $(CONTAINER_NAME) \
		--restart=always \
		-p 8080:8080 \
		--hostname jumphost \
		-v /root/training-kubev:/training \
		$(IMAGE_NAME):$(IMAGE_TAG)

# .PHONY: push
# push: lint
# 	docker push --platform linux/amd64 --tag ${IMAGE_NAME}:${IMAGE_TAG} --push .

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