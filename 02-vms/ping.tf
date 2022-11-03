resource "null_resource" "ping" {
  for_each = { for index, vm in var.vms : index => vm}
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
      "export source=${module.vm[each.key].private_ip}",
      "export destination=${module.vm[each.key < (length(var.vms) - 1) ? tostring(each.key + 1) : "0"].private_ip}",
      "echo Start ping from $source to $destination",
      "touch ~/ping.txt",
      "ping -c 1 $destination > ~/ping.txt; if [ $? -eq 0 ]; then echo \"$source -> $destination = pass\" | tee -a ~/ping.txt ; else echo \"$source -> $destination = fail\" | tee -a ~/ping.txt ; fi ",
    ]

  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.adminUserName}@${module.vm[each.key].public_ip}:~/ping.txt out/ping${each.key}.txt"
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
    command = "echo '' > out/out.txt && cat out/ping*.txt >> out/out.txt"
  }

  depends_on = [
   null_resource.ping 
  ]
}

data "local_file" pings {
  filename = "out/out.txt"
  depends_on = [
    null_resource.consolidate
  ]
}
