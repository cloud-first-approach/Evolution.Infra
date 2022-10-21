#create ns
kubectl create ns evolution

dapr init -k --enable-mtls=true
#Mssql 
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution
#AWS S3 Access
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY="AKIAYVIT7U44JIUFUKW4" -n evolution
#AWS S3 Access
kubectl create secret generic secret --from-literal=AWS_SECRET_KEY="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" -n evolution
#Install redis
helm install redis .\Evolution.infra\deploy\k8s\infra\base\redis\charts\redis\ 