resource "testllm_test_suite" "codex" {
  org_id = data.testllm_organization.org.id
  name   = "codex"
}

resource "testllm_test" "codex_simple_hello" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.codex.id
  name     = "simple-hello"

  items = [
    {
      type        = "message"
      role        = "developer"
      content     = ""
      any_content = true
    },
    {
      type        = "message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "message"
      role    = "user"
      content = "hello"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Hi! How are you?"
    },
  ]
}

resource "testllm_test" "codex_simple_tool_call" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.codex.id
  name     = "simple-tool-call"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "What is the weather in Paris?"
    },
    {
      type      = "function_call"
      func_name = "get_weather"
      call_id   = "fc_001"
      arguments = "{\"location\": \"Paris\"}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_001"
      output  = "{\"temperature\": \"18\u00b0C\", \"condition\": \"partly cloudy\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "The weather in Paris is 18\u00b0C and partly cloudy."
    },
  ]
}
