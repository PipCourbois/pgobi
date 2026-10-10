"""Dataset upload and management endpoints."""

from pathlib import Path

from fastapi import APIRouter, File, HTTPException, UploadFile

from app.core.models import UploadResponse
from app.services.data_parser import parse_csv_file, save_uploaded_file

router = APIRouter(prefix="/api/datasets", tags=["datasets"])

DATA_DIR = Path(__file__).parent.parent.parent.parent / "data"


@router.post("", response_model=UploadResponse, status_code=201)
async def upload_dataset(file: UploadFile = File(...)) -> UploadResponse:
    """
    Upload and parse a CSV dataset.

    Args:
        file: Uploaded CSV file

    Returns:
        UploadResponse with dataset metadata and preview

    Raises:
        HTTPException: 400 if file is invalid or not CSV
        HTTPException: 500 if parsing fails
    """
    if not file.filename:
        raise HTTPException(status_code=400, detail="No filename provided")

    if not file.filename.endswith(".csv"):
        raise HTTPException(
            status_code=400, detail="Only CSV files are supported"
        )

    try:
        file_content = await file.read()
        await file.seek(0)

        from io import BytesIO

        file_stream = BytesIO(file_content)

        dataset = parse_csv_file(file_stream, file.filename)

        save_uploaded_file(BytesIO(file_content), file.filename, DATA_DIR)

        return UploadResponse(dataset=dataset)

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to process file: {e}"
        ) from e
