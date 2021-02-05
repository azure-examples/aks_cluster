#!/bin/bash

# Normalize Input Command
COMMAND=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Validate Inputs
if [ -z "$COMMAND" ] || ([ "$COMMAND" != "apply" ] &&  [ "$COMMAND" != "destroy" ] && [ "$COMMAND" != "validate" ] && [ "$COMMAND" != "graph" ]); then
  echo "You must pass one of the following arguments to this script: apply, destroy, validate."
  exit 1
fi

# Setup Environment
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -f "$DIR/env.sh" ]; then
  . $DIR/env.sh
else
  echo "*** Variable Initialization Script Missing ***"
  echo "Follow the instructions in the env.template.sh file in the _local_only directory."
  exit 2
fi

cd $DIR/../src
terraform init

terraform workspace select development || terraform workspace new development

terraform $COMMAND
