FROM ghcr.io/ggml-org/llama.cpp:server

WORKDIR /app

EXPOSE 8080

# EasyPanel should mount/persist your GGUF at this path.
# ENV MODEL_PATH=/models/model.gguf
# ENV HOST=0.0.0.0
# ENV PORT=8080

# # Tuned for Intel Xeon Platinum 8167M, 8 vCPU, 20GB RAM target.
# ENV THREADS=8
# ENV THREADS_BATCH=8
# ENV CTX_SIZE=4096
# ENV BATCH_SIZE=512
# ENV UBATCH_SIZE=256
# ENV PARALLEL=1

CMD /app/llama-server \
  -m "$MODEL_PATH" \
  --host "$HOST" \
  --port "$PORT" \
  --threads "$THREADS" \
  --threads-batch "$THREADS_BATCH" \
  --ctx-size "$CTX_SIZE" \
  --batch-size "$BATCH_SIZE" \
  --ubatch-size "$UBATCH_SIZE" \
  --parallel "$PARALLEL" \
  --cont-batching \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --mlock \
  --no-mmap
