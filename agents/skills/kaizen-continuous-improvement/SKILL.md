---
name: kaizen-continuous-improvement
description: Guide for continuous improvement, error proofing, and standardization. Use this skill when the user wants to improve code quality, refactor, or discuss process improvements.
---

# Kaizen: Continuous Improvement

## Overview

Small improvements, continuously. Error-proof by design. Follow what works. Build only what's needed.

**Core principle:** Many small improvements beat one big change. Prevent errors at design time, not with fixes.

## When to Use

**Always applied for:**

- Code implementation and refactoring
- Architecture and design decisions
- Process and workflow improvements
- Error handling and validation

**Philosophy:** Quality through incremental progress and prevention, not perfection through massive effort.

## The Four Pillars

### 1. Continuous Improvement (Kaizen)

Small, frequent improvements compound into major gains.

#### Principles

**Incremental over revolutionary:**

- Make smallest viable change that improves quality
- One improvement at a time
- Verify each change before next
- Build momentum through small wins

**Always leave code better:**

- Fix small issues as you encounter them
- Refactor while you work (within scope)
- Update outdated comments
- Remove dead code when you see it

**Iterative refinement:**

- First version: make it work
- Second pass: make it clear
- Third pass: make it efficient
- Don't try all three at once

<Good>
```python
# Iteration 1: Make it work
def calculate_total(items):
    total = 0
    for item in items:
        total += item['price'] * item['quantity']
    return total


# Iteration 2: Make it clear (refactor)
def calculate_total(items: list) -> float:
    return sum(item['price'] * item['quantity'] for item in items)


# Iteration 3: Make it robust (add validation)
def calculate_total(items: list) -> float:
    if not items:
        return 0

    total = 0
    for item in items:
        if item['price'] < 0 or item['quantity'] < 0:
            raise ValueError('Price and quantity must be non-negative')
        total += item['price'] * item['quantity']
    return total
```
Each step is complete, tested, and working
</Good>

<Bad>
```python
# Trying to do everything at once
def calculate_total(items: list) -> float:
    # Validate, optimize, add features, handle edge cases all together
    if not items:
        return 0
    valid_items = []
    for item in items:
        if item['price'] < 0:
            raise ValueError('Negative price')
        if item['quantity'] < 0:
            raise ValueError('Negative quantity')
        if item['quantity'] > 0:  # Also filtering zero quantities
            valid_items.append(item)
    # Plus caching, plus logging, plus currency conversion...
    return sum(...)  # Too many concerns at once
```

Overwhelming, error-prone, hard to verify
</Bad>

#### In Practice

**When implementing features:**

1. Start with simplest version that works
2. Add one improvement (error handling, validation, etc.)
3. Test and verify
4. Repeat if time permits
5. Don't try to make it perfect immediately

**When refactoring:**

- Fix one smell at a time
- Commit after each improvement
- Keep tests passing throughout
- Stop when "good enough" (diminishing returns)

**When reviewing code:**

- Suggest incremental improvements (not rewrites)
- Prioritize: critical → important → nice-to-have
- Focus on highest-impact changes first
- Accept "better than before" even if not perfect

### 2. Poka-Yoke (Error Proofing)

Design systems that prevent errors at compile/design time, not runtime.

#### Principles

**Make errors impossible:**

- Type hints and runtime checks catch mistakes
- Invalid states unrepresentable
- Errors caught early (left of production)

**Design for safety:**

- Fail fast and loudly
- Provide helpful error messages
- Make correct path obvious
- Make incorrect path difficult

**Defense in layers:**

1. Type hints (static analysis)
2. Validation (runtime, early)
3. Guards (preconditions)
4. Error boundaries (graceful degradation)

#### Type System Error Proofing

<Good>
```python
from enum import Enum
from dataclasses import dataclass
from datetime import datetime

# Error: string status can be any value
class OrderBad:
    status: str  # Can be "pending", "PENDING", "pnding", anything!
    total: float

# Good: Only valid states possible
class OrderStatus(Enum):
    PENDING = "pending"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"

@dataclass
class Order:
    status: OrderStatus
    total: float

# Better: States with associated data
@dataclass
class PendingOrder:
    created_at: datetime

@dataclass
class ProcessingOrder:
    started_at: datetime
    estimated_completion: datetime

@dataclass
class ShippedOrder:
    tracking_number: str
    shipped_at: datetime

@dataclass
class DeliveredOrder:
    delivered_at: datetime
    signature: str

# Now impossible to have ShippedOrder without tracking_number
Order = PendingOrder | ProcessingOrder | ShippedOrder | DeliveredOrder
```
Type system prevents entire classes of errors
</Good>

