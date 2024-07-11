## Pre req
Create api token for root@pam run on pve terminal:
`pveum user token add root@pam provider --privsep=0`

Local:
Install Terraform
-  https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
Install Ansible
- https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip

# Example variables
local.auto.tfvar
```
pve_user           = "root"
pve_realm          = "pam"
pve_api_token      = "<token>"
pve_api_token_name = "provider"
pve_password       = "<password>"
pve_node_endpoint  = "<ip_addr>"
pve_node_id        = "pve"


public_bridge = "vmbr0"
agent_number  = 2

```

# Commands
In Terraform dir:
- `terraform init`
- `terraform apply`
In Ansible dir:
- `python inventory.py`
- `ansible-playbook -i <inventory_name>.ini playbook.yaml`

# Portainer
As part of this playbook we deploy helm chart with portainer
go to https://<controller-ip>:30779






# Demo app

### index.html
```
<html>
<head>
  <title>Hello World!</title>
</head>
<body>Hello World!</body>
</html>
```

`$ kubectl create configmap hello-world --from-file index.html`

### hello-world.yaml
```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-world
            port:
              number: 80

---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  ports:
    - port: 80
      protocol: TCP
  selector:
    app:  hello-world

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-nginx
spec:
  selector:
    matchLabels:
      app: hello-world
  replicas: 3
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: hello-world-volume
          mountPath: /usr/share/nginx/html
      volumes:
      - name: hello-world-volume
        configMap:
          name: hello-world
```

`$ kubectl apply -f hello-world.yml`