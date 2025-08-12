from .base import LLMClient, LLMResponse

class GPTClient(LLMClient):
    provider_name = "openai"

    def __init__(self, model: str = "gpt-4o") -> None:
        self.model = model

    def complete(self, prompt: str, **kwargs) -> LLMResponse:
        return LLMResponse(text=f"[GPT:{self.model}] {prompt[:60]}...")
