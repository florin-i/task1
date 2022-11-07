resource "null_resource" "ping" {
  for_each = var.vms
  triggers = {
    cluster_instance_ids = join(",", values(module.vm)[*].vm_id)
  }

  connection {
    type     = "ssh"
    user     = var.adminUserName
    password = module.vm[each.key].password
    host     = module.vm[each.key].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      # "export cur_index=${index(sort(keys(var.vm)), each.key)}",
      # "export next_index=${index(sort(keys(var.vm)), each.key) < (length(var.vm) -1)? index(sort(keys(var.vm)), each.key) +1 : 0 }",
      "export source=${module.vm[each.key].private_ip}",
      "export destination=${module.vm[element(sort(keys(var.vms)), index(sort(keys(var.vms)), each.key) < (length(var.vms) -1)? index(sort(keys(var.vms)), each.key) +1 : 0)].private_ip}",
      "echo Start ping from $source to $destination",
      "touch ~/ping.txt",
      "ping -c 1 $destination > ~/ping.txt; if [ $? -eq 0 ]; then echo \"$source -> $destination = pass\" | tee -a ~/ping.txt ; else echo \"$source -> $destination = fail\" | tee -a ~/ping.txt ; fi ",
    ]

  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.adminUserName}@${module.vm[each.key].public_ip}:~/ping.txt out/pingvm-${each.key}.txt"
  }

  depends_on = [
    module.vm
  ]
}

resource "null_resource" "consolidate" {
  triggers = { 
    cluster_instance_ids = join(",", values(module.vm)[*].vm_id)
  }
  provisioner "local-exec" {
    command = "echo '' > out/out.txt && cat out/pingvm*.txt >> out/out.txt && rm -f out/pingvm*.txt"
  }

  depends_on = [
   null_resource.ping 
  ]
}

data "external" "pings" {
  program   = [
    "/bin/bash", "scripts/extract_txt.sh"
  ]
  depends_on = [
    null_resource.consolidate
  ]
}