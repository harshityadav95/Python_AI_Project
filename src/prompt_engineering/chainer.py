from __future__ import annotations
from typing import Callable, Any, List

def run_chain(steps: List[Callable[[Any], Any]], initial: Any) -> Any:
    value = initial
    for step in steps:
        value = step(value)
    return value
