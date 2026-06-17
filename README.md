# llama.cpp Qwen Dockerfile for EasyPanel

Single Dockerfile setup for running Qwen GGUF with `llama.cpp` server on EasyPanel.

Base image:

```txt
ghcr.io/ggml-org/llama.cpp:server
```

Target model:

```txt
Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

Container model path built from:

```txt
MODEL_DIR=/models
MODEL_FILE=Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

So final path is:

```txt
/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

No rename to `model.gguf` needed.

## EasyPanel settings

Build from GitHub repo:

```txt
git@github.com:igun997/llama-config.git
```

Dockerfile path:

```txt
Dockerfile
```

Port:

```txt
8080
```

RAM target:

```txt
20GB
```

Storage mount:

```txt
Container path: /models
```

Put file in mounted storage:

```txt
/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

On current EasyPanel host, actual bind source is:

```txt
/etc/easypanel/projects/ai/llma-qwen/volumes/models
```

So host file should be:

```txt
/etc/easypanel/projects/ai/llma-qwen/volumes/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

## Environment variables

Set these in EasyPanel:

```txt
MODEL_DIR=/models
MODEL_FILE=Qwen3-4B-Instruct-2507-Q4_K_M.gguf
HOST=0.0.0.0
PORT=8080
THREADS=8
THREADS_BATCH=8
CTX_SIZE=4096
BATCH_SIZE=512
UBATCH_SIZE=256
PARALLEL=1
API_KEY=your-secret-key
```

Optional legacy override:

```txt
MODEL_PATH=/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

If `MODEL_PATH` is set, it overrides `MODEL_DIR` + `MODEL_FILE`.

## API key

Dockerfile passes EasyPanel `API_KEY` to llama.cpp:

```txt
--api-key $API_KEY
```

Client must send:

```txt
Authorization: Bearer your-secret-key
```

Hermes agent config:

```txt
Base URL: http://YOUR_DOMAIN_OR_IP/v1
API key: your-secret-key
Model: qwen
```

Test authorized request:

```bash
curl http://YOUR_DOMAIN_OR_IP/v1/chat/completions \
  -H "Authorization: Bearer your-secret-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen",
    "messages": [
      { "role": "user", "content": "Hello. Reply short." }
    ],
    "max_tokens": 128
  }'
```

Test rejected request:

```bash
curl -i http://YOUR_DOMAIN_OR_IP/v1/models
```

Expected without key:

```txt
401 Unauthorized
```

## Download model on server

```bash
sudo mkdir -p /etc/easypanel/projects/ai/llma-qwen/volumes/models

sudo wget -c -O /etc/easypanel/projects/ai/llma-qwen/volumes/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf \
  https://huggingface.co/unsloth/Qwen3-4B-Instruct-2507-GGUF/resolve/main/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

If 401, use mirror:

```bash
sudo wget -c -O /etc/easypanel/projects/ai/llma-qwen/volumes/models/Qwen3-4B-Instruct-2507-Q4_K_M.gguf \
  https://huggingface.co/mmnga/Qwen3-4B-Instruct-2507-gguf/resolve/main/Qwen3-4B-Instruct-2507-Q4_K_M.gguf
```

## Expected speed

Server CPU:

```txt
Intel Xeon Platinum 8167M @ 2.00GHz
8 vCPU
```

Expected output speed for `Qwen3-4B-Instruct-2507-Q4_K_M.gguf`:

```txt
~18-35 tok/s
```

Actual speed depends prompt size, CPU steal, RAM bandwidth, concurrent requests.

## Notes

`--mlock` removed because EasyPanel/container memlock caused warning:

```txt
failed to mlock ... Cannot allocate memory
```

Model still runs normally without `--mlock`.

## Local build test

```bash
docker build -t qwen-llama-cpp .
```

Run locally:

```bash
docker run --rm -p 8080:8080 \
  -v "$PWD/models:/models:ro" \
  -e MODEL_FILE=Qwen3-4B-Instruct-2507-Q4_K_M.gguf \
  -e API_KEY=your-secret-key \
  qwen-llama-cpp
```
