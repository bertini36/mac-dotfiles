---
name: python-code-style
description: Python code style, linting, formatting, naming conventions, documentation standards, and type safety. Use when writing new code, reviewing style, configuring linters, writing docstrings, adding type annotations, implementing generic classes, defining structural interfaces, or establishing project standards.
---

# Python Code Style, Documentation & Type Safety

Consistent code style, clear documentation, and a strong type system make Python codebases maintainable and collaborative. This skill covers modern Python tooling, naming conventions, documentation standards, and type annotations.

## When to Use This Skill

- Setting up linting and formatting for a new project
- Writing or reviewing docstrings
- Establishing team coding standards
- Configuring ruff, mypy, or pyright
- Reviewing code for style consistency
- Adding type hints to existing code
- Creating generic, reusable classes
- Defining structural interfaces with protocols
- Understanding type narrowing and guards
- Building type-safe APIs and libraries

## Core Concepts

### 1. Automated Formatting

Let tools handle formatting debates. Configure once, enforce automatically.

### 2. Consistent Naming

Follow PEP 8 conventions with meaningful, descriptive names.

### 3. Documentation as Code

Docstrings should be maintained alongside the code they describe.

### 4. Type Annotations

Modern Python code should include type hints for all public APIs. Type annotations serve as enforced documentation that tooling validates automatically.

## Quick Start

```bash
# Install modern tooling
pip install ruff mypy

# Configure in pyproject.toml
[tool.ruff]
line-length = 120
target-version = "py312"  # Adjust based on your project's minimum Python version

[tool.mypy]
strict = true
```

## Style Patterns

### Pattern 1: Modern Python Tooling

Use `ruff` as an all-in-one linter and formatter. It replaces flake8, isort, and black with a single fast tool.

```toml
# pyproject.toml
[tool.ruff]
line-length = 120
target-version = "py312"  # Adjust based on your project's minimum Python version

[tool.ruff.lint]
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # pyflakes
    "I",    # isort
    "B",    # flake8-bugbear
    "C4",   # flake8-comprehensions
    "UP",   # pyupgrade
    "SIM",  # flake8-simplify
]
ignore = ["E501"]  # Line length handled by formatter

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

Run with:

```bash
ruff check --fix .  # Lint and auto-fix
ruff format .       # Format code
```

### Pattern 2: Type Checking Configuration

Configure strict type checking for production code.

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_ignores = true
disallow_untyped_defs = true
disallow_incomplete_defs = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```

Alternative: Use `pyright` for faster checking.

```toml
[tool.pyright]
pythonVersion = "3.12"
typeCheckingMode = "strict"
```

### Pattern 3: Naming Conventions

Follow PEP 8 with emphasis on clarity over brevity.

**Files and Modules:**

```python
# Good: Descriptive snake_case
user_repository.py
order_processing.py
http_client.py

# Avoid: Abbreviations
usr_repo.py
ord_proc.py
http_cli.py
```

**Classes and Functions:**

```python
# Classes: PascalCase
class UserRepository:
    pass

class HTTPClientFactory:  # Acronyms stay uppercase
    pass

# Functions and variables: snake_case
def get_user_by_email(email: str) -> User | None:
    retry_count = 3
    max_connections = 100
```

Private functions used only within a module have to be prefixed with `_`:

```python
def _normalize_email(email: str) -> str:
    return email.strip().lower()
```

The idea is that giving a module the coder can know which functions are meant to be used outside of the module and which are only for internal use. This is a convention, not an enforcement, but it helps signal intent.

**Variables:**

Never prefix variables with `_`. The underscore prefix is reserved exclusively for functions intended for local/internal use within a module.

```python
# Bad
_count = 0
_result = compute()

# Good
count = 0
result = compute()
```

**Constants:**

Never prepend constants with `_` to indicate "private" — use module-level constants without underscores.

```python
# Module-level constants: SCREAMING_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
DEFAULT_TIMEOUT_SECONDS = 30
API_BASE_URL = "https://api.example.com"
```

### Pattern 4: Import Organization

Group imports in a consistent order: standard library, third-party, local.

```python
# Standard library
import os
from collections.abc import Callable
from typing import Any

# Third-party packages
import httpx
from pydantic import BaseModel
from sqlalchemy import Column

# Local imports
from myproject.models import User
from myproject.services import UserService
```

