# postgres

- Install `cloud native postgres` helm repo

```
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
```

- Create namespace for `cnpg`

```
kubectl apply --filename cnpg/namespace.yml
```

- Install `cnpg` chart

```
helm install --namespace cnpg cnpg cnpg/cloudnative-pg
```

- Create custom resources

```
kubectl apply --filename cnpg/resources.yml
```
