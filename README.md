# Generative AI Project Structure

Production-ready, extensible template for building scalable Generative AI applications in Python. Mirrors the provided reference image structure and includes conventions for prompt versioning, modular code, reproducibility, and safe iteration.

## Directory Layout
```
python_ai_project/
├── config/                 # Externalized configuration (models, prompts, logging)
│   ├── model_config.yaml
│   ├── prompt_templates.yaml
│   └── logging_config.yaml
├── src/
│   ├── llm/                # LLM client abstractions + provider wrappers
│   │   ├── base.py
│   │   ├── gpt_client.py
│   │   ├── claude_client.py
│   │   └── utils.py
│   ├── prompt_engineering/ # Templates, few-shot builders, chaining helpers
│   │   ├── templates.py
│   │   ├── few_shot.py
│   │   └── chainer.py
│   └── utils/              # Cross-cutting utilities
│       ├── rate_limiter.py
│       ├── token_counter.py
│       ├── cache.py
│       ├── logger.py
│       └── handlers/
│           └── error_handler.py
├── data/
│   ├── cache/              # Ephemeral / derived cached results
│   ├── prompts/            # Versioned prompt artifacts (.yaml/.md)
│   ├── outputs/            # Saved model outputs for eval/analysis
│   └── embeddings/         # Persisted vector embeddings
├── examples/               # Runnable usage examples / smoke tests
│   ├── basic_completion.py
│   ├── chat_session.py
│   └── chain_prompts.py
├── notebooks/              # Exploration & analysis (keep transient)
├── requirements.txt        # Locked runtime dependencies (pin versions)
├── .python-version         # Target Python version (pyenv-compatible)
├── setup.sh                # Idempotent environment bootstrap script
└── README.md
```

## Key Components
| Area | Purpose |
|------|---------|
| `config/` | Centralized config; avoids hard-coded values in code. |
| `src/llm/` | Provider abstractions (replace stubs with real SDK calls). |
| `prompt_engineering/` | Reusable prompt assembly utilities (few-shot, chaining). |
| `data/prompts/` | Version-controlled prompts (treat like code). |
| `data/outputs/` | Persist outputs for regression + qualitative evaluation. |
| `examples/` | Fast feedback loops & onboarding demos. |
| `notebooks/` | Experiments; migrate stable logic back into `src/`. |
| `utils/` | Cross-cutting concerns (logging, caching, rate limiting, errors). |

## Best Practices Embedded
1. Prompt version tracking (store prompts as text/YAML, review diffs).
2. Modular boundaries (LLM clients, prompt engineering, utils).
3. Idempotent setup & reproducibility (hash-based dependency install, fixed Python version file).
4. Config outside code for easier environment-specific overrides.
5. Lightweight examples for CI smoke tests.

## Quick Start
```bash
./setup.sh -y            # bootstrap (pyenv used if available)
source venv/bin/activate # activate environment
python examples/basic_completion.py
```

## The setup.sh Script
Safe to re-run; it will:
* Detect desired Python from `.python-version` (installs via pyenv if available).
* Create or reuse `venv/`.
* Ensure `pip` (uses `ensurepip` if missing).
* Install dependencies only when `requirements.txt` hash changes (or with `--force`).
* Provide colored output, error trapping, and optional non-interactive mode.

Flags:
* `-y/--yes` Skip confirmations
* `--force`  Force dependency reinstall even if hash unchanged

## Extending the Template
1. Replace stub completion methods with actual API calls (OpenAI, Anthropic, etc.).
2. Add retry logic (e.g., `tenacity`) around transient failures.
3. Implement disk / Redis caching for expensive prompts.
4. Introduce structured tracing / metrics (OpenTelemetry) if needed.
5. Add unit tests for prompt builders and chain logic (ensures non-regression when prompts evolve).

## Security & Compliance
* Never commit secrets; use env vars or secret managers.
* Avoid logging sensitive user data; redact or hash where needed.
* Respect provider rate limits (see `TokenBucket` placeholder—swap for distributed solution in prod).

## Roadmap Ideas
* Add CLI (Typer) for prompt experimentation & batch jobs.
* Add evaluation harness comparing model outputs over time.
* Integrate vector DB for retrieval-augmented generation.

## License
See `LICENSE` for details.

---
Enjoy building! Contributions & adaptations encouraged.