<Good>
```python
from typing import Sequence, TypeVar

T = TypeVar('T')

def first_item(items: Sequence[T]) -> T:
    if not items:
        raise ValueError('Sequence must not be empty')
    return items[0]

# Caller must prove list is non-empty
items = [1, 2, 3]
if items:
    result = first_item(items)  # Safe
```

Function signature makes assumption explicit
</Good>

#### Validation Error Proofing

<Good>
```python
# Error: Validation after use
def process_payment(amount: float):
    fee = amount * 0.03  # Used before validation!
    if amount <= 0:
        raise ValueError('Invalid amount')
    # ...

# Good: Validate immediately
def process_payment(amount: float):
    if amount <= 0:
        raise ValueError('Payment amount must be positive')
    if amount > 10000:
        raise ValueError('Payment exceeds maximum allowed')

    fee = amount * 0.03
    # ... now safe to use

# Better: Validation at boundary with a validated type
class PositiveAmount(float):
    def __new__(cls, value: float) -> 'PositiveAmount':
        if value <= 0:
            raise ValueError('Must be positive')
        return super().__new__(cls, value)

def process_payment(amount: PositiveAmount):
    # amount is guaranteed positive, no need to check
    fee = float(amount) * 0.03

# Validate at system boundary
def handle_payment_request(request):
    amount = PositiveAmount(request.json['amount'])  # Validate once
    process_payment(amount)  # Use everywhere safely
```
Validate once at boundary, safe everywhere else
</Good>

#### Guards and Preconditions

<Good>
```python
# Early returns prevent deeply nested code
def process_user(user):
    if not user:
        logger.error('User not found')
        return

    if not user.email:
        logger.error('User email missing')
        return

    if not user.is_active:
        logger.info('User inactive, skipping')
        return

    # Main logic here, guaranteed user is valid and active
    send_email(user.email, 'Welcome!')
```

Guards make assumptions explicit and enforced
</Good>

#### Configuration Error Proofing

<Good>
```python
import os
from dataclasses import dataclass

# Error: Optional config with unsafe defaults
@dataclass
class ConfigBad:
    api_key: str | None = None
    timeout: int | None = None

client = APIClient(timeout=5000)  # api_key missing!

# Good: Required config, fails early
@dataclass
class Config:
    api_key: str
    timeout: int

def load_config() -> Config:
    api_key = os.environ.get('API_KEY')
    if not api_key:
        raise ValueError('API_KEY environment variable required')

    return Config(api_key=api_key, timeout=5000)

# App fails at startup if config invalid, not during request
config = load_config()
client = APIClient(config)
```
Fail at startup, not in production
</Good>

#### In Practice

**When designing APIs:**
- Use type hints to constrain inputs
- Make invalid states unrepresentable
- Return Result tuples instead of raising unexpectedly
- Document preconditions in types

**When handling errors:**
- Validate at system boundaries

- Use guards for preconditions
- Fail fast with clear messages
- Log context for debugging

**When configuring:**
- Required over optional with defaults
- Validate all config at startup
- Fail deployment if config invalid
- Don't allow partial configurations

### 3. Standardized Work
Follow established patterns. Document what works. Make good practices easy to follow.

#### Principles

**Consistency over cleverness:**
- Follow existing codebase patterns
- Don't reinvent solved problems
- New pattern only if significantly better
- Team agreement on new patterns

**Documentation lives with code:**
- README for setup and architecture
- CLAUDE.md for AI coding conventions
- Comments for "why", not "what"
- Examples for complex patterns

**Automate standards:**
- Linters enforce style
- Type checks enforce contracts
- Tests verify behavior
- CI/CD enforces quality gates

#### Following Patterns

<Good>
```python
# Existing codebase pattern for API clients
class UserAPIClient:
    async def get_user(self, user_id: str) -> User:
        return await self.fetch(f'/users/{user_id}')

# New code follows the same pattern
class OrderAPIClient:
    async def get_order(self, order_id: str) -> Order:
        return await self.fetch(f'/orders/{order_id}')
```

