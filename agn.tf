resource "testllm_test_suite" "agn" {
  org_id = data.testllm_organization.org.id
  name   = "agn"
}

resource "testllm_test" "agn_simple_hello" {
  org_id   = data.testllm_organization.org.id
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
  org_id   = data.testllm_organization.org.id
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
  org_id   = data.testllm_organization.org.id
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

resource "testllm_test" "agn_summarize_agent_turn1" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-agent-turn1"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "Tell me about the history of computing in detail"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Computing began with Charles Babbage who designed the Analytical Engine in the 1830s. Ada Lovelace wrote the first algorithm. Alan Turing formalized computation in 1936. ENIAC was built in 1945. The transistor was invented in 1947 at Bell Labs. Integrated circuits followed in the late 1950s."
    },
  ]
}

resource "testllm_test" "agn_summarize_agent_turn2" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-agent-turn2"

  items = [
    {
      type        = "message"
      role        = "system"
      content     = ""
      any_content = true
    },
    {
      type    = "message"
      role    = "user"
      content = "What came next?"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "After integrated circuits came microprocessors and personal computers."
    },
  ]
}

resource "testllm_test" "agn_summarize_history" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-history"

  items = [
    {
      type        = "message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "message"
      role    = "assistant"
      content = "User asked about computing history. Key points: Babbage, Lovelace, Turing, ENIAC, transistor, ICs."
    },
  ]
}

resource "testllm_test" "agn_summarize_tool_pair_turn1" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-tool-pair-turn1"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "What is the weather in Paris right now please?"
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
      content = "The weather in Paris is currently 18\u00b0C and partly cloudy."
    },
  ]
}

resource "testllm_test" "agn_summarize_tool_pair_turn2" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-tool-pair-turn2"

  items = [
    {
      type        = "message"
      role        = "system"
      content     = ""
      any_content = true
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
      content = "The weather in Paris is currently 18\u00b0C and partly cloudy."
    },
    {
      type    = "message"
      role    = "user"
      content = "thanks"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "You're welcome!"
    },
  ]
}

resource "testllm_test" "agn_summarize_tool_pair_history" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-tool-pair-history"

  items = [
    {
      type        = "message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "message"
      role    = "assistant"
      content = "User asked about Paris weather. Tool get_weather returned 18\u00b0C partly cloudy."
    },
  ]
}
