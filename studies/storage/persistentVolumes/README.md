# Persistent Volume Types

No k8s basicamente temos dois tipos de volumes os persistentes e o efemeral (no qual apenas `EmptyDir`) entra nessa categoria.

Para os Persistent Volumes temos 3 caras principais.

# Storage Class

Serve como a abstração para se criar um PV, semelhante ao `Deployment + ReplicaSet`, o `Storage Class` fala a forma que os `PV's` seram provisionados. 
Geralmente isso é feito em conjunto com o `PVC`, onde o `PVC` solicita um `PV`, mas em vez de o `PVC` ir direto para o `PV` ele bate no `SC`, então o `SC` cria um `PV`. 

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: slow-hdd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: sc1
  fsType: ext4
```

Como pode ser visto tem o tipo de `provisioner`, ali diz a Cloud Provider que vai usar etc... Em resumo, também é necessário que o Cloud Provider tenha o CSI (Container Storage Interface) que é um abstração para unificar o provisionamento de storage para os containers / k8s.

# Persistent Volume

É o concreto, em resumo, é o volume provisionado, exitem duas formas de ser criado, usando `PV + PVC` de forma direta, dai crio o PV e ele fica existindo no `cluster` para ser utilizado, ou pode ser criado de forma dinâmica usando o `SC`. De modo geral, é melhor usar o `SC` para provisionar o `PV`, porque reduz complecidade.

# Persistent Volume Claim

É a solicitação de um `PV`, é como se fosse falar, preciso de um `volume` nesse formato X, geralmente é o "usuário" que pede isso, com usuário quero direto `Pod`, mas também no sentido de cliente e administrator, porque o `SC` e `PV` fica mais do lado do administrador.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  resources:
    requests:
      storage: 50Gi
  storageClassName: sc1
  accessModes:
    - ReadWriteOnce
```

Quando usado com o `SC`, não bate direto no `PV` pré criado, mas é provisionado no momento da criação, o `spec` é mais como se fosse um `match` para o `PV`, no caso do uso com o `SC` ele sempre vai dar "match" sempre, porque é provisionado no momento, mas caso fosse com um `PV` pré existente pode ocorrer de o `PV` não existir e assim não dar esse "match". 