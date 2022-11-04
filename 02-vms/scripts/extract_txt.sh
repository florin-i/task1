#!/usr/bin/env bash

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  jq_test=$(which jq)
  if [[ -z $jq_test ]]; then error_exit "JQ binary not found"; fi
}

function extract_data() {
  my_pings=$(cat out/out.txt)
  jq -n --arg my_pings "$my_pings" '{"my_pings": "'"$my_pings"'"}'
}

check_deps
extract_data
