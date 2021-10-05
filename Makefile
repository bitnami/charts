build:
	helm package charts/{kafka} --destination .deploy
index:
	helm repo index ./releases/0.1.0 --url https://bigtable2006.github.io/learn-helm/releases/0.1.0
	helm repo index . --url https://bigtable2006.github.io/learn-helm/releases/0.1.0
add:
	helm repo add learn-helm-charts https://bigtable2006.github.io/learn-helm
install:
	helm install kafka01 learn-helm-charts/kafka