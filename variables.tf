variable "endpoint" {
  description = "TestLLM API endpoint URL"
  type        = string
}

variable "api_token" {
  description = "TestLLM API token"
  type        = string
  sensitive   = true
}

variable "org_name" {
  description = "Organization name"
  type        = string
}

variable "org_slug" {
  description = "Organization slug"
  type        = string
}
