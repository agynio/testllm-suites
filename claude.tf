resource "testllm_test_suite" "claude" {
  org_id   = data.testllm_organization.org.id
  name     = "claude"
  protocol = "anthropic"
}

resource "testllm_test" "claude_simple_hello" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.claude.id
  name     = "simple-hello"

  items = [
    {
      type        = "anthropic_system"
      text        = ""
      any_content = true
    },
    {
      type        = "anthropic_message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "anthropic_message"
      role    = "assistant"
      content = "Hi! How are you?"
    },
  ]
}

resource "testllm_test" "claude_simple_state" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.claude.id
  name     = "simple-state"

  items = [
    {
      type        = "anthropic_system"
      text        = ""
      any_content = true
    },
    {
      type        = "anthropic_message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "anthropic_message"
      role    = "assistant"
      content = "Hi! How are you?"
    },
    {
      type        = "anthropic_message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "anthropic_message"
      role    = "assistant"
      content = "How can I help you?"
    },
  ]
}

resource "testllm_test" "claude_mcp_tools_test" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.claude.id
  name     = "mcp-tools-test"

  items = [
    {
      type        = "anthropic_system"
      text        = ""
      any_content = true
    },
    {
      type        = "anthropic_message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type = "anthropic_message"
      role = "assistant"
      content_blocks = jsonencode([
        {
          type = "tool_use"
          id   = "tool_mem_001"
          name = "mcp__memory__create_entities"
          input = {
            entities = [
              {
                name         = "test_project"
                entityType   = "project"
                observations = ["A test project"]
              }
            ]
          }
        }
      ])
    },
    {
      type        = "anthropic_message"
      role        = "user"
      any_content = true
      content_blocks = jsonencode([
        {
          type        = "tool_result"
          tool_use_id = "tool_mem_001"
          content = jsonencode({
            entities = [
              {
                name         = "test_project"
                entityType   = "project"
                observations = ["A test project"]
              }
            ]
          })
        }
      ])
    },
    {
      type = "anthropic_message"
      role = "assistant"
      content_blocks = jsonencode([
        {
          type = "tool_use"
          id   = "tool_fs_001"
          name = "mcp__filesystem__list_directory"
          input = {
            path = "/test-data"
          }
        }
      ])
    },
    {
      type        = "anthropic_message"
      role        = "user"
      any_content = true
      content_blocks = jsonencode([
        {
          type        = "tool_result"
          tool_use_id = "tool_fs_001"
          content     = jsonencode({ content = "[FILE] hello.txt" })
        }
      ])
    },
    {
      type    = "anthropic_message"
      role    = "assistant"
      content = "I've created the entity 'test_project' (type: project) with the observation 'A test project'. The /test-data directory contains one file: hello.txt."
    },
  ]
}
