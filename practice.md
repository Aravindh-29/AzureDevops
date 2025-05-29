# pipeline is collection of jobs

```yaml
jobs:
  - job: build
    displayName: docker build
    pool:
      vmImage: ubuntu-22.04
    steps:
      - task: Docker@2
        inputs:
          command: 'build'
          Dockerfile: '**/Dockerfile'
```
# pipeline is collection of jobs for 'Dotnet Application'

```yaml

jobs:
  - job: dotnet build
    displayName: dotnet build
    pool:
      vmImage: ubuntu-22.04
    steps:
      - task: DotNetCoreCLI@2
          inputs:
            command: 'build'
            projects: '**/*.sln'
  - job: docker_compose
    displayName: 'Docker Compose'
    dependsOn: dotnet build
    pool:
      vmImage: ubuntu-22.04
    steps:
      - task: DockerCompose@1
        inputs:
          containerregistrytype: 'Azure Container Registry'
          dockerComposeFile: '**/docker-compose.yml'
          action: 'Build Services'
          projectName: 'DbConnectiontester'
```
# pipeline is collection of stages

```yaml

stages:
  - stage: build_stage
    displayName: 'Build_Stage'
    jobs:
      - job: dotnet_build
        displayName: 'Dotnet_Build'
        pool:
          vmImage: ubuntu-22.04
        steps:
          - task: DotNetCoreCLI@2
            inputs:
              command: 'build'
              projects: '**/*.sln'
  - stage: docker_compose_stage
    displayName: 'Docker Compose Stage'
    dependsOn: build_stage
    jobs:
      - job: docker_compose
        displayName: 'Docker Compose'
        pool:
          vmImage: ubuntu-22.04
        steps:
          - task: DockerCompose@1
            inputs:
              containerregistrytype: 'Azure Container Registry'
              dockerComposeFile: '**/docker-compose.yml'
              action: 'Build services'
              projectName: 'DbConnectiontester'
```