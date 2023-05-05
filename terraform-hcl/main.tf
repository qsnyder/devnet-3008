terraform {
  required_providers {
    cml2 = {
      source  = "registry.terraform.io/ciscodevnet/cml2"
    }
  }
}

provider "cml2" {
  address     = "https://10.10.20.161"
  username    = "developer"
  password    = "C1sco12345"
  skip_verify = true
}

resource "cml2_lab" "clus2023" {
  title = "CLUS2023 DEVNET-3008"
}

resource "cml2_node" "external" {
  lab_id         = cml2_lab.clus2023.id
  nodedefinition = "external_connector"
  label          = "sbx_backend"
  configuration  = "bridge0"
  x = "-400"
  y = "-160"
}

resource "cml2_node" "breakout_switch" {
  lab_id         = cml2_lab.clus2023.id
  nodedefinition = "unmanaged_switch"
  label          = "breakout_switch"
  x = "-400"
  y = "-40"
}

resource "cml2_node" "r1" {
  lab_id         = cml2_lab.clus2023.id
  label          = "R1"
  nodedefinition = "iosv"
  x = "-120"
  y = "-80"
}

resource "cml2_node" "r2" {
  lab_id         = cml2_lab.clus2023.id
  label          = "R2"
  nodedefinition = "iosv"
  x = "-200"
  y = "80"
}

resource "cml2_node" "r3" {
  lab_id         = cml2_lab.clus2023.id
  label          = "R3"
  nodedefinition = "iosv"
  x = "-40"
  y = "80"
}

resource "cml2_link" "ext_2_us" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.external.id
  node_b = cml2_node.breakout_switch.id
}

resource "cml2_link" "us_2_r1" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r1.id
}

resource "cml2_link" "us_2_r2" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r2.id
}

resource "cml2_link" "us_2_r3" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.breakout_switch.id
  node_b = cml2_node.r3.id
}

resource "cml2_link" "r1_2_r2" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r2.id
}

resource "cml2_link" "r1_2_r3" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.r1.id
  node_b = cml2_node.r3.id
}

resource "cml2_link" "r2_2_r3" {
  lab_id = cml2_lab.clus2023.id
  node_a = cml2_node.r2.id
  node_b = cml2_node.r3.id
}

resource "cml2_lifecycle" "clus2023" {
  lab_id = cml2_lab.clus2023.id
  elements = [
    cml2_node.external.id,
    cml2_node.breakout_switch.id,
    cml2_node.r1.id,
    cml2_node.r2.id,
    cml2_node.r3.id,
    cml2_link.ext_2_us.id,
    cml2_link.us_2_r1.id,
    cml2_link.us_2_r2.id,
    cml2_link.us_2_r3.id,
    cml2_link.r1_2_r2.id,
    cml2_link.r1_2_r3.id,
    cml2_link.r2_2_r3.id,
  ]
  configs = {
    "R1": file("r1.info")
    "R2": file("r2.info")
    "R3": file("r3.info")
  }
}