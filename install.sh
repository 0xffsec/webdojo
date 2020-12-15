#!/usr/bin/env bash
set -euf pipefail
IFS=$'\n\t'

#==============================================================================
# 0xffsec's Web Dojo Installation Script
# URL: https://github.com/0xffsec/webdojo
#
# Usage
# - Execute inside the repository
# - curl -sSL https://0xffsec.com/webdojo/install.sh | bash
# - git.io/webdojo-install

# Author:   Max Rodrigo
# Date:     2020-11-19
# Version:  0.1
# Usage:    bash install.sh
#==============================================================================

readonly BOLD=$(tput bold)
readonly RED=$(tput setaf 1)
readonly GREEN=$(tput setaf 2)
readonly YELLOW=$(tput setaf 3)
readonly NC=$(tput sgr0)

readonly REPO_URL="https://github.com/0xffsec/webdojo"
readonly DEPENDENCIES=(vagrant vboxmanage docker docker-compose)
readonly CURRENT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"

#######################################
# Print script banner.
#######################################
function banner() {
echo ${YELLOW}
cat << "EOF"
                   __          __
                  /\ \        /\ \           __
 __  __  __     __\ \ \____   \_\ \    ___  /\_\    ___
/\ \/\ \/\ \  /'__`\ \ '__`\  /'_` \  / __`\\/\ \  / __`\
\ \ \_/ \_/ \/\  __/\ \ \L\ \/\ \L\ \/\ \L\ \\ \ \/\ \L\ \
 \ \___x___/'\ \____\\ \_,__/\ \___,_\ \____/_\ \ \ \____/
  \/__//__/   \/____/ \/___/  \/__,_ /\/___//\ \_\ \/___/
                                            \ \____/
                                             \/___/

URL: https://github.com/0xffsec/webdojo
Author: Max Rodrigo
Version: 0.1
EOF
echo ${NC}
}

#######################################
# Print colorized string.
# Arguments:
#   String (Required)
#   Color
#######################################
function cecho() {
  echo "${2:-NC}${1}${NC}"
  return
}

#######################################
# Send message to stderr and exit.
# Arguments:
#   String
#######################################
function err() {
  cecho "Error: $*" ${RED} >&2
  exit 1
}

#######################################
# Print title formated string.
# Arguments:
#   String
#######################################
function title() {
  local txt="↪ ${1}"
  printf "\n${BOLD}%s\n\n" $(cecho $txt $YELLOW)
}

#######################################
# Check if command exists.
# Arguments:
#   Command
#######################################
function command_exists() {
  command -v "$@" > /dev/null 2>&1
}

#######################################
# Check if the given directory is the project's directory
# TODO: Improve this validation <20-11-20, Max Rodrigo> #
#
# Arguments:
#   Directory. Default: Current directory
#######################################
function is_project() {
  local vagrantfile_path="${1:-$CURRENT_DIR}/Vagrantfile"
  [ -f $vagrantfile_path ] && [ -n "grep -qs '0xffsec' $vagrantfile_path" ]
}

#######################################
# Print dependencies status
#######################################
function dependencies_check() {
  local available=$(cecho "available" $GREEN)
  local not_available=$(cecho "not available" $RED)
  local fullfill_deps=true

  title "Dependencies"

  # Dependencies are set globally in the DEPENDENCIES variable.
  for dep in ${DEPENDENCIES[*]}; do
    local dep_status=$not_available

    if command_exists $dep; then
      dep_status=$available
      fullfill_deps=true
    fi

    printf '%-15s › %s\n' "$dep" "$dep_status"
  done

  if ( ! $fullfill_deps ); then
    echo
    err "Missing dependencies. See: ${REPO_URL}#dependencies"
  fi
}


#######################################
# Get repo path or none if missing
#######################################
function get_repository() {
  local repo_name=${REPO_URL##*/}

  if is_project; then
    echo $CURRENT_DIR
  elif is_project "${CURRENT_DIR}/${repo_name}"; then
    echo "${CURRENT_DIR}/${repo_name}"
  fi
}


#######################################
# Get remote repository
#
# If inside the repo this step will be skipped
# If git > git clone
# If not > download and extract
#######################################
function download_repository() {
  local repo_url_api=$(echo $REPO_URL | sed 's,\(github.com\)\(.*\),api.\1/repos\2/tarball,')
  local repo_name=${REPO_URL##*/}

  title "Download Repository: $REPO_URL"

  # Ensure idempotence. Skip if repo exists
  if [ -n "$(get_repository)" ]; then
    cecho "Project found. Skipping." $YELLOW
    return
  fi

  if command_exists git; then
    git clone $REPO_URL
  elif command_exists tar; then
    curl -L $repo_url_api | tar xzf - --one-top-level="${repo_name}" --strip-components 1
  else
    err "Something went wrong. Exiting."
  fi
}


#######################################
# Get installation method
#
# TODO: Simplify and consolidate dependency check <20-11-20, Max Rodrigo> #
#######################################
function do_install() {
  local method
  local repo_path="$(get_repository)"

  title "Install"

  if command_exists vagrant && command_exists vboxmanage \
    command_exists docker && command_exists docker-compose;then

    PS3="Select the installation method: "
    select method in Docker Vagrant; do break; done < /dev/tty
    printf '%-15s › %s\n' "Selected method" "$(cecho $method $GREEN)"

  elif command_exists vagrant && command_exists vboxmanage;then

    method="Vagrant"
    printf '%-15s › %s\n' "Available method" "$(cecho $method $GREEN)"

  elif command_exists docker && command_exists docker-compose; then

    method="Docker"
    printf '%-15s › %s\n' "Available method" "$(cecho $method $GREEN)"

  else
    err "Review the dependencies."
  fi

  # When piped, read from stdout instead of stdin
  echo -n "Proceed? [Y/n]: "
  read -r proceed < /dev/tty
  # POSIX lowercase
  response=$(echo "$proceed" | tr '[:upper:]' '[:lower:]')

  if [[ ! $response =~ ^(yes|y| ) ]] && [[ ! -z $response ]]; then
    cecho "Aborting." $RED
    exit 0
  fi

  # POSIX lowercase
  method=$(echo "$method" | tr '[:upper:]' '[:lower:]')
  case $method in
    vagrant )
      # From the doc: "(...) when running Vagrant from a scripting environment
      # in order to set the directory that Vagrant sees."
      # https://www.vagrantup.com/docs/other/environmental-variables
      export VAGRANT_CWD="$repo_path"
      vagrant up
      cecho "Done! http://10.0.0.3/" $GREEN
      ;;
    docker )
      docker-compose -f ${repo_path}/docker-compose.yml up  -d
      cecho "Done! http://127.0.0.1/" $GREEN
      ;;
  esac
}

#######################################
# Executes installation
#######################################
function main() {
  banner
  dependencies_check
  download_repository
  do_install
}

# Wrapped up in a function to protect if download fails
main
