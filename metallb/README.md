# metallb

- Install `metallb` helm repo

```
helm repo add metallb https://metallb.github.io/metallb
helm repo update
```

- Create namespace for `metallb`

```
kubectl apply --filename metallb/namespace.yml
```

- Install `metallb` chart

```
helm install --namespace metallb metallb metallb/metallb
```

- Create Address Pool

```
kubectl apply --filename metallb/resources.yml
```
