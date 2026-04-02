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

resource "testllm_test" "codex_mcp_tools_test" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.codex.id
  name     = "mcp-tools-test"

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
      content = "Create an entity called test_project of type project with observation 'A test project', then list files in /test-data"
    },
    {
      type      = "function_call"
      func_name = "mcp__memory__create_entities"
      call_id   = "fc_mem_001"
      arguments = "{\"entities\":[{\"name\":\"test_project\",\"entityType\":\"project\",\"observations\":[\"A test project\"]}]}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_mem_001"
      output  = "{\"entities\":[{\"name\":\"test_project\",\"entityType\":\"project\",\"observations\":[\"A test project\"]}]}"
    },
    {
      type      = "function_call"
      func_name = "mcp__filesystem__list_directory"
      call_id   = "fc_fs_001"
      arguments = "{\"path\":\"/test-data\"}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_fs_001"
      output  = "{\"content\":\"[FILE] hello.txt\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "I've created the entity 'test_project' (type: project) with the observation 'A test project'. The /test-data directory contains one file: hello.txt."
    },
  ]
}
