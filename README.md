# A collection of useful Pipeline Templates

This is a collection of useful Pipeline Templates. We use this list to populate Pipeline Template choosers available in
the KubeSphere DevOps console when editing a fresh Pipeline.

For more information about how Pipeline Templates work, the following resources are a great place to start:
- https://github.com/kubesphere/ks-devops/blob/master/docs/pipeline-template.md

# Folder structure

```bash

```

# How to make a Pipeline Template?

## 模板基本信息

目前，模板基本信息包括：

- 名称
- 描述
- 图标

如果你想要设置模板基本信息，可在 annotations 中添加：

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

## 模板参数定义

模板参数定义包括：

| 名称          | 描述        | 可选  |  默认值  |
|-------------|-----------|-----|:-----:|
| name        | 参数名称      | 否   |       |
| description | 参数描述      | 是   |  ""   |
| required    | 指示该参数是否必填 | 是   | false |
| default     | 参数默认值     | 是   ||

示例：

```yaml
parameters:
  - name: name
    description: Your name here.
    required: true
    default: John
  - name: revision
    description: Git revision.
    required: true
    default: main
```

## 模板参数替换

目前模板参数替换是按照 [golang template](https://pkg.go.dev/text/template) 的规则进行替换，后期会添加更多的方便的函数。

## Exemplary Pipeline Template

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

- Escape delimiters("$( )") template

```yaml
apiVersion: devops.kubesphere.io/v1alpha3
kind: ClusterTemplate
metadata:
  name: escape-delimiter-template
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
        stage('Escape delimiters') {
          steps {
            echo '$(`$(escaped content)`)'
          }
        }
      }
    }
```
