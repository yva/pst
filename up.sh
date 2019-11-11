#!/bin/bash

function usage() {
  cat >&2 << EOL
# Process folder with pst files 
# 1. creates list of founded pst files with small stats
# 2. pass list and extract texts 2 files with source text and md5 hash names. 
params:
  --from DIR: provide dir with pst files
  --to DIR: path for results
  --logs DIR: provide dir with log files (use to dir if not provided)
EOL
}

params=()
export YVA_TOOLING_CR='yvatools.azurecr.io/'
fixuid="$(id -u "$USERNAME")"
daemon=
compose_params=('--abort-on-container-exit')
while [[ $# -gt 0 ]]; do
    case "${1}" in
      '--from') shift; export YVA_TOOLING_FROM="$(realpath "$1")";;
      '--to') shift; export YVA_TOOLING_TO="$(realpath "$1")";;
      '--logs') shift; export YVA_TOOLING_LOGS="$(realpath "$1")";;
      '--local') export YVA_TOOLING_CR=;;
      '--no-correct-perms') fixuid=;;
      '--correct-perms') shift; fixuid="$(id -u "$1")";;
      '-d') compose_params=('-d'); daemon=1;;
      *) params+=("$1");;
    esac
  shift;
done

#default path for logs 
[ -n "$YVA_TOOLING_LOGS" ] || export YVA_TOOLING_LOGS="$YVA_TOOLING_TO/logs"

#prevent docker from create root owned folders
mkdir -p "$YVA_TOOLING_TO" "$YVA_TOOLING_LOGS"

# setup fixing docker created files in contained (for daemon mode it can be dan from container only. we dont know when its finished)
if [ -n "$fixuid" ]; then 
  params+=('--correct-perms' "$fixuid")
fi 
export YVA_TOOLING_ARGS="${params[*]}"

#setup trap for fixing permisions from script (it allows to fix it after ctrl-c)
function __fix_uid {
  echo "Fixing docker created files permissions..."
  docker run -ti --rm \
    -v "${YVA_TOOLING_TO}:/result:rw" \
    -v "${YVA_TOOLING_LOGS}:/logs" \
    "${YVA_TOOLING_CR:-}files-connector/${YVA_TOOLING_VERSION:-master:latest}" \
    ./scripts/_fix.perms.sh "$1" /result /logs
}
if [ -n "$fixuid" ] && [ -z "$daemon" ]; then 
  trap "__fix_uid $fixuid" EXIT
fi

# pull if not local
[ -z "${YVA_TOOLING_CR:-}" ] || docker-compose pull

# run forrest, run!
docker-compose up "${compose_params[@]}"