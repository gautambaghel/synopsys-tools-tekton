#!/bin/bash

# SOURCE
oc apply -f pipeline-resource.yaml

# PVC
oc apply -f pvc.yaml

# TASKS
oc apply -f maven-task.yaml
oc apply -f sca-task.yaml
oc apply -f sast-task.yaml
oc apply -f push-task.yaml
oc apply -f deploy-task.yaml

# SECRETS
oc apply -f quay-secret.yaml

# PIPELINE
oc apply -f ci-pipeline.yaml

# PIPELINE RUN
cd ../ && \
cd tekton/cli && \
./tkn pipeline start ci-pipeline --workspace name="source-repo-workspace",claimName="tekton-source-repo-pvc"

cd ../../ && \
cd tekton-pipelines-maven-demo

# CD
oc apply -f service-account.yaml
oc apply -f cd-pipeline.yaml

cd ../ && \
cd tekton/cli && \
./tkn pipeline start cd-pipeline --workspace name="source-repo-workspace",claimName="tekton-source-repo-pvc"