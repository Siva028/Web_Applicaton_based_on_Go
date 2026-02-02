#Starting with a base golang image

FROM golang:1.22.5 AS builder

#Setting the working directory inside the container

WORKDIR /app

#Copying the go.mod to the working directory

COPY go.mod ./

#Downloading the dependencies

RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

#Copying the source code to the working directory

COPY . .

#Setting environment variables for Go build

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

#Building the Go application with caching for build artifacts

RUN --mount=type=cache,target=/root/.cache/go-build \
    go build -ldflags="-s -w" -o main .

#Starting a new stage from a minimal base image

FROM gcr.io/distroless/static-debian12:nonroot

#Setting the working directory inside the new container

WORKDIR /app

#Copying the built binary from the builder stage

COPY --from=builder /app/main .

#Copying the static files from the builder stage

COPY --from=builder /app/static ./static

#Exposing the application port

EXPOSE 8080

#Setting the entry point for the container

ENTRYPOINT ["./main"]