# syntax=docker/dockerfile:1
ARG GO_VERSION=1.21
ARG ALPINE_VERSION=3.19

FROM golang:${GO_VERSION}-alpine AS builder
WORKDIR /app

RUN go mod init keygen || true
COPY keygen.go .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /keygen keygen.go

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ca-certificates

COPY --from=builder /keygen /usr/local/bin/keygen

ENTRYPOINT ["/usr/local/bin/keygen"]
