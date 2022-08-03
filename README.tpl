#!yaml-readme -p 'featured/*/*.yaml' --output README.md
## 实用的流水线模板

这里包含一些比较实用的流水线模板。在 KubeSphere Console 编辑一个新的流水线时，我们可以选择合适的模板来填充流水线脚本。

These are offical Pipeline templates:

{{- range $key, $val := .}}
Template Type: {{$key}}

| Name | Description |
|---|---|
{{- range $item := $val}}
| [{{index $item.metadata.annotations "devops.kubesphere.io/displayNameEN"}}]({{.fullpath}}) | {{index $item.metadata.annotations "devops.kubesphere.io/descriptionEN"}} |
{{- end}}
{{end}}

## Contribution

想要了解更多关于流水线模板如何工作，请参考：

- https://github.com/kubesphere/ks-devops/blob/master/docs/pipeline-template.md
- [Contribution guide](CONTRIBUTION.md)
