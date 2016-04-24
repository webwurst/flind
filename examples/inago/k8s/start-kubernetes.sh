#!/bin/env bash

cd "$(dirname "$(realpath "$0")")";

# git clone .. if missing

inagoctl up k8s-network
inagoctl up k8s-master
inagoctl up k8s-node 3
