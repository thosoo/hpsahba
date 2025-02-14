#!/usr/bin/env bash
set -e

# If $1 is not provided, KERNEL_VERSION defaults to 6.8
KERNEL_VERSION=${1:-6.8}

# If $2 is not provided, VERSION defaults to 5.18
PATCH_VERSION=${2:-5.18}

echo "Patching for kernel ${KERNEL_VERSION} using Patch version ${PATCH_VERSION}"

# Fetch the three driver files for the specified kernel version
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.h?h=linux-${KERNEL_VERSION}.y" \
     -O hpsa.h

wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.c?h=linux-${KERNEL_VERSION}.y" \
     -O hpsa.c

wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa_cmd.h?h=linux-${KERNEL_VERSION}.y" \
     -O hpsa_cmd.h

# Enable nullglob so the loop won't run if no patches match
shopt -s nullglob

# Apply all patches that match ../../kernel/<VERSION>*/.patch
for PATCH in ../../kernel/"${PATCH_VERSION}"*/*.patch; do
    echo "Applying ${PATCH}"
    patch --no-backup-if-mismatch -Np3 < "${PATCH}"
done
