# traefik

- Install `traefik` helm repo

```
helm repo add traefik https://traefik.github.io/charts
helm repo update
```

- Create namespace for `traefik`

```
kubectl apply --filename traefik/namespace.yml
```

- Install `traefik` chart

```
helm install --namespace traefik traefik traefik/traefik
```

- Create custom resources

```
kubectl apply --filename traefik/resources.yml
```
