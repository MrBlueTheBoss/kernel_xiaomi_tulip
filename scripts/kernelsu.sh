#!/bin/bash

#
# Copyright (C) 2023-2024 Unitrix Kernel
#

set -e

function parse_parameters()
{
    while (($#)); do
        case $1 in
		stable | devel | v*) action=$1 ;;
		*) exit 33 ;;
	esac
	shift
    done
}

function do_stable()
{
   if ! [ -d $KERNELSU ]; then
       git clone https://github.com/tiann/KernelSU.git $KERNELSU > /dev/null 2>&1
       git -C $KERNELSU checkout $(git -C $KERNELSU describe --abbrev=0 --tags) > /dev/null 2>&1
   fi
}

function do_devel()
{
   if ! [ -d $KERNELSU ]; then
       git clone https://github.com/tiann/KernelSU.git $KERNELSU > /dev/null 2>&1
   fi
}

function do_older()
{
   if ! [ -d $KERNELSU ]; then
       git clone https://github.com/tiann/KernelSU.git $KERNELSU > /dev/null 2>&1
       git -C $KERNELSU checkout $action > /dev/null 2>&1
   fi
}

rm -rf $KERNELSU
parse_parameters $@
if [ $action = "stable" ] || [ $action = "devel" ]; then
do_$action
else
do_older
fi
if [ $(git -C $KERNELSU describe --abbrev=0 --tags) = "v0.6.6" ]; then
    git -C $KERNELSU cherry-pick -n --no-gpg-sign 0b1bab5b01d346ed4ad1b00d4ba974e27a20f5fb
fi
if [ $(git -C $KERNELSU describe --abbrev=0 --tags) = "v0.9.4" ]; then
    git -C $KERNELSU cherry-pick -n --no-gpg-sign 7af4f338e56cce386ba0dccdc0871b687cd697b1
fi
if [ $(git -C $KERNELSU describe --abbrev=0 --tags) = "v1.0.0" ]; then
    git -C $KERNELSU revert -n --no-gpg-sign 898e9d4f8ca9b2f46b0c6b36b80a872b5b88d899
fi

