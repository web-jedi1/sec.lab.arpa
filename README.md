# sec.lab.arpa

<br>

This project documents the automatic provisioning and setup of my Active Directory homelab, which is a security focussed playground hosted on a local proxmox cluster. It is my personalized version of [GOAD](https://github.com/Orange-Cyberdefense/GOAD?tab=readme-ov-file)

<br>

It uses [Terraform]() to automatically provision Windows Server 2025 Datacenter Core Virtual Machines from previously-created cloudbase-init images to said Proxmox cluster. Subsequently, these are configured using [Ansible](). Additionally, [Jenkins]() is used as the CI System for this setup, automatically deploying this environment.