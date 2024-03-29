# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.Shape


  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_core_vnic_attachments" "karthiOCIWebserver_VNIC1_attach" {
  count               = var.NumberOfNodes
  availability_domain = "anfG:UK-LONDON-1-AD-1"
  compartment_id      = oci_identity_compartment.KarthiOCICompartment.id
  instance_id         = oci_core_instance.karthiOCIWebserver[count.index].id
}

data "oci_core_vnic" "karthiOCIWebserver_VNIC1" {
  count   = var.NumberOfNodes
  vnic_id = data.oci_core_vnic_attachments.karthiOCIWebserver_VNIC1_attach[count.index].vnic_attachments.0.vnic_id
}


data "template_file" "key_script" {
  template = file("./scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}
