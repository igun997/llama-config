# llama.cpp Qwen Dockerfile for EasyPanel

Single Dockerfile setup for running Qwen with `llama.cpp` server on EasyPanel.

Base image:

```txt
ghcr.io/ggml-org/llama.cpp:server
```

Target model:

```txt
Qwen3-4B-Instruct-Q4_K_M.gguf
```

Runtime model path:

```txt
/models/model.gguf
```

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

Mount/persist model file so container can read:

```txt
/models/model.gguf
```

Use filename:

```txt
Qwen3-4B-Instruct-Q4_K_M.gguf
```

but mount/rename it as:

```txt
model.gguf
```

## Environment variables

Dockerfile defaults:

```txt
MODEL_PATH=/models/model.gguf
HOST=0.0.0.0
PORT=8080
THREADS=8
THREADS_BATCH=8
CTX_SIZE=4096
BATCH_SIZE=512
UBATCH_SIZE=256
PARALLEL=1
```

Override in EasyPanel only if needed.

## Expected speed

Server CPU:

```txt
Intel Xeon Platinum 8167M @ 2.00GHz
8 vCPU
```

Expected output speed for `Qwen3-4B-Instruct-Q4_K_M.gguf`:

```txt
~18-35 tok/s
```

Actual `tok/s` depends prompt size, CPU steal, RAM bandwidth, concurrent requests.

## OpenAI-compatible endpoint

Base URL:

```txt
http://YOUR_DOMAIN_OR_IP/v1
```

Chat endpoint:

```txt
http://YOUR_DOMAIN_OR_IP/v1/chat/completions
```

Model name can be any string from client side, for example:

```txt
qwen
```

Test:

```bash
curl http://YOUR_DOMAIN_OR_IP/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen",
    "messages": [
      { "role": "user", "content": "Hello. Reply short." }
    ],
    "max_tokens": 128
  }'
```

## Hermes agent config

```txt
Base URL: http://YOUR_DOMAIN_OR_IP/v1
API key: anything
Model: qwen
```

## If EasyPanel shows mlock error

Remove this flag from `Dockerfile`:

```txt
--mlock
```

Then redeploy.

## If RAM grows too high

Set EasyPanel memory limit to 20GB.

If still high, lower context:

```txt
CTX_SIZE=2048
```

## Local build test

```bash
docker build -t qwen-llama-cpp .
```

Run locally:

```bash
docker run --rm -p 8080:8080 \
  -v "$PWD/models:/models:ro" \
  --memory=20g \
  --ulimit memlock=-1:-1 \
  qwen-llama-cpp
```
