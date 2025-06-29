from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
from uuid import uuid4
import os
import torch
from mochi import MochiPipeline

app = FastAPI()
jobs = {}

print("Loading Mochi pipeline...")
pipe = MochiPipeline.from_pretrained(
    "genmo/mochi-1-preview",
    torch_dtype=torch.float16
).to("cuda")
print("Pipeline loaded.")

class PromptRequest(BaseModel):
    prompt: str

@app.post("/submit")
async def submit(req: PromptRequest, background_tasks: BackgroundTasks):
    job_id = str(uuid4())
    jobs[job_id] = {"status": "pending", "file": None}
    background_tasks.add_task(run_generation, job_id, req.prompt)
    return {"job_id": job_id}

@app.get("/status/{job_id}")
def get_status(job_id: str):
    return jobs.get(job_id, {"error": "Job not found"})

@app.get("/list")
def list_jobs():
    return jobs

@app.get("/output/{job_id}")
def get_output(job_id: str):
    job = jobs.get(job_id)
    if job and job["file"]:
        return {"file_path": job["file"]}
    return {"error": "File not ready"}

def run_generation(job_id, prompt):
    jobs[job_id]["status"] = "processing"
    try:
        os.makedirs("/outputs", exist_ok=True)
        video_path = f"/outputs/{job_id}.mp4"
        video = pipe(prompt, num_frames=50)
        video.save(video_path)
        jobs[job_id]["status"] = "completed"
        jobs[job_id]["file"] = video_path
    except Exception as e:
        jobs[job_id]["status"] = "failed"
        jobs[job_id]["error"] = str(e)

