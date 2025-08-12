#!/usr/bin/env bash
set -euo pipefail
PROJECT_NAME="Python AI Project"
PYTHON_VERSION_FILE=".python-version"
VENV_DIR="venv"
REQ_FILE="requirements.txt"
REQ_HASH_FILE=".requirements.hash"
COLOR_RESET="\033[0m"
COLOR_BLUE="\033[34m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_RED="\033[31m"
COLOR_MAGENTA="\033[35m"
banner() {
  echo -e "${COLOR_MAGENTA}==============================${COLOR_RESET}"
  echo -e "${COLOR_BLUE}$PROJECT_NAME Environment Setup${COLOR_RESET}"
  echo -e "${COLOR_MAGENTA}==============================${COLOR_RESET}"
}
info() { echo -e "${COLOR_GREEN}[INFO]${COLOR_RESET} $*"; }
warn() { echo -e "${COLOR_YELLOW}[WARN]${COLOR_RESET} $*"; }
err()  { echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $*" >&2; }
step() { echo -e "${COLOR_BLUE}--- $* ---${COLOR_RESET}"; }
trap 'err "Script failed (line $LINENO)."' ERR
trap 'echo -e "${COLOR_MAGENTA}Done.${COLOR_RESET}"' EXIT
confirm() {
  local prompt="$1"; shift || true
  if [[ "${ASSUME_YES:-}" == "1" ]]; then
    return 0
  fi
  read -r -p "$prompt [Y/n]: " ans || true
  case "${ans:-Y}" in
    [Yy]*|"" ) return 0 ;;
    * ) return 1 ;;
  esac
}
detect_shell() {
  local sh="${SHELL:-}"; basename "$sh" 2>/dev/null || echo unknown
}
ensure_python() {
  step "Checking Python version"
  local desired
  if [[ -f "$PYTHON_VERSION_FILE" ]]; then
    desired=$(<"$PYTHON_VERSION_FILE")
  else
    warn "No $PYTHON_VERSION_FILE found; using system python3"
    return 0
  fi
  if command -v pyenv >/dev/null 2>&1; then
    if ! pyenv versions --bare | grep -qx "$desired"; then
      info "Installing Python $desired via pyenv (if not cached)"
      pyenv install -s "$desired"
    fi
    export PYENV_VERSION="$desired"
    info "Using pyenv python $(python -V 2>&1)"
  else
    local sys_ver
    sys_ver=$(python3 -c 'import platform;print(".".join(platform.python_version().split(".")[:2]))' 2>/dev/null || echo "")
    if [[ -n "$sys_ver" && "$desired" != "$sys_ver"* ]]; then
      warn "System Python $sys_ver does not match desired $desired (continuing)"
    fi
  fi
}
ensure_pip() {
  step "Ensuring pip"
  if python3 -m pip --version >/dev/null 2>&1; then
    info "pip present"
  else
    warn "pip missing; attempting ensurepip"
    python3 -m ensurepip --upgrade || err "ensurepip failed"
  fi
}
create_venv() {
  step "Creating virtual environment"
  if [[ -d "$VENV_DIR" ]]; then
    info "Virtual env already exists -> $VENV_DIR"
  else
    python3 -m venv "$VENV_DIR" || err "Failed to create venv"
    info "Created venv"
  fi
}
activate_venv() {
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
  info "Activated venv (python $(python -V 2>&1))"
}
hash_requirements() {
  sha256sum "$REQ_FILE" 2>/dev/null | awk '{print $1}' 2>/dev/null || shasum -a 256 "$REQ_FILE" | awk '{print $1}'
}
install_requirements() {
  step "Installing requirements"
  if [[ ! -f "$REQ_FILE" ]]; then
    warn "No $REQ_FILE found; skipping dependency install"
    return 0
  fi
  local new_hash
  new_hash=$(hash_requirements)
  local old_hash=""
  if [[ -f "$REQ_HASH_FILE" ]]; then
    old_hash=$(<"$REQ_HASH_FILE")
  fi
  if [[ "$new_hash" == "$old_hash" && -z "${FORCE_REINSTALL:-}" ]]; then
    info "Dependencies already up-to-date (hash $new_hash)"
    return 0
  fi
  if confirm "Proceed with pip install?"; then
    python -m pip install --upgrade pip
    python -m pip install -r "$REQ_FILE"
    echo "$new_hash" > "$REQ_HASH_FILE"
    info "Installed dependencies"
  else
    warn "Skipped dependency install"
  fi
}
show_post_activation() {
  cat <<EOF
${COLOR_GREEN}Environment ready.${COLOR_RESET}
To activate in a new shell:
  source $VENV_DIR/bin/activate
To run examples:
  python examples/basic_completion.py
EOF
}
parse_args() {
  ASSUME_YES="0"
  while [[ $# -gt 0 ]]; do
    case $1 in
      -y|--yes) ASSUME_YES="1" ; shift ;;
      --force) FORCE_REINSTALL=1 ; shift ;;
      *) warn "Unknown arg: $1" ; shift ;;
    esac
  done
}
main() {
  banner
  parse_args "$@"
  info "Shell: $(detect_shell) | Working dir: $(pwd)"
  ensure_python
  ensure_pip
  create_venv
  activate_venv
  install_requirements
  show_post_activation
}
main "$@"
