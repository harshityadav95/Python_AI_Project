from __future__ import annotations
from typing import Sequence

def build_few_shot(examples: Sequence[tuple[str, str]], question: str) -> str:
    parts = ["You are a helpful assistant. Examples:"]
    for i, (inp, out) in enumerate(examples, 1):
        parts.append(f"Example {i}:\nQ: {inp}\nA: {out}")
    parts.append(f"Q: {question}\nA:")
    return "\n\n".join(parts)
