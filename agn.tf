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

resource "testllm_test" "agn_summarize_agent" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "summarize-agent"

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
