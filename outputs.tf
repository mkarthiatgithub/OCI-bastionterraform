output "karthiOCIWebserver_PrivateIP" {
  value = [data.oci_core_vnic.karthiOCIWebserver_VNIC1.*.private_ip_address]
}
output "bastion_ssh_metadata" {
  value = oci_bastion_session.KarthiOCISSHViaBastionService.*.ssh_metadata
}