Consistency makes codebase predictable
</Good>

<Bad>
```python
# Existing pattern uses classes
class UserAPIClient:
    # ...
    pass

# New code introduces different pattern without discussion
async def get_order(order_id: str) -> Order:
    # Breaking consistency "because I prefer functions"
    pass
```
Inconsistency creates confusion
</Bad>

#### Error Handling Patterns

<Good>
```python
from dataclasses import dataclass
from typing import Generic, TypeVar

T = TypeVar('T')
E = TypeVar('E')

@dataclass
class Ok(Generic[T]):
    value: T
    ok: bool = True

@dataclass
class Err(Generic[E]):
    error: E
    ok: bool = False

# All services follow this pattern
async def fetch_user(user_id: str) -> Ok | Err:
    try:
        user = await db.users.find_by_id(user_id)
        if not user:
            return Err(error=Exception('User not found'))
        return Ok(value=user)
    except Exception as err:
        return Err(error=err)

# Callers use consistent pattern
result = await fetch_user('123')
if not result.ok:
    logger.error('Failed to fetch user', result.error)
    return
user = result.value  # Type-safe!
```

Standard pattern across codebase
</Good>

#### Documentation Standards

<Good>
```python
from dataclasses import dataclass
from typing import TypeVar, Callable, Awaitable

T = TypeVar('T')

@dataclass
class RetryOptions:
    max_attempts: int
    base_delay: float  # seconds

async def retry(operation: Callable[[], Awaitable[T]], options: RetryOptions) -> T:
    """
    Retries an async operation with exponential backoff.

    Why: Network requests fail temporarily; retrying improves reliability.
    When to use: External API calls, database operations.
    When not to use: User input validation, internal function calls.

    Example:
        result = await retry(
            lambda: fetch('https://api.example.com/data'),
            RetryOptions(max_attempts=3, base_delay=1.0)
        )
    """
    # Implementation...
```
Documents why, when, and how
</Good>

#### In Practice

**Before adding new patterns:**

- Search codebase for similar problems solved
- Check CLAUDE.md for project conventions
- Discuss with team if breaking from pattern
- Update docs when introducing new pattern

**When writing code:**

- Match existing file structure
- Use same naming conventions
- Follow same error handling approach
- Import from same locations

**When reviewing:**

- Check consistency with existing code
- Point to examples in codebase
- Suggest aligning with standards
- Update CLAUDE.md if new standard emerges

### 4. Just-In-Time (JIT)

Build what's needed now. No more, no less. Avoid premature optimization and over-engineering.

#### Principles

