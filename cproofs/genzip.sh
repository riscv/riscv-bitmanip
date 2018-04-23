#!/bin/bash
set -ex

cbmc --trace --function check_zip_unzip_n   genzip.cc
cbmc --trace --function check_zip_b         genzip.cc
cbmc --trace --function check_unzip_b       genzip.cc
cbmc --trace --function check_zip_h         genzip.cc
cbmc --trace --function check_unzip_h       genzip.cc
cbmc --trace --function check_zip           genzip.cc
cbmc --trace --function check_gzip32        genzip.cc
cbmc --trace --function check_stages        genzip.cc

echo OK
