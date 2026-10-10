"""Tests for dataset upload endpoint."""

from io import BytesIO

import pytest
from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_root_endpoint() -> None:
    """Test root health check endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "message": "pgobi API is running",
    }


def test_health_endpoint() -> None:
    """Test health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_upload_valid_csv() -> None:
    """Test uploading a valid CSV file."""
    csv_content = b"col1,col2,col3\n1,2,3\n4,5,6\n7,8,9\n"
    files = {"file": ("test.csv", BytesIO(csv_content), "text/csv")}

    response = client.post("/api/datasets", files=files)

    assert response.status_code == 201
    data = response.json()

    assert "dataset" in data
    assert "message" in data
    assert data["message"] == "Dataset uploaded successfully"

    dataset = data["dataset"]
    assert "id" in dataset
    assert "metadata" in dataset
    assert "preview" in dataset

    metadata = dataset["metadata"]
    assert metadata["filename"] == "test.csv"
    assert metadata["row_count"] == 3
    assert metadata["column_count"] == 3
    assert metadata["columns"] == ["col1", "col2", "col3"]

    preview = dataset["preview"]
    assert "head" in preview
    assert "tail" in preview
    assert len(preview["head"]) == 3


def test_upload_no_file() -> None:
    """Test upload without a file."""
    response = client.post("/api/datasets")
    assert response.status_code == 422


def test_upload_non_csv_file() -> None:
    """Test uploading a non-CSV file."""
    files = {"file": ("test.txt", BytesIO(b"not a csv"), "text/plain")}
    response = client.post("/api/datasets", files=files)
    assert response.status_code == 400
    assert "Only CSV files are supported" in response.json()["detail"]


def test_upload_empty_csv() -> None:
    """Test uploading an empty CSV file."""
    csv_content = b""
    files = {"file": ("empty.csv", BytesIO(csv_content), "text/csv")}

    response = client.post("/api/datasets", files=files)
    assert response.status_code == 400


def test_upload_csv_with_headers_only() -> None:
    """Test uploading CSV with headers but no data rows."""
    csv_content = b"col1,col2,col3\n"
    files = {"file": ("headers.csv", BytesIO(csv_content), "text/csv")}

    response = client.post("/api/datasets", files=files)
    assert response.status_code == 400
    assert "empty" in response.json()["detail"].lower()
