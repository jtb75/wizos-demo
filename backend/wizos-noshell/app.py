from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI(title="Wiz OS Demo Backend")

# Enable CORS for frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to the Wiz OS Demo API"}

@app.get("/api/status")
async def get_status():
    return {
        "status": "healthy",
        "service": "backend",
        "python_version": "3.9",
        "base_image": os.getenv("BASE_IMAGE_TYPE", "unknown")
    }

@app.get("/api/message")
async def get_message():
    return {
        "message": "This backend is running on a Python 3.9 base image",
        "demo": "Wiz OS Base Layer Vulnerability Remediation",
        "tip": "Check the Dockerfile to see which base image is being used"
    }

@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}
