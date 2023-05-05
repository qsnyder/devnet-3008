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

resource "cml2_lifecycle" "clus2023" {
  topology = file("CML-TF-Test.yaml")
} 