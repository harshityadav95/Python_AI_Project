from __future__ import annotations

def render(template: str, **vars) -> str:
    out = template
    for k, v in vars.items():
        out = out.replace(f"{{{{{k}}}}}", str(v))
    return out
