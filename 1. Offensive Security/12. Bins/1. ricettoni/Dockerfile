FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install socat, python3, python3-ecdsa, and python3-gmpy2
RUN apt-get update && apt-get install -y \
    socat \
    python3 \
    python3-ecdsa \
    python3-gmpy2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy source files
COPY ricettoni /app/ricettoni
COPY flag.txt /app/flag.txt

# Ensure binary and loader are executable
RUN chmod +x /app/ricettoni

# Expose the port
EXPOSE 1337

# Run the binary using socat with timeout and pow check
CMD ["socat", "TCP-LISTEN:1337,reuseaddr,fork", "EXEC:\"timeout 60 ./ricettoni"]
