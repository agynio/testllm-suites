terraform {
  required_providers {
    testllm = {
      source  = "agynio/testllm"
      version = "0.2.0"
    }
  }
}

provider "testllm" {
  host  = var.endpoint
  token = var.api_token
}

resource "testllm_organization" "org" {
  name = var.org_name
  slug = var.org_slug
}
