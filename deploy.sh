#Build and tag all images with latest and Git SHA tag
docker build -t sirasaoa/multi-client:latest -t sirasaoa/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t sirasaoa/multi-server:latest -t sirasaoa/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t sirasaoa/multi-worker:latest -t sirasaoa/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push latest tags of all images to Docker Hub
docker push sirasaoa/multi-client:latest
docker push sirasaoa/multi-server:latest
docker push sirasaoa/multi-worker:latest

#Push GIT SHA tags of all images to Docker Hub
docker push sirasaoa/multi-client:$SHA
docker push sirasaoa/multi-server:$SHA
docker push sirasaoa/multi-worker:$SHA

#Apply all Kubernetes config files inside k8s
kubectl apply -f k8s

#Imperative command to use GIT SHA tags of all images in kubernetes cluster
kubectl set image deployments/server-deployment server=sirasaoa/multi-server:$SHA
kubectl set image deployments/client-deployment server=sirasaoa/multi-client:$SHA
kubectl set image deployments/worker-deployment server=sirasaoa/multi-worker:$SHA
