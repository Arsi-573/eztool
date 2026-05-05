![ezTool](https://i.imgur.com/3Lh57ow.png)
<p align="center"><small><i>Photo by <a href="https://unsplash.com/@hypernature?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Maximilian Bungart</a> on <a href="https://unsplash.com/photos/colorful-light-patterns-on-a-dark-tiled-floor-PkLxHkdR8Bo?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></i></small></p>

# ezTool

**ezTool** is a lightweight **Infrastructure as Code** miniproject built with Ansible, designed to help small businesses manage their ICT environments effortlessly. Developed as part of the Server Management course taught by Tero Karvinen.

---

> [!WARNING]
> **This project was built purely as a learning exercise and is not suitable for production use.** Because this playbook automatically makes weak and easy-to-guess default passwords for user accounts, there is a risk of unauthorized access if deployed on an exposed system. 
> 
> **By using this playbook, you acknowledge that the authors of this software are not responsible for any damage, data loss, or security problems that may happen as a result of using it.** Only use in local or isolated test environments.

---

## Overview

Setting up workstations by hand can be very time-consuming and it is really easy to make mistakes. ezTool solves this problem by using Ansible's idempotent automation to create a provisioning process that is always the same and can be repeated. The playbook installs the necessary software, sets up user accounts with SSH key pairs, sets up a local intranet, and applies system-wide shell aliases, all without needing to be done by hand on the target machine.

## Features

- **Software setup** — Installs essential tools including KeePassXC, Caddy, LibreOffice, and other system utilities
- **Intranet** — Deploys a Caddy-served company portal accessible via a local domain
- **Shell aliases** — Registers a global `update` alias across all user accounts via `/etc/profile.d/` _(Which can be customised!)_
- **User reports** — Generates per-user text reports containing account details and public SSH keys

## Requirements

| Requirement | Details |
|---|---|
| Control node | Ansible installed (e.g. Debian) |
| Target node | Debian/Ubuntu VM in VirtualBox |
| Network | **Remote VM deployment only:** Two adapters configured on both VMs (Adapter 1 as **NAT**, and Adapter 2 as **Host-only Adapter**) |
| Access | SSH key-based authentication to target |

## Usage

**1. Install Git**

Before downloading the project, ensure that Git is installed on your target machine:
```bash
sudo apt update && sudo apt install -y git
```

**2. Clone the repository**
```bash
git clone https://github.com/Arsi-573/eztool.git
cd eztool
```

**3. Configure the inventory & variables**

The playbook supports running either locally or on a remote VM. Edit `hosts.ini` to set your target environment:
```ini
[workstation]
# Uncomment and add your target IP and user here for remote deployment
# 192.168.56.xxx ansible_user=USER_HERE ansible_become=true

[local]
localhost ansible_connection=local ansible_become=true
```

**4. Set company variables**

Edit the `vars` section in `site.yml` to define your company and employees:
```yaml
vars:
  company_name: "Esimerkki Oy"
  tyontekijat:
    - first_name: "Matti"
      last_name: "Meikäläinen"
    - first_name: "Maija"
      last_name: "Meikäläinen"
```

**5. Run the setup**

By default, the playbook is set to run on your **local machine**, so to run the setup script locally:
```bash
chmod +x install.sh && ./install.sh
```

_(Alternatively, to run the playbook on a remote workstation, we must specify the target using the `-e "to=workstation" variable`):_
```bash
ansible-playbook -i hosts.ini site.yml -e "to=workstation" -k -K
```

To preview changes without applying them locally:
```bash
ansible-playbook -i hosts.ini site.yml --check
# Caddy might throw an error during check mode if it is not installed yet. This is normal.
```

## Roles

### `common`
Handles system-level configuration shared across all users. Installs packages and registers global shell aliases through `/etc/profile.d/`.

### `users`
Creates employee accounts based on the `tyontekijat` variable list. Usernames are created automatically from the first four characters of the first name and the first two of the last name. Each account receives an SSH key pair and a generated report under `/root/user_reports/`.

### `web`
Deploys a Caddy web server and renders a company intranet page from a Jinja2 template. The local domain is registered in `/etc/hosts`.

## Notes

- **Passwords:** For this demo, user passwords are automatically generated from the company name. In a real work environment you should not do this, instead, passwords should be securely encrypted and hidden using a tool like [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html).
- **Inventory Security:** To prevent accidentally committing sensitive information to GitHub (like real IPs, usernames, or passwords), you should add your `hosts.ini` file to `.gitignore`. However, for this specific project, committing it was safe since we were only using local VirtualBox environments and private IP addresses.
