from __future__ import annotations
import time
from collections import deque

class TokenBucket:
    def __init__(self, rate: int, per: float):
        self.rate = rate
        self.per = per
        self.events = deque()

    def acquire(self):
        now = time.time()
        while self.events and now - self.events[0] > self.per:
            self.events.popleft()
        if len(self.events) >= self.rate:
            sleep_for = self.per - (now - self.events[0])
            time.sleep(max(sleep_for, 0))
        self.events.append(now)
