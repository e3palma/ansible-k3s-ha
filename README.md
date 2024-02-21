# ansible-k3s-ha

# ansible-k3: Kubernetes Lighweight Cluster with Ansible automation

This playbook sets up a k3s cluster in High-Availability (HA) and installs Rancher and Longhorn.

How to use script
--------------
```
run ./play.sh

# when promoted for BECOME password enter password for local pc running script
# If Master and slave nodes are configured with passwordless sudo (insecure) remove the following lines from main.yml
  vars:
    ansible_sudo_pass: "{{ pass }}"

```

Credits and many thanks to
- [Ansible-k3sup](https://github.com/OmegaSquad82/) this play book originally started as a fork from [Ansible-k3sup](https://github.com/OmegaSquad82/ansible-k3sup)
- [Rancher](https://rancher.com/) the creators of [k3s](https://k3s.io),
- [Longhorn](https://github.com/longhorn/longhorn) maintained by [Cloud-Native Computing Foundation](https://www.cncf.io/),
- [alexellis](https://github.com/alexellis) for [k3sup](https://k3sup.dev/),
- [Kube-VIP](https://github.com/kube-vip/kube-vip),
- [RobeDevOps](https://github.com/RobeDevOps) for [ansible-k3s](https://github.com/RobeDevOps/ansible-k3s) 
- [itwars](https://github.com/itwars) for the inspiring [playbook](https://github.com/rancher/k3s/tree/master/contrib/ansible)
- [JimsGarage](https://github.com/JamesTurland/JimsGarage) for his video and tutorials. Playbook was developed based on his [K3S script](https://github.com/JamesTurland/JimsGarage/tree/main/Kubernetes/K3S-Deploy)



Playbook Details
=================
This playbook consist of roles executing the following main functions:

- On master and slave systems
  - When deploying to Raspbian
    - Enables cgroups 'cpu' + 'memory' in /boot/cmdline.txt
    - Disable the 'dphys-swapfile' service in systemd
  - Optional playbook to clean and remove K3S
- Only on localhost
  - Install [k3sup setup](https://get.k3sup.dev) script
    - Then install [k3sup](https://k3sup.dev) binary
  - Configure UFW and Firewalld with ports required by K3S if installed
  - Create [k3s](https://k3s.io) cluster
    - use Kube-VIP for loadbalancing
    - Creates cluster in High-Availability (HA)
  - Install [Rancher](https://rancher.com/)
  - Install [Longhorn](https://longhorn.io/)

For more details see the roles README.md files.


Inventory details and example
-----------------


```

[master]
master1 ansible_user=admin

[masters]
master2 ansible_user=admin
master3 ansible_user=admin

[slave]
slave1 ansible_user=admin
slave2 ansible_user=admin
slave3 ansible_user=admin

```

Playbook example
-------------------
```
---
---
- hosts: k3s_cluster
  become: yes
  vars_files: inventory/group_vars/secret.yml
  vars:
    ansible_sudo_pass: "{{ pass }}"
  roles:
    - container_features
    - dphys_swapfile

- hosts: localhost
  roles:
    - bootstrap_k3sup
    - k3s_cluster

- hosts: k3s_cluster
  become: yes
  vars_files: inventory/group_vars/secret.yml
  vars:
    ansible_sudo_pass: "{{ pass }}"
  roles:
    - undosudo
```
