resource "oci_load_balancer" "KarthiOCIFlexPublicLoadBalancer" {
  compartment_id = oci_identity_compartment.KarthiOCICompartment.id

  display_name               = "KarthiOCIFlexPublicLB"
  network_security_group_ids = [oci_core_network_security_group.KarthiOCIWebSecurityGroup.id]

  subnet_ids = [
    oci_core_subnet.KarthiOCILBSubnet.id
  ]

  shape = var.lb_shape

  dynamic "shape_details" {
    for_each = local.is_flexible_lb_shape ? [1] : []
    content {
      minimum_bandwidth_in_mbps = 10
      maximum_bandwidth_in_mbps = 10
    }
  }
}

resource "oci_load_balancer_backendset" "KarthiOCIFlexPublicLoadBalancerBackendset" {
  name             = "KarthiOCIFlexLBBackendset"
  load_balancer_id = oci_load_balancer.KarthiOCIFlexPublicLoadBalancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}


resource "oci_load_balancer_listener" "KarthiOCIFlexPublicLoadBalancerListener" {
  load_balancer_id         = oci_load_balancer.KarthiOCIFlexPublicLoadBalancer.id
  name                     = "KarthiOCIFlexLBListener"
  default_backend_set_name = oci_load_balancer_backendset.KarthiOCIFlexPublicLoadBalancerBackendset.name
  port                     = 80
  protocol                 = "HTTP"
}


resource "oci_load_balancer_backend" "KarthiOCIFlexPublicLoadBalancerBackend" {
  count            = var.NumberOfNodes
  load_balancer_id = oci_load_balancer.KarthiOCIFlexPublicLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.KarthiOCIFlexPublicLoadBalancerBackendset.name
  ip_address       = oci_core_instance.karthiOCIWebserver[count.index].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}



output "KarthiOCIFlexPublicLoadBalancer_Public_IP" {
  value = [oci_load_balancer.KarthiOCIFlexPublicLoadBalancer.ip_addresses]
}

