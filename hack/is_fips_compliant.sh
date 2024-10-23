#!/bin/sh
set -eu

# Check if a file name is given as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <binary-file>"
    exit 1
fi

# Run go tool nm on the provided file and capture the output
nm_output=$(go tool nm "$1")

# Check for the presence of symbols
if echo "$nm_output" | grep -q 'sig.StandardCrypto'; then
    echo "$1 contains sig.StandardCrypto, which is NOT OK."
    exit 1
else
    if echo "$nm_output" | grep -qE 'sig.FIPSOnly|sig.BoringCrypto'; then
        echo "$1 contains sig.FIPSOnly or sig.BoringCrypto, which is OK."
    else
        echo "$1 does not contain sig.StandardCrypto, sig.FIPSOnly, or sig.BoringCrypto, which is OK."
    fi
fi
