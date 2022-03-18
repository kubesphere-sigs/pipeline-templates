# 实用的流水线模板

这里包含一些比较实用的流水线模板。在 KubeSphere Console 编辑一个新的流水线时，我们可以选择合适的模板来填充流水线脚本。

想要了解更多关于流水线模板如何工作，请参考：

- https://github.com/kubesphere/ks-devops/blob/master/docs/pipeline-template.md

## 目录结构

主要包含两个目录：

- experimental: 包含实验性的模板，由社区贡献者贡献并维护
- featured: 包含具有代表性的模板，将会同步至 [ks-devops-helm-chart](https://github.com/kubesphere-sigs/ks-devops-helm-chart)，作为 KubeSphere 内置模板

```bash
.
├── experimental
├── featured
│   ├── golang # Golang 模板
│   │   ├── golang.yaml # 模板配置
│   │   └── OWNERS # 模板所有者，可审核和合并该模板的 Pull Request。
│   │   └── README.md # 模板说明
│   ├── others # 其他模板
│   │   ├── others.yaml
│   │   └── OWNERS
│   │   └── README.md
│   └── nodejs
│       ├── nodejs.yaml
│       └── OWNERS
│       └── README.md
├── LICENSE
└── README.md
```

如果你想要对某个模板负责，请在对应模板目录下（例如：experimental/nodejs）创建 OWNERS 文件，并根据以下示例内容填写：

```yaml
approvers:
  - your GitHub name here
reviewers:
  - your GitHub name here
```

这样，就可以轻松管理这个模板，包括审核及合并模板。

## 如何应用模板并测试模板？

1. 应用模板
   ```bash
   kubectl apply -f featured/golang/golang.yaml
   ```
2. 进入 KubeSphere Console 并创建一条非多分支流水线
3. 点击“编辑流水线”
4. 选择想要测试的模板并点击“下一步”
5. 输入测试数据并点击“创建”
6. 点击“运行”进行测试

如果想要重新测试模板，请点击“编辑 Jenkinsfile”，清空内容并保存。重复上述步骤重复测试。

## 如何创建一个流水线模板？

### 模板基本信息

目前，模板基本信息包括：

- 名称：devops.kubesphere.io/displayName[Locale]
- 描述：devops.kubesphere.io/description[Locale]
- 图标：devops.kubesphere.io/icon

示例：

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
    devops.kubesphere.io/icon: demo-zh.svg
```

### 模板参数定义

模板参数定义包括：

| 名称        | 描述                                                                               | 可选 | 默认值 |
| ----------- | ---------------------------------------------------------------------------------- | ---- | :----- |
| name        | 参数名称，命名规则：单个单词，不能包含特殊字符。如：“templateName” 或者 “模板名称” | 否   |        |
| description | 参数描述                                                                           | 是   | ""     |
| required    | 指示该参数是否必填                                                                 | 是   | false  |
| default     | 参数默认值                                                                         | 是   |        |

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

### 模板参数替换

目前模板参数替换是按照 [Golang Template](https://pkg.go.dev/text/template) 的规则进行替换。

### 完整模板示例

- 包含中文参数的模板

  ```yaml
  apiVersion: devops.kubesphere.io/v1alpha3
  kind: ClusterTemplate
  metadata:
    name: echo
  spec:
    parameters:
      - name: 姓名
        description: Your name.
        required: true
        type: string
        default: "John"
    template: |
      pipeline {
        agent none
        stages {
          stage('Greet') {
            steps {
              echo 'Hello, $(.params.姓名)'
            }
          }
        }
      }
  ```

- 包含条件判断的模板

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
              echo 'Checking out'
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

- 输出模板分隔符(`$( )`)的模板

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
