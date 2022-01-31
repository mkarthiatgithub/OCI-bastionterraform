resource "oci_core_virtual_network" "KarthiOCIVCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "KarthiOCIVCN"
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  display_name   = "KarthiOCIVCN"
}

resource "oci_core_dhcp_options" "KarthiOCIDhcpOptions1" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
  display_name   = "KarthiOCIDHCPOptions1"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }  
}

resource "oci_core_internet_gateway" "KarthiOCIInternetGateway" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  display_name   = "KarthiOCIInternetGateway"
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
}

resource "oci_core_route_table" "KarthiOCIRouteTableViaIGW" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
  display_name   = "KarthiOCIRouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.KarthiOCIInternetGateway.id
  }
}

resource "oci_core_nat_gateway" "KarthiOCINATGateway" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  display_name   = "KarthiOCINATGateway"
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
}

resource "oci_core_route_table" "KarthiOCIRouteTableViaNAT" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id         = oci_core_virtual_network.KarthiOCIVCN.id
  display_name   = "KarthiOCIRouteTableViaNAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.KarthiOCINATGateway.id
  }
}

resource "oci_core_subnet" "KarthiOCIWebSubnet" {
  cidr_block      = var.WebSubnet-CIDR
  display_name    = "KarthiOCIWebSubnet"
  dns_label       = "KarthiOCIN2"
  compartment_id  = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id          = oci_core_virtual_network.KarthiOCIVCN.id
  route_table_id  = oci_core_route_table.KarthiOCIRouteTableViaNAT.id
  dhcp_options_id = oci_core_dhcp_options.KarthiOCIDhcpOptions1.id
}

resource "oci_core_subnet" "KarthiOCILBSubnet" {
  cidr_block      = var.LBSubnet-CIDR
  display_name    = "KarthiOCILBSubnet"
  dns_label       = "KarthiOCIN1"
  compartment_id  = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id          = oci_core_virtual_network.KarthiOCIVCN.id
  route_table_id  = oci_core_route_table.KarthiOCIRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.KarthiOCIDhcpOptions1.id
}

resource "oci_core_subnet" "KarthiOCIBastionSubnet" {
  cidr_block      = var.BastionSubnet-CIDR
  display_name    = "KarthiOCIBastionSubnet"
  dns_label       = "KarthiOCIN3"
  compartment_id  = oci_identity_compartment.KarthiOCICompartment.id
  vcn_id          = oci_core_virtual_network.KarthiOCIVCN.id
  route_table_id  = oci_core_route_table.KarthiOCIRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.KarthiOCIDhcpOptions1.id
}

