# Pull base image
FROM golang:1.22.3-alpine3.19

# Install git
RUN apk update && apk add --no-cache git

# Install Air for hot reload
RUN go install github.com/cosmtrek/air@v1.49.0
