FROM ubuntu:20.04

RUN apt update && apt install -y python3 python3-pip git

RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cpu
RUN pip3 install fastapi uvicorn

COPY app.py /app.py

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
