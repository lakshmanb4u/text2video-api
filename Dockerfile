FROM python:3.10-slim

# Install system dependencies needed for scientific packages
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

# Install CPU-only PyTorch and torchvision
RUN pip install torch torchvision -f https://download.pytorch.org/whl/cpu/torch_stable.html

# Install FastAPI and Uvicorn
RUN pip install fastapi uvicorn

COPY app.py /app.py

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
