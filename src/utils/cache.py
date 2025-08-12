from __future__ import annotations
from functools import lru_cache

@lru_cache(maxsize=1024)
def cache_prompt(prompt: str) -> str:
    return prompt
