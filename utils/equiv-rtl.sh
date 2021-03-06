#!/bin/bash
##===- utils/equiv-rtl.sh - Formal Equivalence via yosys------*- Script -*-===##
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
##===----------------------------------------------------------------------===##
#
# This script checks two input verilog files for equivalence using yosys.
#
# Usage equiv-rtl.sh File1.v File2.v TopLevelModuleName
#
##===----------------------------------------------------------------------===##

echo "Comparing $1 and $2 with $3"
yosys -q -p "
 read_verilog $1
 rename $3 top1
 proc
 memory
 flatten top1
 hierarchy -top top1
read_verilog $2
 rename $3 top2
 proc
 memory
 flatten top2
 equiv_make top1 top2 equiv
 hierarchy -top equiv
 clean -purge
 equiv_simple
 equiv_induct
 equiv_status -assert
"
if [ $? -eq 0 ]
then
  echo "PASS"
  exit 0
else
#repeat with output
  yosys -p "
   read_verilog $1
   rename $3 top1
   proc
   memory
   flatten top1
   hierarchy -top top1
  read_verilog $2
   rename $3 top2
   proc
   memory
   flatten top2
   equiv_make top1 top2 equiv
   hierarchy -top equiv
   clean -purge
   equiv_simple
   equiv_induct
   equiv_status -assert
  "
  echo "FAIL"
  exit 1
fi