Use absolute imports exclusively:

```python
# Preferred
from myproject.utils import retry_decorator

# Avoid relative imports
from ..utils import retry_decorator
```

### Pattern 5: Google-Style Docstrings

Write docstrings for all public classes, methods, and functions which name is not self-explanatory or that have non-obvious behavior. Use Google style for consistency and readability.

**Simple Function:**

```python
def get_user(user_id: str) -> User:
    """Retrieve a user by their unique identifier."""
    ...
```

**Complex Function:**

```python
def process_batch(
    items: list[Item],
    max_workers: int = 4,
    on_progress: Callable[[int, int], None] | None = None,
) -> BatchResult:
    """Process items concurrently using a worker pool.

    Processes each item in the batch using the configured number of
    workers. Progress can be monitored via the optional callback.

    Args:
        items: The items to process. Must not be empty.
        max_workers: Maximum concurrent workers. Defaults to 4.
        on_progress: Optional callback receiving (completed, total) counts.

    Returns:
        BatchResult containing succeeded items and any failures with
        their associated exceptions.

    Raises:
        ValueError: If items is empty.
        ProcessingError: If the batch cannot be processed.

    Example:
        >>> result = process_batch(items, max_workers=8)
        >>> print(f"Processed {len(result.succeeded)} items")
    """
    ...
```

**Class Docstring:**

```python
class UserService:
    """Service for managing user operations.

    Provides methods for creating, retrieving, updating, and
    deleting users with proper validation and error handling.

    Attributes:
        repository: The data access layer for user persistence.
        logger: Logger instance for operation tracking.

    Example:
        >>> service = UserService(repository, logger)
        >>> user = service.create_user(CreateUserInput(...))
    """

    def __init__(self, repository: UserRepository, logger: Logger) -> None:
        """Initialize the user service.

        Args:
            repository: Data access layer for users.
            logger: Logger for tracking operations.
        """
        self.repository = repository
        self.logger = logger
```

### Pattern 6: Comments

Add comments only when the code itself doesn't reveal the intention. Avoid commenting every line, and never add comments in tests — test names and structure should be self-explanatory.

**Before adding a comment, always ask: can the code itself be made clearer?** If you feel the urge to explain what a variable, function, or block does, that's a signal the code isn't expressive enough. Try these in order before reaching for a comment:

1. **Rename** — a better name often makes the comment redundant
2. **Extract a function** — if a block needs explaining, it probably deserves its own named function
3. **Introduce an abstraction** — a well-named variable, constant, or helper can replace an explanatory comment

A comment is a last resort, not a first response to unclear code.

```python
# Bad: comment compensates for a poor name
x += 1  # include the requesting user
grp = get_members()  # get all users in the group

# Better: rename so the comment is unnecessary
requesting_user_count += 1
group_members = get_members()

# Bad: comment explains what a block does
# validate and normalize the address
if not address.strip():
    raise ValueError("empty")
address = address.strip().title()

# Better: extract a function with a descriptive name
address = validate_and_normalize_address(address)

# Bad: comment explains a magic value
if len(records) > 99:  # Salesforce API hard limit
    ...

# Better: introduce a named constant
SALESFORCE_MAX_BATCH_SIZE = 99
if len(records) > SALESFORCE_MAX_BATCH_SIZE:
    ...

# Comment only what code structure alone can't express: *why*, not *what*
retry_delay *= 2  # exponential backoff to avoid thundering herd
batch_size = 99   # Salesforce API hard limit per request

# Bad: comment restates what the code already says
user_count += 1  # increment user count
users = db.get_all_users()  # get all users from database

# Bad: comments in tests
def test_create_user():
    # create a user with valid data
    user = create_user(email="test@example.com")
    # assert the user was created
    assert user.id is not None

# Good: test name and structure speak for themselves
def test_create_user_returns_id_when_email_is_valid():
    user = create_user(email="test@example.com")
    assert user.id is not None
```

**Rules of thumb:**
- The urge to comment is a code smell — try renaming, extracting a function, or introducing an abstraction first; add a comment only if none of those help
- Comments in tests are a sign the test needs a better name or to be split
- Comment complex algorithms, non-obvious workarounds, or business rules that can't be expressed in code

