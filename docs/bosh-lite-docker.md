## bosh-lite Docker image

Example Concourse pipeline configuration that pulls in bosh-lite Docker image:

```
jobs:
- name: test-bosh-lite
  public: true
  plan:
  - task: stuff
    privileged: true
    config:
      platform: linux
      image_resource:
        type: docker-image
        source:
          repository: bosh/bosh-lite
          tag: 9000.123.0
      run:
        path: /usr/bin/start-bosh
```
