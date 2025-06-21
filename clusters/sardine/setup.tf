# runner ip for hetzner fw
data "http" "runner_public_ip" {
  url = "https://api.ipify.org"
}

# hetzner ssh key
/*data "external" "github_ssh_keys" {
  for_each = toset(var.github_usernames)

  program = ["bash", "-c", "curl -s https://github.com/${each.key}.keys | head -n 1 | jq --raw-input '{ssh_key: .}'"]
}

resource "hcloud_ssh_key" "default" {
  for_each = data.external.github_ssh_keys

  name       = "test-${var.cluster_name}-${each.key}"
  public_key = each.value.result.ssh_key
}*/