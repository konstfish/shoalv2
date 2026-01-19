FROM alpine

RUN apk add --no-cache curl git bash yq kubectl openssl \
    && curl -sL https://talos.dev/install | sh \
    && alias k=kubectl

ENV KUBECONFIG=/kubeconfig
