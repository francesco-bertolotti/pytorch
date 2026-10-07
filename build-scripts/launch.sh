#!/bin/bash
set -euo pipefail

ROOT="$(realpath "$(dirname "$0")/..")"
cd $ROOT

mkdir -p $ROOT/logs
if [[ -d build ]]; then
    read -rp "remove build/ ($(du -sh --apparent-size build | cut -f1), $(find build -type f | wc -l) files)? [y/N] " ans || ans=n
    if [[ $ans == [yY] ]]; then rm -rf build; else echo "keeping build/"; fi
fi

srun \
    --job-name=torch-build \
    --account=$ACCOUNT \
    --partition=$PARTITION \
    --qos=$QOS \
    --nodes=1 \
    --cpus-per-task=32 \
    --time=04:00:00 \
    --pty bash $ROOT/build-scripts/build.sh
