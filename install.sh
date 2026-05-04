#!/bin/bash

# Skriptin pysäytys, jos jokin komento ei toimi
set -e

echo "--- 1. Päivitetään paketinhallinta ---"
sudo apt update

echo "--- 2. Asennetaan Ansible ---"
sudo apt install ansible -y

echo "--- 3. Ajetaan Ansiblen playbook ---"
sudo ansible-playbook -i hosts.ini site.yml

echo "--- ASENNUS VALMIS! ---"
