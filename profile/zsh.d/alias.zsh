# Minis
if [[ -x $(which docker) ]] || [[ -x $(which podman) ]]; then
  alias kali='docker run --rm -ti kalilinux/kali-last-release bash'
  alias debian='docker run --rm -ti debian:latest bash'
fi

# Customize
## BatCat - File Viewer
if [[ -x $(which bat) ]]; then
  alias cat='bat -l java'
fi

## LSD - Power-UP LS
if [[ -x $(which lsd) ]]; then
  alias ls='lsd'
fi