### Pattern 7: Line Length and Formatting

Set line length to 120 characters for modern displays while maintaining readability.

```python
# Good: Readable line breaks
def create_user(
    email: str,
    name: str,
    role: UserRole = UserRole.MEMBER,
    notify: bool = True,
) -> User:
    ...

# Good: Chain method calls clearly
result = (
    db.query(User)
    .filter(User.active == True)
    .order_by(User.created_at.desc())
    .limit(10)
    .all()
)

# Good: Format long strings
error_message = (
    f"Failed to process user {user_id}: "
    f"received status {response.status_code} "
    f"with body {response.text[:100]}"
)
```

### Pattern 8: Project Documentation

**README Structure:**

```markdown
# Project Name

Brief description of what the project does.

## Installation

\`\`\`bash
pip install myproject
\`\`\`

## Quick Start

\`\`\`python
from myproject import Client

client = Client(api_key="...")
result = client.process(data)
\`\`\`

## Configuration

Document environment variables and configuration options.

## Development

\`\`\`bash
pip install -e ".[dev]"
pytest
\`\`\`
```

**CHANGELOG Format (Keep a Changelog):**

```markdown
# Changelog

## [Unreleased]

### Added
- New feature X

### Changed
- Modified behavior of Y

### Fixed
- Bug in Z
```

## Type Safety Patterns

### Pattern 9: Annotate All Public Signatures

Every public function, method, and class should have type annotations.

```python
def get_user(user_id: str) -> User:
    """Retrieve user by ID."""
    ...

def process_batch(
    items: list[Item],
    max_workers: int = 4,
) -> BatchResult[ProcessedItem]:
    """Process items concurrently."""
    ...

class UserRepository:
    def __init__(self, db: Database) -> None:
        self._db = db

    async def find_by_id(self, user_id: str) -> User | None:
        """Return User if found, None otherwise."""
        ...

    async def save(self, user: User) -> User:
        """Save and return user with generated ID."""
        ...
```

Use `mypy --strict` or `pyright` in CI to catch type errors early. For existing projects, enable strict mode incrementally using per-module overrides.

### Pattern 10: Use Modern Union Syntax

Python 3.10+ provides cleaner union syntax.

```python
# Preferred (3.10+)
def find_user(user_id: str) -> User | None:
    ...

def parse_value(v: str) -> int | float | str:
    ...

# Older style (still valid, needed for 3.9)
from typing import Optional, Union

def find_user(user_id: str) -> Optional[User]:
    ...
```

### Pattern 11: Type Narrowing with Guards

Use conditionals to narrow types for the type checker.

```python
def process_user(user_id: str) -> UserData:
    user = find_user(user_id)

    if user is None:
        raise UserNotFoundError(f"User {user_id} not found")

    # Type checker knows user is User here, not User | None
    return UserData(
        name=user.name,
        email=user.email,
    )

def process_items(items: list[Item | None]) -> list[ProcessedItem]:
    # Filter and narrow types
    valid_items = [item for item in items if item is not None]
    # valid_items is now list[Item]
    return [process(item) for item in valid_items]
```

### Pattern 12: Generic Classes

Create type-safe reusable containers.

```python
from typing import TypeVar, Generic

T = TypeVar("T")
E = TypeVar("E", bound=Exception)

class Result(Generic[T, E]):
    """Represents either a success value or an error."""

    def __init__(
        self,
        value: T | None = None,
        error: E | None = None,
    ) -> None:
        if (value is None) == (error is None):
            raise ValueError("Exactly one of value or error must be set")
        self._value = value
        self._error = error

    def unwrap(self) -> T:
        """Get value or raise the error."""
        if self._error is not None:
            raise self._error
        return self._value  # type: ignore[return-value]

    def unwrap_or(self, default: T) -> T:
        """Get value or return default."""
        if self._error is not None:
            return default
        return self._value  # type: ignore[return-value]

# Usage preserves types
def parse_config(path: str) -> Result[Config, ConfigError]:
    try:
        return Result(value=Config.from_file(path))
    except ConfigError as e:
        return Result(error=e)
```

### Pattern 13: Generic Repository

Create type-safe data access patterns.

