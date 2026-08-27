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
      type             = "message"
      role             = "user"
      content          = ""
      content_contains = "hello"
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
      type             = "message"
      role             = "user"
      content          = ""
      content_contains = "What is the weather in Paris?"
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
      type             = "message"
      role             = "user"
      content          = ""
      content_contains = "Create an entity called test_project of type project with observation 'A test project', then list files in /test-data"
    },
    # Codex groups an MCP server's tools into a namespace and calls one by its
    # plain name with the namespace beside it. Joined into a single name, the
    # call comes back "unsupported call" and the turn ends with no answer.
    {
      type      = "function_call"
      func_name = "create_entities"
      namespace = "mcp__memory"
      call_id   = "fc_mem_001"
      arguments = "{\"entities\":[{\"name\":\"test_project\",\"entityType\":\"project\",\"observations\":[\"A test project\"]}]}"
    },
    # Codex wraps a tool result in the wall time the call took, which is a
    # different number every run, so only the result itself can be named.
    {
      type            = "function_call_output"
      call_id         = "fc_mem_001"
      output          = ""
      output_contains = "{\"entities\":[{\"name\":\"test_project\",\"entityType\":\"project\",\"observations\":[\"A test project\"]}]}"
    },
    {
      type      = "function_call"
      func_name = "list_directory"
      namespace = "mcp__filesystem"
      call_id   = "fc_fs_001"
      arguments = "{\"path\":\"/test-data\"}"
    },
    {
      type            = "function_call_output"
      call_id         = "fc_fs_001"
      output          = ""
      output_contains = "{\"content\":\"[FILE] hello.txt\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "I've created the entity 'test_project' (type: project) with the observation 'A test project'. The /test-data directory contains one file: hello.txt."
    },
  ]
}

resource "testllm_test" "codex_summarize_file" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.codex.id
  name     = "summarize-file"

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
      type             = "message"
      role             = "user"
      content          = ""
      content_contains = "Please summarize the file."
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Here is a summary of the file."
    },
  ]
}
