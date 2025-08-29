#!/usr/bin/env bash

export GOPATH="$HOME/go"
export GOPRIVATE="github.com/pulumi"
export PATH="$GOPATH/bin:$PATH"
export PULUMI_TEST_ORG=pulumi_local

source_env_if_exists .envrc.local
