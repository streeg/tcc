#!/bin/bash

mkdir -p ./cryptoRunner/projects/apks 
mkdir -p ./cryptoRunner/projects/jars
mkdir -p ./cryptoRunner/results/cryptoAnalysisOutput
mkdir -p ./cryptoRunner/results/cryptoReportOutput
mkdir -p ./cryptoRunner/results/cryptoSummaryOutput
mkdir -p ./cryptoRunner/results/cryptoSarifOutput
mkdir -p ./cryptoRunner/results/cryptoGuardOutput

VERSION=1.0
IMAGE=amaralh/crypto-runner

docker build --no-cache -t $IMAGE:$VERSION $(dirname $0)

ID=$(docker images | grep "$IMAGE" | head -n 1 | awk '{print $3}')

docker tag "$ID" $IMAGE:latest
docker tag "$ID" $IMAGE:$VERSION

# docker run -it -v /Users/Amaral/tools/crypto-analysis-runner/fse2022/cryptoRunner/results:/home/cryptoRunner/results -v /Users/Amaral/tools/crypto-analysis-runner/fse2022/cryptoRunner/projects:/home/cryptoRunner/projects --name crypto-runner amaralh/crypto-runner:latest