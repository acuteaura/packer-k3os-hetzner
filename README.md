# packer-k3os-hetzner

make a hetzner image with k3os

nothing special, no magic here

# how to use

* set `HCLOUD_TOKEN`
* set your desired release tag (packer var "version", you can also edit the hcl)
* `packer build .`