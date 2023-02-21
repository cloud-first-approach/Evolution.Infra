# Mssql secret
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution
# AWS S3 Access secret
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY=$env:AWS_ACCESS_KEY -n evolution
# AWS S3 Access secret
kubectl create secret generic secret --from-literal=AWS_SECRET_KEY=$env:AWS_SECRET_KEY -n evolution