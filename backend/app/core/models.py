"""Pydantic data models for API validation and serialization."""

from typing import Any
from pydantic import BaseModel, Field


class DatasetMetadata(BaseModel):
    """Metadata about an uploaded dataset."""

    filename: str = Field(..., description="Original filename")
    row_count: int = Field(..., description="Number of rows", ge=0)
    column_count: int = Field(..., description="Number of columns", ge=0)
    columns: list[str] = Field(..., description="Column names")
    dtypes: dict[str, str] = Field(
        default_factory=dict, description="Data types per column"
    )


class DatasetPreview(BaseModel):
    """Preview of dataset rows."""

    head: list[dict[str, Any]] = Field(
        default_factory=list, description="First 10 rows as dict records"
    )
    tail: list[dict[str, Any]] = Field(
        default_factory=list, description="Last 10 rows as dict records"
    )


class Dataset(BaseModel):
    """Complete dataset response."""

    id: str = Field(..., description="Unique dataset identifier")
    metadata: DatasetMetadata
    preview: DatasetPreview


class UploadResponse(BaseModel):
    """Response after successful file upload."""

    dataset: Dataset
    message: str = Field(default="Dataset uploaded successfully")