```python
from typing import TypeVar, Generic
from abc import ABC, abstractmethod

T = TypeVar("T")
ID = TypeVar("ID")

class Repository(ABC, Generic[T, ID]):
    """Generic repository interface."""

    @abstractmethod
    async def get(self, id: ID) -> T | None: ...

    @abstractmethod
    async def save(self, entity: T) -> T: ...

    @abstractmethod
    async def delete(self, id: ID) -> bool: ...

class UserRepository(Repository[User, str]):
    async def get(self, id: str) -> User | None:
        row = await self._db.fetchrow("SELECT * FROM users WHERE id = $1", id)
        return User(**row) if row else None
```

### Pattern 14: TypeVar with Bounds

Restrict generic parameters to specific types.

```python
from typing import TypeVar
from pydantic import BaseModel

ModelT = TypeVar("ModelT", bound=BaseModel)

def validate_and_create(model_cls: type[ModelT], data: dict) -> ModelT:
    """Create a validated Pydantic model from dict."""
    return model_cls.model_validate(data)

# user is typed as User
user = validate_and_create(User, {"name": "Alice", "email": "a@b.com"})

# Type error: str is not a BaseModel subclass
result = validate_and_create(str, {"name": "Alice"})  # Error!
```

### Pattern 15: Protocols for Structural Typing

Define interfaces without requiring inheritance.

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Serializable(Protocol):
    def to_dict(self) -> dict: ...

    @classmethod
    def from_dict(cls, data: dict) -> "Serializable": ...

# User satisfies Serializable without inheriting from it
class User:
    def to_dict(self) -> dict:
        return {"id": self.id, "name": self.name}

    @classmethod
    def from_dict(cls, data: dict) -> "User":
        return cls(id=data["id"], name=data["name"])

def serialize(obj: Serializable) -> str:
    return json.dumps(obj.to_dict())
```

Common protocol patterns:

```python
class Closeable(Protocol):
    def close(self) -> None: ...

class AsyncCloseable(Protocol):
    async def close(self) -> None: ...

class HasId(Protocol):
    @property
    def id(self) -> str: ...

class Comparable(Protocol):
    def __lt__(self, other: "Comparable") -> bool: ...
    def __le__(self, other: "Comparable") -> bool: ...
```

### Pattern 16: Type Aliases

Create meaningful type names.

```python
# Python 3.10+ type statement for simple aliases
type UserId = str
type UserDict = dict[str, Any]

# Python 3.12+ type statement with generics
type Handler[T] = Callable[[Request], T]

# Python 3.9-3.11 style
from typing import TypeAlias
UserId: TypeAlias = str
Handler: TypeAlias = Callable[[Request], Response]
```

### Pattern 17: Callable Types

Type function parameters and callbacks.

```python
from collections.abc import Callable, Awaitable

# Sync callback
ProgressCallback = Callable[[int, int], None]  # (current, total)

# Async callback
AsyncHandler = Callable[[Request], Awaitable[Response]]

# With named parameters (using Protocol)
class OnProgress(Protocol):
    def __call__(self, current: int, total: int, *, message: str = "") -> None: ...

def process_items(
    items: list[Item],
    on_progress: ProgressCallback | None = None,
) -> list[Result]:
    ...
```

## Best Practices Summary

**Style & Documentation:**
1. **Use ruff** - Single tool for linting and formatting
2. **120 character lines** - Modern standard for readability
3. **Descriptive names** - Clarity over brevity
4. **Absolute imports** - More maintainable than relative
5. **Google-style docstrings** - Consistent, readable documentation
6. **Document public APIs** - Every public function needs a docstring
7. **Keep docs updated** - Treat documentation as code
8. **Automate in CI** - Run linters on every commit
9. **Target Python 3.10+** - For new projects, Python 3.12+ is recommended

**Type Safety:**
1. **Annotate all public APIs** - Functions, methods, class attributes
2. **Use `T | None`** - Modern union syntax over `Optional[T]`
3. **Enable strict mypy** - Catch type errors before runtime
4. **Use generics** - Preserve type info in reusable code
5. **Define protocols** - Structural typing for interfaces
6. **Narrow types** - Use guards to help the type checker
7. **Bound type vars** - Restrict generics to meaningful types
8. **Create type aliases** - Meaningful names for complex types
9. **Minimize `Any`** - Use specific types or generics; `Any` is acceptable only for truly dynamic data or untyped third-party code
