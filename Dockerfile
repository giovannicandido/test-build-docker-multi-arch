# Create build stage based on buster image
FROM golang:1.20 AS builder
# Create working directory under /app
WORKDIR /app
# Copy over all go config (go.mod, go.sum etc.)
COPY . .
# Install any required modules
RUN go mod download
# Copy over Go source code
# Run the Go build and output binary under hello_go_http

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o app .

RUN useradd -u 10001 appuser

# Make sure to expose the port the HTTP server is using
FROM scratch

WORKDIR /app

COPY --from=builder /app/app ./
COPY --from=builder /etc/passwd /etc/passwd

USER appuser

EXPOSE 8080
# Run the app binary when we run the container
CMD ["./app"]