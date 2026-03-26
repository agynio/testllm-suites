terraform {
  required_providers {
    testllm = {
      source  = "agynio/testllm"
      version = "0.3.0"
    }
  }
}

provider "testllm" {
  token = var.api_token
}

data "testllm_organization" "org" {
  slug = var.org_slug
}
