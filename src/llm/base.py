from __future__ import annotations
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Any, Dict, Iterable

@dataclass
class LLMResponse:
    text: str
    raw: Dict[str, Any] | None = None

class LLMClient(ABC):
    provider_name: str

    @abstractmethod
    def complete(self, prompt: str, **kwargs) -> LLMResponse:
        raise NotImplementedError

    def stream(self, prompt: str, **kwargs) -> Iterable[str]:
        yield self.complete(prompt, **kwargs).text
