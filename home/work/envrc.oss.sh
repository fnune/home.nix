#!/usr/bin/env bash

export GOPATH="$HOME/go"
export GOPRIVATE="github.com/pulumi"
export GOTOOLCHAIN="go1.24.5"
export PATH="$GOPATH/bin:$PATH"
export PULUMI_TEST_ORG=pulumi_local
