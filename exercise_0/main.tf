terraform {
  required_providers {
    harness = {
      source = "harness/harness"
      version = "0.34.3"
    }
  }
}

provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = "qmrzY7joS9SsdtHPFP8WHQ"
  platform_api_key = "pat.qmrzY7joS9SsdtHPFP8WHQ.674419cfffbf013c20ee0bbe.2ASb8pvt2nK0S5G3sWGT"
}
resource "harness_platform_pipeline" "example" {
  identifier = "identifier"
  org_id     = "default"
  project_id = "Manisha"
  name       = "Manisha"
  git_details {
    branch_name    = "branchName"
    commit_message = "commitMessage"
    file_path      = "filePath"
    connector_ref  = "terraformgitconnector"
    store_type     = "REMOTE"
    repo_name      = "repoName"
  }
 #tags = {
 #Name = "example"
#}
  yaml = <<-EOT
      pipeline:
          name: Manisha
          identifier: identifier
          allowStageExecutions: false
          projectIdentifier: Manisha
          orgIdentifier: default
          tags: {}
          stages:
              - stage:
                  name: dep
                  identifier: dep
                  description: ""
                  type: Deployment
                  spec:
                      serviceConfig:
                          serviceRef: service
                          serviceDefinition:
                              type: Kubernetes
                              spec:
                                  variables: []
                      infrastructure:
                          environmentRef: testenv
                          infrastructureDefinition:
                              type: KubernetesDirect
                              spec:
                                  connectorRef: terraformgitconnector
                                  namespace: test
                                  releaseName: release-<+INFRA_KEY>
                          allowSimultaneousDeployments: false
                      execution:
                          steps:
                              - stepGroup:
                                      name: Canary Deployment
                                      identifier: canaryDepoyment
                                      steps:
                                          - step:
                                              name: Canary Deployment
                                              identifier: canaryDeployment
                                              type: K8sCanaryDeploy
                                              timeout: 10m
                                              spec:
                                                  instanceSelection:
                                                      type: Count
                                                      spec:
                                                          count: 1
                                                  skipDryRun: false
                                          - step:
                                              name: Canary Delete
                                              identifier: canaryDelete
                                              type: K8sCanaryDelete
                                              timeout: 10m
                                              spec: {}
                                      rollbackSteps:
                                          - step:
                                              name: Canary Delete
                                              identifier: rollbackCanaryDelete
                                              type: K8sCanaryDelete
                                              timeout: 10m
                                              spec: {}
                              - stepGroup:
                                      name: Primary Deployment
                                      identifier: primaryDepoyment
                                      steps:
                                          - step:
                                              name: Rolling Deployment
                                              identifier: rollingDeployment
                                              type: K8sRollingDeploy
                                              timeout: 10m
                                              spec:
                                                  skipDryRun: false
                                      rollbackSteps:
                                          - step:
                                              name: Rolling Rollback
                                              identifier: rollingRollback
                                              type: K8sRollingRollback
                                              timeout: 10m
                                              spec: {}
                          rollbackSteps: []
                 # tags: "hey"
                  failureStrategies:
                      - onFailure:
                              errors:
                                  - AllErrors
                              action:
                                  type: StageRollback
  EOT
}

### Importing Pipeline from Git
resource "harness_platform_organization" "test" {
  identifier = "default"
  name       = "default"
}
resource "harness_platform_pipeline" "test" {
  identifier      = "gitx"
  org_id          = "default"
  project_id      = "Manisha"
  name            = "Manisha"
  import_from_git = true
  git_import_info {
    branch_name   = "master"
    file_path     = "exercisr_0/main.tf"
    connector_ref = "account.terraformgitconnector"
    repo_name     = "terraform"
  }
  pipeline_import_request {
    pipeline_name        = "gitx"
    pipeline_description = "Pipeline Description"
  }
}
