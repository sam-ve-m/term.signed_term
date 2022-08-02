#!/bin/bash

export FISSION_ENVIRONMENT_NAME="env-get-signed-term"
export FISSION_FUNCTION_NAME="fn-get-signed-term"
export FISSION_FUNCTION_ROUTE="/signed_term"
export FISSION_FUNCTION_ROUTE_NAME="route-get-signed-term"
export FISSION_TCP_PORT="5000"
echo "- Starting spec..."; fission spec init || { echo "ERROR: Failed to init spec. Message: Make sure the script is run only once, or run the remove_fission.sh script. [FINISHING SCRIPT]"; exit; }
echo "- Creating environment: $FISSION_ENVIRONMENT_NAME..."; fission env create --spec --name $FISSION_ENVIRONMENT_NAME --image nexus.sigame.com.br/fission-env-async:0.0.1 --builder nexus.sigame.com.br/fission-builder-3.8:0.0.1 || { echo "ERROR: Failed to create environment. Message: Make sure the script is run only once, or run the remove_fission.sh script. [FINISHING SCRIPT]"; exit; }
echo "- Creating function: $FISSION_FUNCTION_NAME..."; fission fn create --spec --name $FISSION_FUNCTION_NAME --env $FISSION_ENVIRONMENT_NAME --src "./func/*" --entrypoint main.get_signed_term --executortype newdeploy --maxscale 1 || { echo "ERROR: Failed to create function. Message: Make sure the script is run only once, or run the remove_fission.sh script. [FINISHING SCRIPT]"; exit; }
echo "- Creating HTTP trigger: $FISSION_FUNCTION_ROUTE..."; fission route create --spec --name $FISSION_FUNCTION_ROUTE_NAME --method GET --url $FISSION_FUNCTION_ROUTE --function $FISSION_FUNCTION_NAME || { echo "ERROR: Failed to create route. Message: Make sure the script is run only once, or run the remove_fission.sh script. [FINISHING SCRIPT]"; exit; }
echo "Fission successfully configured!"