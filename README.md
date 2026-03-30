# testllm-suites

Deterministic LLM conversation sequences for E2E testing, managed as Terraform resources.

This repository defines **test suites** and **tests** for [TestLLM](https://github.com/agynio/testllm) — a service that replaces real LLM providers during E2E runs by replaying scripted responses. Each test is an ordered sequence of messages (user, assistant, system) and function calls that an agent will encounter during a test run.

## Ecosystem

| Repository | Role |
|---|---|
| [`agynio/testllm`](https://github.com/agynio/testllm) | TestLLM service — OpenAI-compatible Responses API backed by predefined sequences |
| **`agynio/testllm-suites`** (this repo) | Test suite and test definitions, managed via Terraform |
| [`agynio/terraform-provider-testllm`](https://github.com/agynio/terraform-provider-testllm) | Terraform provider for TestLLM resources (`testllm_test_suite`, `testllm_test`, etc.) |

During E2E runs, platform agents are configured to hit TestLLM instead of a real LLM provider. TestLLM matches incoming requests against the sequences defined here and returns the scripted response. On mismatch it returns an error with a detailed diff — making agent behavior fully deterministic and assertable. See the [E2E testing architecture doc](https://github.com/agynio/architecture/blob/main/architecture/operations/e2e-testing.md#deterministic-llm-testllm) for the full design.

## Repository Structure

```
.
├── main.tf          # Provider config and organization data source
├── variables.tf     # Input variables (api_token, org_slug)
├── agn.tf           # "agn" test suite and its tests
├── codex.tf         # "codex" test suite and its tests
└── .gitignore
```

- **`main.tf`** — Declares the `testllm` provider (source: `agynio/testllm`, currently v0.3.0) and looks up the organization by slug.
- **`variables.tf`** — Defines `api_token` (sensitive) and `org_slug`, both supplied by Terraform Cloud workspace variables.
- **One `.tf` file per test suite** — Each file creates a `testllm_test_suite` resource and all `testllm_test` resources that belong to it.

## CI — Terraform Cloud

This repository is connected to a **Terraform Cloud** workspace with a VCS-driven workflow. No local `terraform apply` is needed.

| Event | What happens |
|---|---|
| **Pull request opened/updated** | Terraform Cloud runs a **speculative plan** and posts the result as a PR check. Review the plan diff before merging. |
| **Merge to `main`** | Terraform Cloud runs a plan and **auto-applies** it. Changes are live immediately after merge. |

> **There is no manual apply step.** Merging to `main` is deploying. Review plans carefully in PRs.

## Adding a New Test Suite

1. Create a new file `<suite-name>.tf` in the repository root.
2. Define a `testllm_test_suite` resource and one or more `testllm_test` resources:

```hcl
resource "testllm_test_suite" "my_suite" {
  org_id = data.testllm_organization.org.id
  name   = "my-suite"
}

resource "testllm_test" "my_suite_basic_flow" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.my_suite.id
  name     = "basic-flow"

  items = [
    {
      type    = "message"
      role    = "user"
      content = "hello"
    },
    {
      type    = "message"
      role    = "assistant"
      content = "Hello! How can I help you?"
    },
  ]
}
```

3. Open a PR. Terraform Cloud will show the plan with the new resources.
4. Merge. The suite and tests are created in TestLLM automatically.

## Adding a Test to an Existing Suite

Add a new `testllm_test` resource in the suite's `.tf` file, referencing the existing suite:

```hcl
resource "testllm_test" "agn_new_scenario" {
  org_id   = data.testllm_organization.org.id
  suite_id = testllm_test_suite.agn.id
  name     = "new-scenario"

  items = [
    # ... conversation sequence
  ]
}
```

## Test Item Types

Each test is a sequence of `items`. The provider supports these item types:

### Message

A chat message with a role.

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | `"message"` | yes | Item type |
| `role` | `"user"` \| `"assistant"` \| `"system"` \| `"developer"` | yes | Message role |
| `content` | string | yes | Message content (can be `""` if `any_content = true`) |
| `any_content` | bool | no | When `true`, TestLLM accepts any content for this position |

### Function Call

An assistant-initiated tool/function call.

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | `"function_call"` | yes | Item type |
| `func_name` | string | yes | Function name |
| `call_id` | string | yes | Call ID (used to match with output) |
| `arguments` | string (JSON) | yes | Function arguments as JSON string |

### Function Call Output

The result of a function call.

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | `"function_call_output"` | yes | Item type |
| `call_id` | string | yes | Matches the `call_id` of the corresponding `function_call` |
| `output` | string (JSON) | yes | Function output as JSON string |

## Naming Conventions

- **Terraform resource names**: `<suite>_<descriptive_name>` — e.g., `testllm_test.agn_simple_hello`.
- **Test `name` attribute**: Kebab-case — e.g., `"simple-hello"`, `"summarize-agent"`.
- **Suite `name` attribute**: Short lowercase identifier — e.g., `"agn"`, `"codex"`.
- **One file per suite**: The filename matches the suite name — `agn.tf`, `codex.tf`.

## Related Documentation

- [E2E Testing Architecture](https://github.com/agynio/architecture/blob/main/architecture/operations/e2e-testing.md) — Full design for in-cluster E2E tests and how TestLLM fits in.
- [TestLLM Service](https://github.com/agynio/testllm) — The deterministic LLM service itself.
- [Terraform Provider for TestLLM](https://github.com/agynio/terraform-provider-testllm) — Provider documentation and resource schemas.
