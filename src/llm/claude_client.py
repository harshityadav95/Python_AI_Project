from .base import LLMClient, LLMResponse

class ClaudeClient(LLMClient):
    provider_name = "anthropic"

    def __init__(self, model: str = "claude-3-opus-20240229") -> None:
        self.model = model

    def complete(self, prompt: str, **kwargs) -> LLMResponse:
        return LLMResponse(text=f"[Claude:{self.model}] {prompt[:60]}...")
