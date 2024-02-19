#!/usr/bin/env bash
HERE=$(pwd)
ansible-playbook -i "$HERE"/inventory/hosts.ini --ask-become-pass clean.yml
