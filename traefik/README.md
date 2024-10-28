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

- Fetch values file from charts

```
helm show values traefik/traefik > traefik/traefik.values.yml
```

- Install `traefik` chart

```
helm install --namespace traefik traefik traefik/traefik
```

- Create custom resources

```
kubectl apply --filename traefik/resources.yml
```

# pebble

- Install `pebble` helm repo

```
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
```

- Fetch values file from charts

```
helm show values jupyterhub/pebble > traefik/pebble.values.yml
```

- Install `pebble` helm chart

```
helm install --namespace traefik pebble jupyterhub/pebble
```
