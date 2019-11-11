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
while [[ $# -gt 0 ]]; do
    case "${1}" in
      '--from') shift; export YVA_TOOLING_FROM="$(realpath "$1")";;
      '--to') shift; export YVA_TOOLING_TO="$(realpath "$1")";;
      '--logs') shift; export YVA_TOOLING_LOGS="$(realpath "$1")";;
      '--local') export YVA_TOOLING_CR=;;
      '--no-correct-perms') fixuid=;;
      '--correct-perms') shift; fixuid="$(id -u "$1")";;
      *) params+=("$1");;
    esac
  shift;
done

if [ ! -e "$YVA_TOOLING_FROM" ]; then
  echo "PST path not found: $YVA_TOOLING_FROM" >&2
  exit 1
fi

if [ ! -e "$YVA_TOOLING_TO" ]; then
  echo "Results path not found: $YVA_TOOLING_TO" >&2
  exit 1
fi

[ -n "$YVA_TOOLING_LOGS" ] || export YVA_TOOLING_LOGS="$YVA_TOOLING_TO/logs"

export YVA_TOOLING_ARGS="${params[*]} ${correctuid[*]}"

function __fix_uid {
  echo "Fixing docker created files permissions..."
  docker run -ti --rm \
    -v "${YVA_TOOLING_TO}:/result:rw" \
    -v "${YVA_TOOLING_LOGS}:/logs" \
    "${YVA_TOOLING_CR:-}files-connector/${YVA_TOOLING_VERSION:-master:latest}" \
    ./scripts/_fix.perms.sh "$1" /result /logs
}
[ -z "$fixuid" ] || trap "__fix_uid $fixuid" EXIT

[ -z "${YVA_TOOLING_CR:-}" ] || docker-compose pull
docker-compose up --abort-on-container-exit
