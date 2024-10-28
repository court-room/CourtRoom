# storage

- Use `hostpath-storage` addon to create a volme provisioner for the cluster

```
microk8s enable hostpath-storage
```

- Create custom storage class for each disk

```
kubectl apply --filename storage/resources.yml
```
