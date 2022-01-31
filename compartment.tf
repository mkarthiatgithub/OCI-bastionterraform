resource "oci_identity_compartment" "KarthiOCICompartment" {
  name = "KarthiOCICompartment"
  description = "KarthiOCI Compartment"
  compartment_id = var.compartment_ocid
}

