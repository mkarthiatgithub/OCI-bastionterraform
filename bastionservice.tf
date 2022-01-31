resource "oci_bastion_bastion" "KarthiOCIBastionService" {
  bastion_type                 = "STANDARD"
  compartment_id               = oci_identity_compartment.KarthiOCICompartment.id
  target_subnet_id             = oci_core_subnet.KarthiOCIBastionSubnet.id
  client_cidr_block_allow_list = split(",", var.client_cidr_block_allow_list)
  name                         = "KarthiOCIBastionService"
  max_session_ttl_in_seconds   = var.max_session_ttl_in_seconds
}

resource "oci_bastion_session" "KarthiOCISSHViaBastionService" {
  depends_on = [oci_core_instance.karthiOCIWebserver]
  count      = var.NumberOfNodes
  bastion_id = oci_bastion_bastion.KarthiOCIBastionService.id

  key_details {
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }
  target_resource_details {
    session_type       = "MANAGED_SSH"
    target_resource_id = oci_core_instance.karthiOCIWebserver[count.index].id

    #Optional
    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = 22
    target_resource_private_ip_address         = oci_core_instance.karthiOCIWebserver[count.index].private_ip
  }

  display_name           = "KarthiOCISSHViaBastionService"
  key_type               = "PUB"
  session_ttl_in_seconds = 1800
}
