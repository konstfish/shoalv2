# https://docs.siderolabs.com/talos/v1.12/configure-your-talos-cluster/hardware-and-drivers/nvidia-gpu
# https://oneuptime.com/blog/post/2026-03-03-deploy-nvidia-gpu-operator-on-talos-linux/view
# https://github.com/kubernetes-sigs/dra-driver-nvidia-gpu/issues/605

  talosctl upgrade \
    -n 10.250.250.2 -e 10.0.1.102 \
    --talosconfig talosconfig \
    --image factory.talos.dev/installer/1deaeeb1ea2e7901c21c109368a7261f52dfd9a91e9d7eea83cfd0f0e1b7d488:v1.10.4

  talosctl upgrade \
    -n 10.250.250.3 -e 10.0.1.103 \
    --talosconfig talosconfig \
    --image factory.talos.dev/installer/1deaeeb1ea2e7901c21c109368a7261f52dfd9a91e9d7eea83cfd0f0e1b7d488:v1.10.4
