resource "null_resource" "ping" {
  for_each = { for vm in var.vms : vm.index => vm}
  triggers = {
    cluster_instance_ids = join(",", values(module.vm)[*].vm_id)
  }

  connection {
    type     = "ssh"
    user     = var.adminUserName
    password = module.vm[each.value.index].password
    host     = module.vm[each.value.index].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "export source=${module.vm[each.value.index].private_ip}",
      "export destination=${module.vm[each.value.index < length(var.vms) ? tostring(each.value.index + 1) : "1"].private_ip}",
      "echo Start ping from $source to $destination",
      "touch ~/ping.txt",
      "ping -c 1 $destination; if [ $? -eq 0 ]; then echo \"$source -> $destination = pass\" | tee -a ~/ping.txt ; else echo \"$source -> $destination = fail\" | tee -a ~/ping.txt ; fi "
    ]

  }

  depends_on = [
    module.vm
  ]
}
