FROM alpine:latest AS builder

# https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt/issues/200#issuecomment-1913759043

ARG TALOS_VERSION=v1.12.1
ARG SCHEMATIC_ID=ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515
#ARG PLATFORM=nocloud-amd64
ARG PLATFORM=openstack-amd64

RUN apk add --no-cache \
    wget \
    xz \
    qemu-img

RUN wget -O /tmp/talos.raw.xz \
    "https://factory.talos.dev/image/${SCHEMATIC_ID}/${TALOS_VERSION}/${PLATFORM}.raw.xz"

RUN xz -d /tmp/talos.raw.xz

RUN qemu-img convert -f raw -O qcow2 -c /tmp/talos.raw /tmp/talos.qcow2

RUN qemu-img info /tmp/talos.qcow2

FROM scratch

COPY --from=builder --chown=107:107 /tmp/talos.qcow2 /disk/disk.img

LABEL org.opencontainers.image.title="Talos Linux ContainerDisk"