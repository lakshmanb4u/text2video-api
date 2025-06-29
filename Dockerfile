FROM nvidia/cuda:12.2.0-runtime-ubuntu20.04

RUN apt update && apt install -y python3 python3-pip git

RUN pip3 install torch torchvision
RUN pip3 install fastapi uvicorn "mochi@git+https://github.com/genmo-ai/mochi.git"

COPY app.py /app.py

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

