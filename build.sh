#!/bin/bash

# grpc-gateway dir
GRPC_GATEWAY_PATH=./grpc-gateway

##########################################
# GO PATH SETTING
##########################################
echo "-- GOPATH Setting --"
export PATH="$PATH:$(go env GOPATH)/bin"
echo "$PATH"

##########################################
# GO PROTOBUF BUILD FUNCTION
##########################################
function goGrpcProtoBuild() {
  {
    echo "-- Build [go grpc proto] --"
    protoc -I. -I$GRPC_GATEWAY_PATH/third_party/googleapis/ \
      --go-grpc_out=. proto/**/*.proto
    echo "-- Build END --"
  } || {
    echo "-- Fail Build --"
  }
}

##########################################
# check exists grpc-gateway module
##########################################
echo "-- Check [grpc-gateway] Package --"
if [ ! -d "$GRPC_GATEWAY_PATH" ]; then
  echo "-- Download [grpc-gateway] Package --"
  git clone https://github.com/grpc-ecosystem/grpc-gateway
else
  echo -e "\n"
  echo "-- Skip Download [grpc-gateway] Package --"
fi

echo """
-- Select Build Lang --
- go
"""
read LANG

case $LANG in
"go")
  ##########################################
  # go grpc build run
  ##########################################
  goGrpcProtoBuild
  ;;
*) echo "-- INVALID --" ;;
esac
