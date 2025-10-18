#!/usr/bin/env bash

export AWS_PROFILE="pulumi-service-dev-stacks"
export CHROME_BIN="$(which chromium)"
export GOPATH="$HOME/.go"
export GOPRIVATE="github.com/pulumi"
export HELPMAKEGO_EXPERIMENT_DAEMON=true
export PATH="$GOPATH/bin:$PATH"
export PULUMI_SERVICE_LOCAL_DATA="$HOME/.pulumi-service-local/data"
export MYSQL_DATA_PATH="$PULUMI_SERVICE_LOCAL_DATA"
export PULUMI_STACK_NAME_OVERRIDE=fnune-review

dotenv shared.env
