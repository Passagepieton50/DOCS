
# Terraform Handbook

Documentation structurée autour de 35 chapitres couvrant les fondamentaux, les providers, les modules, les bonnes pratiques et plusieurs cas concrets autour de Terraform.

---

## Sommaire

### Fondamentaux

* 01 [Terraform - Introduction](./01-introduction/01-introduction.md)
* 02 [Terraform - Installation](./02-installation/02-installation.md)
* 03 [Terraform - Notions et définitions](./03-notions-definitions/03-notions-definitions.md)
* 04 [Terraform - Variables et local-exec](./04-variables-local-exec/04-variables-local-exec.md)
* 05 [Terraform - Variables et typage](./05-variables-definition/05-variables-definition.md)

### Exécution et provisioning

* 06 [Terraform - Remote exec SSH](./06-remote-exec-ssh/06-remote-exec-ssh.md)
* 07 [Terraform - Installation Docker via Terraform](./07-remote-install-docker/07-remote-install-docker.md)
* 08 [Terraform - Docker provider et nginx](./08-docker-provider-nginx/08-docker-provider-nginx.md)

### Modules et structuration

* 09 [Terraform - Introduction aux modules](./09-modules-introduction/09-modules-introduction.md)
* 10 [Terraform - Modules premier pas](./10-module-premier-pas/10-module-premier-pas.md)
* 11 [Terraform - Modules et target](./11-modules-target/11-modules-target.md)

### Docker avec Terraform

* 12 [Terraform - Docker network](./12-docker-network/12-docker-network.md)
* 13 [Terraform - Docker volumes](./13-docker-volumes/13-docker-volumes.md)
* 14 [Terraform - Docker WordPress](./14-docker-wordpress/14-docker-wordpress.md)
* 15 [Terraform - Docker registry et images](./15-docker_registry_image/15-docker_registry_image.md)
* 16 [Terraform - SSH triggers et orchestration](./16-docker-ssh-triggers/16-docker-ssh-triggers.md)

### Cycle de vie

* 17 [Terraform - Destroy et gestion des ressources](./17-destroy/17-destroy.md)

### Kubernetes avec Terraform

* 18 [Terraform - Introduction Kubernetes](./18-kubernetes-intro/18-kubernetes-intro.md)
* 19 [Terraform - Services et namespaces](./19-kubernetes-service-namespaces/19-kubernetes-service-namespaces.md)
* 20 [Terraform - Ingress](./20-kubernetes-ingress/20-kubernetes-ingress.md)
* 21 [Terraform - WordPress part 1](./21-kubernetes-wordpress-part1/21-kubernetes-wordpress-part1.md)
* 22 [Terraform - WordPress part 2](./22-kubernetes-wordpress-part2/22-kubernetes-wordpress-part2.md)
* 23 [Terraform - WordPress part 3](./23-kubernetes-wordpress-part3/23-kubernetes-wordpress-part3.md)
* 24 [Terraform - WordPress part 4](./24-kubernetes-wordpress-part4/24-kubernetes-wordpress-part4.md)
* 25 [Terraform - Module Kubernetes WordPress](./25-kubernetes-wordpress-module/25-kubernetes-wordpress-module.md)

### Virtualisation KVM

* 26 [Terraform - Installation KVM](./26-installation-kvm/26-installation-kvm.md)
* 27 [Terraform - Provider KVM première VM](./27-provider-kvm-premiere-vm/27-provider-kvm-premiere-vm.md)
* 28 [Terraform - Provider KVM cloud-init](./28-provider-kvm-cloud-init/28-provider-kvm-cloud-init.md)
* 29 [Terraform - IP statique via MAC](./29-provider-kvm-static-ip-via-mac/29-provider-kvm-static-ip-via-mac.md)
* 30 [Terraform - IP statique via cloud-init](./30-provider-kvm-static-via-cloudinit/30-provider-kvm-static-via-cloudinit.md)
* 31 [Terraform - Module instance KVM](./31-provider-kvm-module-instance/31-provider-kvm-module-instance.md)
* 32 [Terraform - Pool de stockage KVM](./32-provider-kvm-pool-stockage/32-provider-kvm-pool-stockage.md)
* 33 [Terraform - Locals et lookup](./33-provider-kvm-locals-lookup/33-provider-kvm-locals-lookup.md)
* 34 [Terraform - Workspaces](./34-provider-kvm-workspace/34-provider-kvm-workspace.md)

### State et backend

* 35 [Terraform - State distant GitLab et OpenStack](./35-gitlab-state-openstack/35-gitlab-state-openstack.md)

---

## Structure du dépôt

* docs/ : documentation principale
* labs/ : exemples et cas pratiques
* assets/ : ressources statiques (images, fichiers)

---

## Objectifs

Ce dépôt vise à fournir :

* une documentation complète et progressive de Terraform
* une approche orientée production et bonnes pratiques DevOps
* des cas concrets autour de Docker, Kubernetes et KVM
* une compréhension du modèle déclaratif et du graphe Terraform
* une base pédagogique pour formation ou auto-apprentissage

---

## Utilisation

Chaque chapitre contient :

* une explication détaillée
* des exemples contextualisés
* des commandes reproductibles
* un lien vers un laboratoire (labs/) lorsque du code est associé

---

## Licence

MIT
