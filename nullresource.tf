resource "null_resource" "node-server" {
  provisioner "local-exec" {
    command = <<EOT
       sleep 180;
       >inv1.ini;
         echo "[node-server]" | tee -a inv1.ini;     
         echo "${aws_instance.node-server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.key_name}.pem ansible_python_interpreter=/usr/bin/python3"  | tee -a inv1.ini;
         export ANSIBLE_HOST_KEY_CHECKING=False;
       ansible-playbook -i inv1.ini main.yml -vvv;
      EOT
  }
}

