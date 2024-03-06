# shellcheck source=./test_runner.sh
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. "${dir}"/test_runner.sh
. "${dir}"/test_helper.sh
runner=$(get_test_runner "${1:-local}")

cd test_cross_build

function test_cross_build() {
  bazel test //...
  bazel clean
  bazel shutdown;
}

backup_unformatted() {
  FILE_PATH=$1
  FILENAME=$2
  cp $FILE_PATH/unformatted/unformatted-$FILENAME.scala $FILE_PATH/unformatted/unformatted-$FILENAME.backup.scala
}

restore_unformatted_before_exit() {
  FILE_PATH=$1
  FILENAME=$2
  cp $FILE_PATH/unformatted/unformatted-$FILENAME.backup.scala $FILE_PATH/unformatted/unformatted-$FILENAME.scala
  rm -f $FILE_PATH/unformatted/unformatted-$FILENAME.backup.scala
}

run_formatting() {
  set +e

  FILE_PATH=src/main/scalafmt
  NAME=$1

  local run_under = ""
  if is_windows; then
    run_under="--run_under=bash"
  fi

  bazel run //src/main/scalafmt:formatted-$NAME.format-test $run_under
  if [ $? -ne 0 ]; then
    echo -e "${RED} formatted-$NAME.format-test should be a formatted target. $NC"
    exit 1
  fi

  bazel run //src/main/scalafmt:unformatted-$NAME.format-test $run_under
  if [ $? -eq 0 ]; then
    echo -e "${RED} unformatted-$NAME.format-test should be an unformatted target. $NC"
    exit 1
  fi

  backup_unformatted $FILE_PATH $NAME

  bazel run //src/main/scalafmt:unformatted-$NAME.format $run_under
  if [ $? -ne 0 ]; then
    echo -e "${RED} unformatted-$NAME.format should run formatting. $NC"
    restore_unformatted_before_exit $FILE_PATH $NAME
    exit 1
  fi

  diff $FILE_PATH/unformatted/unformatted-$FILENAME.scala $FILE_PATH/formatted/formatted-$FILENAME.scala
  if [ $? -ne 0 ]; then
    echo -e "${RED} unformatted-$NAME.scala should be the same as formatted-$NAME.scala after formatting. $NC"
    restore_unformatted_before_exit $FILE_PATH $NAME
    exit 1
  fi
  restore_unformatted_before_exit $FILE_PATH $NAME
}

test_scalafmt_library2() {
  run_formatting library2
}

test_scalafmt_library3() {
  run_formatting library3
}

test_scalafmt_binary2() {
  run_formatting binary2
}

test_scalafmt_binary3() {
  run_formatting binary3
}

test_scalafmt_test2() {
  run_formatting test2
}

test_scalafmt_test3() {
  run_formatting test3
}

$runner test_scalafmt_library2
$runner test_scalafmt_library3
$runner test_scalafmt_binary2
$runner test_scalafmt_binary3
$runner test_scalafmt_test2
$runner test_scalafmt_test3
$runner test_cross_build
