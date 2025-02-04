resource "proxmox_vm_qemu" "sec-win-dc" {
  count = 1
  name = "arpa-sec-dc-${count.index + 1}"
  desc = "Domain Controller ${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template_name  
  full_clone = true
  vmid = "300${count.index + 1}"
  tags = "terraform,win25,dc${count.index + 1},goad"

  agent = 1
  cores = 2
  sockets = 1
  memory = 4096 
  onboot = false
  os_type = "cloud-init"
  bootdisk = "scsi0"
  scsihw = "virtio-scsi-pci"

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr1"
    tag = 2004
  }

  disks {
    ide {
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size = 50
          storage = "local-lvm"
        }
      }
    }
  }

  ipconfig0 = "ip=10.0.4.${count.index + 2}/24,gw=10.0.4.1"
  nameserver = "${var.domain["authoritative_dns_server"]}"
  searchdomain = "${var.domain["domain_suffix"]}"

  ciuser = var.ciuser
  cipassword = var.cipassword
  sshkeys = <<EOF
  ${var.terraform_pub_key}
  EOF
}

resource "local_file" "hosts_cfg" {
  content = templatefile("hosts.tpl", {
    domain_controller_hostnames = [
      for i in range(length(proxmox_vm_qemu.sec-win-dc)) : 
        "${proxmox_vm_qemu.sec-win-dc[i].name}"
    ]
    domain_controller_ips = [
      for i in range(length(proxmox_vm_qemu.sec-win-dc)) : 
        regex("ip=([0-9\\.]+)", proxmox_vm_qemu.sec-win-dc[i].ipconfig0)[0]
    ]
    ciuser = var.ciuser
    cipassword = var.cipassword
  })
  filename = "../ansible/inventory/hosts.cfg"
}




