class ProjectError(Exception):
    """Base project error."""

class RetryableError(ProjectError):
    """Indicates an operation can be retried."""
