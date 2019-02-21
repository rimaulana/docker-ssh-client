#!/bin/sh
cleanup() {
    echo ' --- Terminating process --- '
    exit
}

trap cleanup INT TERM
echo ' --- Running process --- '
tail -f /dev/null & wait
cleanup