# A collection of useful Pipeline Templates

# Folder structure

# How to make a Pipeline Template?

如果你想要添加模板的标题和描述，可在 annotations 中添加：

```yaml
apiVersion: devops.kubesphere.io/v1alpha3
kind: ClusterTemplate
metadata:
  name: demo
  annotations:
    devops.kubesphere.io/displayNameEN: Demo
    devops.kubesphere.io/displayNameZH: 示例
    devops.kubesphere.io/descriptionEN: This is a template for demo.
    devops.kubesphere.io/descriptionZH: 这是一个示例模板。
    devops.kubesphere.io/iconEN: demo-en.svg
    devops.kubesphere.io/iconZH: demo-zh.svg
```

## Exemplary

- Echo simple name.

```yaml
apiVersion: devops.kubesphere.io/v1alpha3
kind: ClusterTemplate
metadata:
  name: echo
spec:
  parameters:
    - name: name
      description: Your name. # optional
      required: true # optional
      type: string # optional
      default: "John" # optional
  template: |
    pipeline {
      agent none
      stages {
        stage('Greet') {
          steps {
            echo 'Hello, $(.params.name)'
          }
        }
      }
    }
```

- Conditional Template

```yaml
apiVersion: devops.kubesphere.io/v1alpha3
kind: ClusterTemplate
metadata:
  name: conditional-template
spec:
  parameters:
    - name: skipTests
      description: Should we skip the test stage.
      required: true
      default: false
      type: bool
  template: |
    pipeline {
      agent none
      stages {
        stage('Checkout') {
          steps {
            echo 'Checkouting'
          }
        }
        $(if not .params.skipTests)
        stage('Test') {
          steps {
            echo 'Testing'
          }
        }
        $(end)
        stage('Build') {
          steps {
            echo 'Building'
          }
        } 
      }
    }
```
