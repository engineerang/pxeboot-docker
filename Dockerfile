# Start from golang v1.12.5 base image
FROM golang:1.12.5 as builder

# Download Spriteful
RUN go get github.com/computingcats/spriteful

# Set the Current Working Directory inside the container
WORKDIR /go/src/github.com/computingcats/spriteful

# Build the Go app for Alpine
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/spriteful .

######## Start a new stage from scratch #######
FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /go/bin/spriteful .

# Create a directory and mount point for the spriteful config.json
RUN mkdir /config
VOLUME ["/config"]

# When the container is started, run the spriteful binary
ENTRYPOINT ./spriteful --config /config/config.json 

