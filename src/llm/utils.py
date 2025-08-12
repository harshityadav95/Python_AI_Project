from __future__ import annotations
from typing import Dict
from .gpt_client import GPTClient
from .claude_client import ClaudeClient

_CLIENTS: Dict[str, object] = {}

def get_client(name: str):
    if name in _CLIENTS:
        return _CLIENTS[name]
    if name == "gpt":
        _CLIENTS[name] = GPTClient()
    elif name == "claude":
        _CLIENTS[name] = ClaudeClient()
    else:
        raise ValueError(f"Unknown client '{name}'")
    return _CLIENTS[name]
