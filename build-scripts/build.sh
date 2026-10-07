cd "$(dirname "$0")/.."

module purge
module load gcc/12.2.0
module load cuda/12.6
module load ninja/1.11.1
module load spack
spack load gcc@13.1.0

source .venv/bin/activate

# Nightly wheels are versioned <version.txt without a0>.dev<commit date>
BASE="$(sed 's/a0$//' version.txt)"
NIGHTLY_DATE="${NIGHTLY_DATE:-$(git log -1 --format=%cd --date=format:%Y%m%d)}"
export PYTORCH_BUILD_VERSION="${BASE}.dev${NIGHTLY_DATE}"
export PYTORCH_BUILD_NUMBER=0

export MAX_JOBS="${SLURM_CPUS_PER_TASK:-1}"
export TORCH_CUDA_ARCH_LIST="8.0"
export USE_CUDA=1
export USE_DISTRIBUTED=1
export USE_NCCL=1
export BUILD_TEST=0
export CMAKE_BUILD_TYPE=Release

echo "building torch ${PYTORCH_BUILD_VERSION}"
pip wheel . -v --no-build-isolation --no-deps -w dist/
