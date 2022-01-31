resource "oci_core_network_security_group" "KarthiOCIWebSecurityGroup" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  display_name   = "KarthiOCIWebSecurityGroup"
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
}

resource "oci_core_network_security_group" "KarthiOCISSHSecurityGroup" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  display_name   = "KarthiOCISSHSecurityGroup"
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
}

resource "oci_core_network_security_group_security_rule" "KarthiOCIWebSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.KarthiOCIWebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "KarthiOCIWebSecurityIngressGroupRules" {
  for_each = toset(var.webservice_ports)

  network_security_group_id = oci_core_network_security_group.KarthiOCIWebSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

resource "oci_core_network_security_group_security_rule" "KarthiOCISSHSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.KarthiOCISSHSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "KarthiOCISSHSecurityIngressGroupRules" {
  for_each = toset(var.bastion_ports)

  network_security_group_id = oci_core_network_security_group.KarthiOCISSHSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}
