FROM ubuntu:20.04

# Avoid interactive tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y python3 python3-pip git

# Install CPU-only PyTorch and torchvision from official CPU wheel page
RUN pip3 install torch torchvision -f https://download.pytorch.org/whl/cpu/torch_stable.html

# Install FastAPI and Uvicorn
RUN pip3 install fastapi uvicorn

# (Optional) You can install other packages here if needed, but do not add mochi yet to avoid GPU build issues

COPY app.py /app.py

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
