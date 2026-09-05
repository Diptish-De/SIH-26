import os
import uuid
import shutil
from pathlib import Path
from datetime import datetime

from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="SwarSanket Voice Backend",
    description="FastAPI audio ingestion service for SwarSanket voice biomarker screening",
    version="1.0.0",
)

# Enable CORS for Vite frontend running on localhost / 127.0.0.1
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8443",
        "http://127.0.0.1:8443",
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "*",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Uploads directory
BASE_DIR = Path(__file__).resolve().parent
UPLOADS_DIR = BASE_DIR / "uploads"
UPLOADS_DIR.mkdir(parents=True, exist_ok=True)


@app.get("/api/health")
def health_check():
    return {
        "status": "ok",
        "service": "SwarSanket Voice Backend",
        "timestamp": datetime.utcnow().isoformat(),
    }


@app.post("/api/upload-audio")
async def upload_audio(audio: UploadFile = File(...)):
    """
    Accepts a multipart audio file named 'audio', saves it to backend/uploads/
    with a unique filename, and returns metadata including file path and size.
    """
    if not audio:
        raise HTTPException(status_code=400, detail="No audio file provided.")

    try:
        # Determine extension from filename or content-type
        original_name = audio.filename or "recording.webm"
        ext = Path(original_name).suffix
        if not ext:
            if "webm" in (audio.content_type or ""):
                ext = ".webm"
            elif "mp4" in (audio.content_type or "") or "m4a" in (audio.content_type or ""):
                ext = ".m4a"
            elif "wav" in (audio.content_type or ""):
                ext = ".wav"
            else:
                ext = ".webm"

        timestamp = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
        unique_id = uuid.uuid4().hex[:8]
        unique_filename = f"swarsanket_{timestamp}_{unique_id}{ext}"
        saved_path = UPLOADS_DIR / unique_filename

        # Write uploaded file to disk
        with open(saved_path, "wb") as buffer:
            shutil.copyfileobj(audio.file, buffer)

        size_bytes = os.path.getsize(saved_path)

        return {
            "success": True,
            "filename": unique_filename,
            "content_type": audio.content_type,
            "size_bytes": size_bytes,
            "saved_path": str(saved_path),
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save audio file: {str(e)}")
    finally:
        audio.file.close()


@app.post("/api/analyze-audio")
async def analyze_audio(audio: UploadFile = File(...)):
    """
    Accepts an uploaded audio file (WebM/Opus, WAV, etc.), decodes it into PCM audio,
    and returns fundamental audio metrics (sample rate, channels, duration, samples,
    RMS energy, peak amplitude, silence percentage).
    """
    if not audio:
        raise HTTPException(status_code=400, detail="No audio file provided.")

    try:
        from audio_analyzer import decode_and_inspect_audio

        content = await audio.read()
        metrics = decode_and_inspect_audio(content)
        metrics["filename"] = audio.filename
        metrics["content_type"] = audio.content_type
        return metrics
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Audio analysis failed: {str(e)}")
    finally:
        audio.file.close()


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=True)


