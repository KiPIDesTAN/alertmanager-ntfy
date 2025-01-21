FROM golang:1.23 AS build

WORKDIR /go/src/app
COPY . .

RUN go mod download

RUN CGO_ENABLED=0 go build -o /go/bin/app/alertmanager-ntfy ./cmd/alertmanager-ntfy

FROM gcr.io/distroless/static-debian12

COPY --from=build /go/bin/app/alertmanager-ntfy /alertmanager-ntfy
COPY --from=build /go/src/app/config.example.yml /config.yml

CMD ["/alertmanager-ntfy"]
