#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

print_version() {
  AVAIL=$(glast $2/$3 | sed -e 's/^.*v//')
  ALIAS=${5:-$3}
  [ "${AVAIL}" == "$4" ] && printf "├── %-15s %10s ✅\n" "$1" "$4" # ✔️ not working
  [ "$4" == "n/a" ] && printf "├── %-15s %10s ❌ run 'up ${ALIAS} ${AVAIL}' to install latest version\n" "$1" "$4" && return 0
  [ "${AVAIL}" != "$4" ] && printf "├── %-15s %10s 🆕 run 'up ${ALIAS} ${AVAIL}' to update to latest version\n" "$1" "$4" && return 0
  return 0
}

get_githubcli_version() {
  gh --version 2>/dev/null | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_neon_version() {
  neon --version 2>/dev/null || echo -n "n/a" && return 0
}

get_golangci_lint_version() {
  golangci-lint --version 2>/dev/null | cut -d' ' -f4 || echo -n "n/a" && return 0
}

get_goreleaser_version() {
  goreleaser --version 2>/dev/null | head -1 | cut -d' ' -f3 || echo -n "n/a" && return 0
}

get_svu_version() {
  if svu --version >/dev/null 2>&1; then
    svu --version 2>&1 >/dev/null | cut -d' ' -f3
    return 0
  fi
  echo "n/a"
}

get_venom_version() {
  venom version 2>/dev/null | cut -d' ' -f3 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_gopls_version() {
  gopls version 2>/dev/null | head -1 | cut -d' ' -f2 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_delve_version() {
  dlv version 2>/dev/null | head -2 | tail -1 | cut -d' ' -f2 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_changie_version() {
  changie -v 2>/dev/null | cut -d' ' -f3 | sed -e 's/^v//' || echo -n "n/a" && return 0
}

get_gopkgs_version() {
  cat ~/.gopkgs 2>/dev/null || echo -n "n/a"
}

get_goplay_version() {
  cat ~/.goplay 2>/dev/null || echo -n "n/a"
}

get_gomodifytags_version() {
  cat ~/.gomodifytags 2>/dev/null || echo -n "n/a"
}

get_gotests_version() {
  cat ~/.gotests 2>/dev/null || echo -n "n/a"
}

figlet -c Python Devcontainer

(
  source /etc/os-release
  printf "%-16s %13s " "${NAME}" "v${VERSION_ID}"
  echo "✅"
)

DOCKER_CLI_VERSION=$(docker version -f '{{.Client.Version}}' 2>/dev/null || :)
printf "├── %-15s %10s " "Docker Client" "v${DOCKER_CLI_VERSION}"
echo "✅"

DOCKER_COMPOSE_VERSION=$(sudo docker-compose --version 2>/dev/null | cut -d' ' -f3 | tr -d ',' || :)
printf "├── %-15s %10s " "Docker Compose" "v${DOCKER_COMPOSE_VERSION}"
echo "✅"

GIT_VERSION=$(git --version | cut -d' ' -f3 || :)
printf "├── %-15s %10s " "Git Client" "v${GIT_VERSION}"
echo "✅"

ZSH_VERSION=$(zsh --version | cut -d' ' -f2 || :)
printf "├── %-15s %10s " "Zsh" "v${ZSH_VERSION}"
echo "✅"

# TODO : Python version

echo
