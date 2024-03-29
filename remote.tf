resource "null_resource" "karthiOCIWebserverHTTPD" {
  count      = var.NumberOfNodes
  depends_on = [oci_core_instance.karthiOCIWebserver]
  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "opc"
      host                = data.oci_core_vnic.karthiOCIWebserver_VNIC1[count.index].private_ip_address
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      script_path         = "/home/opc/myssh.sh"
      agent               = false
      timeout             = "10m"
      bastion_host        = "host.bastion.${var.region}.oci.oraclecloud.com"
      bastion_port        = "22"
      bastion_user        = oci_bastion_session.KarthiOCISSHViaBastionService[count.index].id
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",
      "sudo -u root yum -y -q install docker-engine",
      "sudo -u root yum -y -q install jdk1.8.x86_64",

      "echo '== 2. Creating /var/www/html/index.html'",
      "sudo -u root touch /var/www/html/index.html",
      "sudo /bin/su -c \"echo 'Welcome to KarthiOCI ! This is WEBSERVER${count.index + 1}...' > /var/www/html/index.html\"",

      "echo '== 3. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}
