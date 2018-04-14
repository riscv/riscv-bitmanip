#!/bin/bash
set -ex

cbmc --trace --function zip_unzip_invcheck  zip_unzip.cc
cbmc --trace --function zip4_unzip_eqcheck  zip_unzip.cc
cbmc --trace --function zip_unzip4_eqcheck  zip_unzip.cc

echo OK
