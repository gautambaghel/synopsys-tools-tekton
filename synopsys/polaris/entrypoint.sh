#!/bin/bash

export POLARIS_HOME="/polaris"
SCRIPT_ARGS="$@"
POLARIS_ARGS=""

for i in $*; do
  if [[ $i == --polaris.url=* ]]; then
    export POLARIS_SERVER_URL=`echo ${i} | cut -d'=' -f 2`
    LOGGABLE_SCRIPT_ARGS="$LOGGABLE_SCRIPT_ARGS $i"
  elif [[ $i == --polaris.config=* ]]; then
    export POLARIS_CONFIG_FILENAME=`echo ${i} | cut -d'=' -f 2`
    LOGGABLE_SCRIPT_ARGS="$LOGGABLE_SCRIPT_ARGS $i"
  elif [[ $i == --polaris.access.token=* ]]; then
    export POLARIS_ACCESS_TOKEN=`echo ${i} | cut -d'=' -f 2`
    LOGGABLE_SCRIPT_ARGS="$LOGGABLE_SCRIPT_ARGS --polaris.access.token=<redacted>"
  elif [[ $i == --polaris.args=* ]]; then
    POLARIS_ARGS=`echo ${i} | cut -d'=' -f 2`
    LOGGABLE_SCRIPT_ARGS="$LOGGABLE_SCRIPT_ARGS $i"
  else
    LOGGABLE_SCRIPT_ARGS="$LOGGABLE_SCRIPT_ARGS $i"
  fi
done

echo "running Polaris at ${POLARIS_HOME}/cli/polaris with env variables ${LOGGABLE_SCRIPT_ARGS}"
eval "polaris analyze ${POLARIS_ARGS}"