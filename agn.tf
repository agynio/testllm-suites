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

resource "testllm_test" "agn_mcp_tools_test" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "mcp-tools-test"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "Create an entity called test_project of type project with observation 'A test project', then list files in /test-data"
    },
    {
      type      = "function_call"
      func_name = "create_entities"
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
      func_name = "list_directory"
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

resource "testllm_test" "agn_shell_threads_send" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "shell-threads-send"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "Send me an intermediate update then reply"
    },
    {
      type      = "function_call"
      func_name = "shell"
      call_id   = "fc_shell_001"
      arguments = "{\"command\": \"agyn threads send --message \\\"Thinking\\\" > /dev/null && echo ok\"}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_shell_001"
      output  = "{\"exit_code\":0,\"stdout\":\"ok\\n\",\"stderr\":\"\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Done thinking. Here is my reply."
    },
  ]
}

resource "testllm_test" "agn_reminders_agent_loop" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "reminders-agent-loop"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "Schedule a short reminder and acknowledge it when it arrives."
    },
    {
      type      = "function_call"
      func_name = "shell"
      call_id   = "fc_shell_reminder_001"
      arguments = "{\"command\": \"wget -q --header=\\\"Content-Type: application/json\\\" --header=\\\"x-organization-id: $AGYN_ORGANIZATION_ID\\\" --header=\\\"Authorization: Bearer $AGYN_API_TOKEN\\\" --post-data \\\"{\\\\\\\"thread_id\\\\\\\":\\\\\\\"$THREAD_ID\\\\\\\",\\\\\\\"delay_seconds\\\\\\\":3,\\\\\\\"note\\\\\\\":\\\\\\\"$REMINDER_NOTE\\\\\\\"}\\\" \\\"$AGYN_BASE_URL/apps/reminders/create-reminder\\\" > /dev/null && echo ok\"}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_shell_reminder_001"
      output  = "{\"exit_code\":0,\"stdout\":\"ok\\n\",\"stderr\":\"\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Scheduled. I will reply when the reminder arrives."
    },
    {
      type        = "message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Acknowledged: reminder received."
    },
  ]
}

resource "testllm_test" "agn_shell_agyn_thread_create_wait" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "shell-agyn-thread-create-wait"

  items = [
    {
      type        = "message"
      role        = "user"
      content     = ""
      any_content = true
    },
    {
      type      = "function_call"
      func_name = "shell"
      call_id   = "fc_shell_agyn_wait_001"
      arguments = "{\"command\": \"agyn threads create --organization-id \\\"$AGYN_ORGANIZATION_ID\\\" --add @e2e-agyn-wait-b-fixed --ref e2e-agyn-wait-fixed --send \\\"Please reply with e2e-agyn-wait-sentinel-fixed\\\" --wait 120 && echo ok\", \"timeout\": 150}"
    },
    {
      type    = "function_call_output"
      call_id = "fc_shell_agyn_wait_001"
      output  = "{\"exit_code\":0,\"stdout\":\"from: agent\\nAgent B received the agyn wait check-in.\\nok\\n\",\"stderr\":\"\"}"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Agent B replied successfully via agyn --wait."
    },
  ]
}

resource "testllm_test" "agn_agyn_wait_agent_b_reply" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "agyn-wait-agent-b-reply"

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
      content = "Agent B received the agyn wait check-in."
    },
  ]
}
