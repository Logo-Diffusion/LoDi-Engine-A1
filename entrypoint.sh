#!/bin/bash


[[ "${DOWNLOAD_MODELS}" == "true" ]] && /app/loadData

/app/webui.sh $COMMAND_LINE_ARGS