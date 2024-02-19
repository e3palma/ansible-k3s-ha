# ansible-k3s-ha

# ansible-k3: Kubernetes Lighweight Cluster with Ansible automation

This playbook sets up a k3s cluster in High-Availability (HA) and installs Rancher and Longhorn.

How to use script
--------------
```

run ./play.sh
# when promoted for BECOME password for local pc running script
```

Credits and many thanks to
- [Ansible-k3sup](https://github.com/OmegaSquad82/) this play book originally started as a fork from [Ansible-k3sup](https://github.com/OmegaSquad82/ansible-k3sup)
- [Rancher](https://rancher.com/) the creators of [k3s](https://k3s.io),
- [alexellis](https://github.com/alexellis) for [k3sup](https://k3sup.dev/),
- [RobeDevOps](https://github.com/RobeDevOps) for [ansible-k3s](https://github.com/RobeDevOps/ansible-k3s) 
- [itwars](https://github.com/itwars) for the inspiring [playbook](https://github.com/rancher/k3s/tree/master/contrib/ansible)
- [JimsGarage](https://github.com/JamesTurland/JimsGarage)

This configuration is defined in the inventory/hosts.ini file but without the ansible workstation node.

Playbook Details
=================
This playbook consist of roles executing the following main functions:

- On master and slave systems
  - When deploying to Raspbian
    - Enables cgroups 'cpu' + 'memory' in /boot/cmdline.txt
    - Disable the 'dphys-swapfile' service in systemd
- Only on localhost
  - Install [k3sup setup](https://get.k3sup.dev) script
    - Then install [k3sup](https://k3sup.dev) binary
  - Create [k3s](https://k3s.io) cluster (requires 'cluster_secret' variable)
  - Configure proper 'kubeconfig' to instantly enable kubectl)

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
- hosts: master:slave
  gather_facts: yes
  become: yes
  roles:
    - etc_config
    - container_features
    - dphys_swapfile
    - bootstrap_k3s

- hosts: master
  gather_facts: yes
  become: yes
  roles:
    - { role: k3s_master, tags: ['master'] }

- hosts: slave
  gather_facts: yes
  become: yes
  roles:
    - { role: k3s_slave, tags: ['slave'] }
```
