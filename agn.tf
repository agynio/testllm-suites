resource "testllm_test_suite" "agn" {
  org_id = testllm_organization.org.id
  name   = "agn"
}

resource "testllm_test" "agn_simple_hello" {
  org_id   = testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "simple-hello"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "hi"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Hi! How are you?"
    },
  ]
}

resource "testllm_test" "agn_simple_state" {
  org_id   = testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "simple-state"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "hi"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Hi! How are you?"
    },
    {
      type    = "message"
      role    = "user"
      content = "fine"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "How can I help you?"
    },
  ]
}

resource "testllm_test" "agn_system_prompt" {
  org_id   = testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "system-prompt"

  items = [
    {
      type    = "message"
      role    = "system"
      content = "You are personal assistant"
    },
    {
      type    = "message"
      role    = "user"
      content = "hi"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Hello! I am here to help!"
    },
  ]
}
