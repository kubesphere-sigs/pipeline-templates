Considering the limitation of the Jenkins-based Pipeline step templates. There are two types of templates: basic and complex.

## Basic
The basic step templates should as more as possible. These steps come from Jenkins Pipeline (plugins). 
For example, we should have a template named `shell`. And there is a step that have the excatlly same name in Jenkins. 
In short, the template and step name must keep same for the basic case.

Considering the name of a CR (custom resource in Kubernetes) only allow lower-case. Please convert all the characters to be lower-case. 
For example, make `archiveArtifacts` to be `archiveartifacts`.

## Complex
There are any other limitation for the complex templates.
