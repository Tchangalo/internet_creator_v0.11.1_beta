#!/bin/bash

if [[ $(df -T / | awk 'NR==2 {print $2}') == "zfs" ]]; then
    qm create 307999 --name "dhcp3" --ostype l26 --memory 1536 --balloon 1500 --cpu host --cores 4 --scsihw virtio-scsi-single --virtio0 local-zfs:8,discard=on --net0 virtio,bridge=vmbr0,macaddr="00:24:18:0A:C3:DE"
    qm set 307999 --ide2 /var/lib/vz/template/iso//ubuntu-24.04.1-live-server-amd64.iso,media=cdrom
    qm set 307999 --boot order=ide2
    qm set 307999 -net1 model=virtio,bridge=vmbr1001,firewall=0
    qm set 307999 --agent enabled=1
else
    qm create 307999 --name "dhcp3" --ostype l26 --memory 1536 --balloon 1500 --cpu host --cores 4 --scsihw virtio-scsi-single --virtio0 local-btrfs:8,discard=on --net0 virtio,bridge=vmbr0,macaddr="00:24:18:0A:C3:DE"
    qm set 307999 --ide2 /var/lib/pve/local-btrfs/template/iso/ubuntu-24.04.1-live-server-amd64.iso,media=cdrom
    qm set 307999 --boot order=ide2
    qm set 307999 -net1 model=virtio,bridge=vmbr1001,firewall=0
    qm set 307999 --agent enabled=1
fi

