#!/usr/bin/env bash

set -e
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${dir}"/test_cross_build
bazel test ...
bazel clean
