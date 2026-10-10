"""CSV parsing and data transformation service."""

import uuid
from pathlib import Path
from typing import BinaryIO

import pandas as pd

from app.core.models import Dataset, DatasetMetadata, DatasetPreview


def parse_csv_file(file: BinaryIO, filename: str) -> Dataset:
    """
    Parse uploaded CSV file into structured Dataset.

    Args:
        file: Binary file object from upload
        filename: Original filename

    Returns:
        Dataset with metadata and preview

    Raises:
        ValueError: If CSV is invalid or empty
        pd.errors.ParserError: If CSV parsing fails
    """
    try:
        df = pd.read_csv(file)
    except pd.errors.ParserError as e:
        raise ValueError(f"Invalid CSV format: {e}") from e

    if df.empty:
        raise ValueError("CSV file is empty")

    if len(df.columns) == 0:
        raise ValueError("CSV has no columns")

    dataset_id = str(uuid.uuid4())
    row_count = len(df)
    column_count = len(df.columns)
    columns = df.columns.tolist()
    dtypes = {col: str(dtype) for col, dtype in df.dtypes.items()}

    head_rows = df.head(10).to_dict(orient="records")
    tail_rows = df.tail(10).to_dict(orient="records")

    metadata = DatasetMetadata(
        filename=filename,
        row_count=row_count,
        column_count=column_count,
        columns=columns,
        dtypes=dtypes,
    )

    preview = DatasetPreview(head=head_rows, tail=tail_rows)

    return Dataset(id=dataset_id, metadata=metadata, preview=preview)


def save_uploaded_file(file: BinaryIO, filename: str, data_dir: Path) -> Path:
    """
    Save uploaded file to data directory.

    Args:
        file: Binary file object
        filename: Original filename
        data_dir: Directory to save file

    Returns:
        Path to saved file
    """
    data_dir.mkdir(parents=True, exist_ok=True)
    unique_filename = f"{uuid.uuid4()}_{filename}"
    file_path = data_dir / unique_filename

    with open(file_path, "wb") as f:
        f.write(file.read())

    file.seek(0)
    return file_path
