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

.PHONY: verify
verify:
	test -f /root/.trainingrc
	grep "source /root/.trainingrc" /root/.zshrc
	kubectl version --client
	gcloud version
	kubectx
	helm version
	test -n "$(GCP_PROJECT)"
	test -n "$(TRAINEE_NAME)"
	test -n "$(TRAINEE_EMAIL)"
	test -n "$(JUMPHOST_EXT_IP)"
	test -n "$(JUMPHOST_INT_IP)"
	test -n "$(CONTROLPLANE_EXT_IP)"
	test -n "$(CONTROLPLANE_INT_IP)"
	test -n "$(WORKER_EXT_IP)"
	test -n "$(WORKER_INT_IP)"
# TODO	kubens => failing due no cluster yet
	test -n "$(K8S_VERSION)"
	test -e /training/.secrets/environment.sh
	test -e /training/.secrets/gcp-kubev
	test -e /training/.secrets/gcp-kubev-config
	test -e /training/.secrets/gcp-kubev.pub
	test -e /training/.secrets/gcp-service-account.json
	test -e /training/.secrets/README.md
# TODO ensure that is the right ssh key - ssh-add -l | grep "$(ssh-keygen -lf .secrets/gce)"
# TODO test -v $(GOOGLE_CREDENTIALS)
# TODO verify gcp sa permissions
	echo "Training Environment successfully verified"

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