**YAGNI (You Aren't Gonna Need It):**

- Implement only current requirements
- No "just in case" features
- No "we might need this later" code
- Delete speculation

**Simplest thing that works:**

- Start with straightforward solution
- Add complexity only when needed
- Refactor when requirements change
- Don't anticipate future needs

**Optimize when measured:**

- No premature optimization
- Profile before optimizing
- Measure impact of changes
- Accept "good enough" performance

#### YAGNI in Action

<Good>
```python
# Current requirement: Log errors to console
import sys

def log_error(error: Exception) -> None:
    print(f"ERROR: {error}", file=sys.stderr)
```
Simple, meets current need
</Good>

<Bad>
```python
# Over-engineered for "future needs"
from abc import ABC, abstractmethod
from enum import Enum
from typing import Any

class LogLevel(Enum):
    DEBUG = "debug"
    INFO = "info"
    ERROR = "error"

class LogTransport(ABC):
    @abstractmethod
    async def write(self, level: LogLevel, message: str, meta: dict[str, Any] | None = None) -> None: ...

class ConsoleTransport(LogTransport): ...  # implementation
class FileTransport(LogTransport): ...     # implementation
class RemoteTransport(LogTransport): ...   # implementation

class Logger:
    def __init__(self):
        self._transports: list[LogTransport] = []
        self._queue: list[dict] = []
        self._rate_limiter = RateLimiter()
        self._formatter = LogFormatter()
        # 200 lines of code for "maybe we'll need it"

def log_error(error: Exception) -> None:
    Logger.get_instance().log(LogLevel.ERROR, str(error))
```
Building for imaginary future requirements
</Bad>

**When to add complexity:**
- Current requirement demands it
- Pain points identified through use
- Measured performance issues
- Multiple use cases emerged

<Good>
```python
# Start simple
def format_currency(amount: float) -> str:
    return f'${amount:.2f}'

# Requirement evolves: support multiple currencies
def format_currency(amount: float, currency: str) -> str:
    symbols = {'USD': '$', 'EUR': '€', 'GBP': '£'}
    return f'{symbols[currency]}{amount:.2f}'

# Requirement evolves: support localization
import locale as locale_module

def format_currency(amount: float, locale: str) -> str:
    locale_module.setlocale(locale_module.LC_ALL, locale)
    return locale_module.currency(amount, grouping=True)
```

Complexity added only when needed
</Good>

#### Premature Abstraction

<Bad>
```python
from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar('T')

# One use case, but building generic framework
class BaseCRUDService(ABC, Generic[T]):
    @abstractmethod
    async def get_all(self) -> list[T]: ...
    @abstractmethod
    async def get_by_id(self, id: str) -> T: ...
    @abstractmethod
    async def create(self, data: dict) -> T: ...
    @abstractmethod
    async def update(self, id: str, data: dict) -> T: ...
    @abstractmethod
    async def delete(self, id: str) -> None: ...

class GenericRepository(Generic[T]): ...  # 300 lines
class QueryBuilder(Generic[T]): ...       # 200 lines
# ... building entire ORM for single table
```
Massive abstraction for uncertain future
</Bad>

<Good>
```python
# Simple functions for current needs
async def get_users() -> list[User]:
    return await db.query('SELECT * FROM users')

async def get_user_by_id(user_id: str) -> User | None:
    return await db.query('SELECT * FROM users WHERE id = $1', [user_id])

# When pattern emerges across multiple entities, then abstract
```

Abstract only when pattern proven across 3+ cases
</Good>

#### Performance Optimization

<Good>
```python
# Current: Simple approach
def filter_active_users(users: list[User]) -> list[User]:
    return [user for user in users if user.is_active]

# Benchmark shows: 50ms for 1000 users (acceptable)
# Ship it, no optimization needed

# Later: After profiling shows this is bottleneck
# Then optimize with indexed lookup or caching
```
Optimize based on measurement, not assumptions
</Good>

<Bad>
```python
# Premature optimization
def filter_active_users(users: list[User]) -> list[User]:
    # "This might be slow, so let's cache and index"
    cache = {}
    indexed = build_btree_index(users, 'is_active')
    # 100 lines of optimization code
    # Adds complexity, harder to maintain
    # No evidence it was needed
```

Complex solution for unmeasured problem
</Bad>

#### In Practice

**When implementing:**

- Solve the immediate problem
- Use straightforward approach
- Resist "what if" thinking
- Delete speculative code

**When optimizing:**

- Profile first, optimize second
- Measure before and after
- Document why optimization needed
- Keep simple version in tests

**When abstracting:**

- Wait for 3+ similar cases (Rule of Three)
- Make abstraction as simple as possible
- Prefer duplication over wrong abstraction
- Refactor when pattern clear

## Integration with Commands

The Kaizen skill guides how you work. The commands provide structured analysis:

- **`/why`**: Root cause analysis (5 Whys)
- **`/cause-and-effect`**: Multi-factor analysis (Fishbone)
- **`/plan-do-check-act`**: Iterative improvement cycles
- **`/analyse-problem`**: Comprehensive documentation (A3)
- **`/analyse`**: Smart method selection (Gemba/VSM/Muda)

Use commands for structured problem-solving. Apply skill for day-to-day development.

## Red Flags

**Violating Continuous Improvement:**

- "I'll refactor it later" (never happens)
- Leaving code worse than you found it
- Big bang rewrites instead of incremental

**Violating Poka-Yoke:**

- "Users should just be careful"
- Validation after use instead of before
- Optional config with no validation

**Violating Standardized Work:**

- "I prefer to do it my way"
- Not checking existing patterns
- Ignoring project conventions

**Violating Just-In-Time:**

- "We might need this someday"
- Building frameworks before using them
- Optimizing without measuring

## Remember

**Kaizen is about:**

- Small improvements continuously
- Preventing errors by design
- Following proven patterns
- Building only what's needed

**Not about:**

- Perfection on first try
- Massive refactoring projects
- Clever abstractions
- Premature optimization

**Mindset:** Good enough today, better tomorrow. Repeat.
