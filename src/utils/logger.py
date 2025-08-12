from __future__ import annotations
import logging
import logging.config
import yaml
from pathlib import Path

def setup_logging(config_path: str = "config/logging_config.yaml"):
    p = Path(config_path)
    if p.exists():
        with p.open() as f:
            cfg = yaml.safe_load(f)
        logging.config.dictConfig(cfg)
    else:
        logging.basicConfig(level=logging.INFO)
    return logging.getLogger("app")
