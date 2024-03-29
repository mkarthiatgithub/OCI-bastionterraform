resource "oci_core_instance" "karthiOCIWebserver" {
  count               = var.NumberOfNodes
  availability_domain = "anfG:UK-LONDON-1-AD-1"
  compartment_id      = oci_identity_compartment.KarthiOCICompartment.id
  display_name        = "karthiOCIWebserver${count.index + 1}"
  shape               = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  fault_domain = "FAULT-DOMAIN-${(count.index % 3) + 1}"

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.KarthiOCIWebSubnet.id
    assign_public_ip = false
    nsg_ids          = [oci_core_network_security_group.KarthiOCIWebSecurityGroup.id]
  }

  provisioner "local-exec" {
    command = "sleep 240"
  }

}

