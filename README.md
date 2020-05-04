# Depolying Synopsys Tools in Tekton Pipelines

This is an example to show how we can deploy and utilize Synopsys SAST tool (Coverity on Polaris), SCA tool (Black Duck), IAST tool (Seeker) & DAST tool (Tinfoil) in Tekton Pipelines with caching Maven dependencies and reducing build time by avoiding to download dependencies on every pipeline run.


```

Add URL and token for Black Duck in pipeline/ci-pipeline.yaml file
Add URL and token for Polaris in pipeline/ci-pipeline.yaml file

Change pipeline resource in resource/pipeline-resource.yaml file if needed
Change values (BASE64) in secret/registry-secret.yaml file for repo credentials
USE deploy.sh script to deploy the application
```
