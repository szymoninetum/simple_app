# Docker & k8s tutorial app
---
---
## Docker-compose


***
## k8s
***
Please, notice that 'alias' was used as follows:
alias k="kubectl"

Steps to deploy:
1. minikube start --driver=docker (you can change driver to VirtualBox, Podman, Hyper-V. Please refer to: https://minikube.sigs.k8s.io/docs/drivers/ for details)
2. k apply -f deployment.yaml -f service.yaml
* Check whether pods and services were correctly deployed. Use these commands:
   * k get pods
   * k get svc
   * k get deploy <br /><br />
In case there are some errors, please check 'logs' and 'description'. Use these commands:
 
   * k logs [NAME_POD] <br />
   * k describe pod [NAME_POD] <br />
as below:
![Pods](/images/pods.png)


3. Open new Terminal Window and use command:
   * minikube tunnel

4. Go back to previous Terminal Window and use command:
   * minikube service [NAME_SERVICE] (use command k get svc to find service name) <br /><br />
   Web application should appear in new tab of your browser

<br />
Please, refer to documentation: <br /> <br />

### Docker & Docker Compose documentation <br />
https://docs.docker.com/compose/ <br />

### Minikube documentation <br />
 https://minikube.sigs.k8s.io/docs/ <br />

### k8s documentation <br />
https://kubernetes.io/docs/setup/ <br />
<br /> <br />
Here are some most common bugs/issues with potential fixes:
### #k8s# CrashLoopBackOff Error:
* https://komodor.com/learn/how-to-fix-crashloopbackoff-kubernetes-error/?msclkid=774696e6c14511eca3c886b9d4e936ab
* https://stackoverflow.com/questions/60070108/crashloopbackoff-back-off-restarting-failed-container?msclkid=87368894c4c711ec997691160b357e23

### #Docker# Start, Stop, Remove Docker Containers 
* https://www.thegeekstuff.com/2016/04/docker-compose-up-stop-rm/#:~:text=1%20Start%20Docker%20Containers%20In%20the%20Background.%20All,running%20in%20the%20foreground%2C%20you%20just...%20More%20

### #Docker-Compose# Compose specification - fixing networks issues
* https://docs.docker.com/compose/compose-file/#network_mode

### #Docker# "Port is already allocated" error
* https://simplernerd.com/docker-port-allocated/

## Recommended tutorials and videos:
* https://www.youtube.com/watch?time_continue=1&v=d6WC5n9G_sM&feature=emb_logo
* https://www.youtube.com/watch?v=qmDzcu5uY1I
* https://www.youtube.com/watch?v=s_o8dwzRlu4

<br /><br /><br /><br /><br />
## Alternative option
***
Please, note that there is one more option to deploy it from Docker-Compose by using **KOMPOSE** option. You need translate Docker Compose file to Kubernetes Resources. Use documentation below:
* https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/