FROM ghcr.io/ggml-org/llama.cpp:server

WORKDIR /app

EXPOSE 8080

# EasyPanel env to set:
# MODEL_DIR=/models
# MODEL_FILE=Qwen3-4B-Instruct-2507-Q4_K_M.gguf
# API_KEY=your-secret-key
# HOST=0.0.0.0
# PORT=8080
# THREADS=8
# THREADS_BATCH=8
# CTX_SIZE=4096
# BATCH_SIZE=512
# UBATCH_SIZE=256
# PARALLEL=1

ENTRYPOINT []

CMD ["sh", "-c", "\
set -eu; \
MODEL_DIR=${MODEL_DIR:-/models}; \
MODEL_FILE=${MODEL_FILE:-Qwen3-4B-Instruct-2507-Q4_K_M.gguf}; \
MODEL_PATH=${MODEL_PATH:-$MODEL_DIR/$MODEL_FILE}; \
HOST=${HOST:-0.0.0.0}; \
PORT=${PORT:-8080}; \
THREADS=${THREADS:-8}; \
THREADS_BATCH=${THREADS_BATCH:-8}; \
CTX_SIZE=${CTX_SIZE:-4096}; \
BATCH_SIZE=${BATCH_SIZE:-512}; \
UBATCH_SIZE=${UBATCH_SIZE:-256}; \
PARALLEL=${PARALLEL:-1}; \
API_ARGS=; \
if [ -n \"${API_KEY:-}\" ]; then API_ARGS=\"--api-key $API_KEY\"; fi; \
exec /app/llama-server \
  -m \"$MODEL_PATH\" \
  --host \"$HOST\" \
  --port \"$PORT\" \
  --threads \"$THREADS\" \
  --threads-batch \"$THREADS_BATCH\" \
  --ctx-size \"$CTX_SIZE\" \
  --batch-size \"$BATCH_SIZE\" \
  --ubatch-size \"$UBATCH_SIZE\" \
  --parallel \"$PARALLEL\" \
  --cont-batching \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --no-mmap \
  $API_ARGS\
"]
