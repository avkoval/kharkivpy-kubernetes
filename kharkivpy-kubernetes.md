# QR-code

![](./images/kharkivpy.png)

## Who am I

avkoval (bitbucket, github) +<http://alex.koval.kharkov.ua+>

  - Web (Python, Django) developer in +<https://ua2web.com+>
  - DevOps in <https://cupermind.com>
  - Backend Architect

# Why kubernetes

  - Fast scaling (container based, declarative objects configuration)
  - Fault tolerant (e.g. failures on nodes are not critical)
  - Containers are good abstractions:
      - e.g. local [Docker](https://docker.io) provides similar
        environment

## Why (when) not

  - overall more complex configuration which certainly requires an
    additional skills
  - for a small application could be overkill as it requires a lot of
    *overhead*, e.g. several nodes, masters, infra, other services will
    eat a lot of CPU/RAM resources.

# Architecture

![](./images/arch1.jpg)

## infrastructure questions not solved by kubernetes

1.  ingress, load balancers
2.  infra services - CNI

# Working with cluster - basics

## kubectl common commands

### namespaces

1.  kubectl get namespaces
    
    ``` tmux
    kubectl get namespaces
    ```
    
    Shows all namespaces. Some of them internal to kubernetes. Some of
    them are containers for your applications.

### kubectl pods

1.  get pods
    
    ``` tmux
    kubectl get pods
    ```

2.  delete pod
    
    ``` tmux
    # kubectl delete pod 
    ```

3.  exec -it
    
    ``` tmux
    # kubectl exec -it ...
    ```

### node

1.  get nodes
    
    ``` tmux
    kubectl get nodes
    kubectl describe node minikube
    ```

## Helm

<https://helm.sh/>

### Installing some ready packages

1.  search & install
    
    ``` tmux
    helm search repo stable
    helm install mymysql stable/mysql
    ```

2.  uninstall
    
    1.  List `helm ls`
        
        ``` tmux
        helm ls
        ```
    
    2.  Uninstall
        
        ``` tmux
        helm uninstall mymysql
        ```

# Presentation build with

  - [org-reveal](https://github.com/yjwen/org-reveal/)
  - [Reveal.js](https://revealjs.com/)
