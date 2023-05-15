#!/bin/bash


[[ "${DOWNLOAD_MODELS}" == "true" ]] && /app/loadData.sh

/app/webui.sh $COMMAND_LINE_ARGS