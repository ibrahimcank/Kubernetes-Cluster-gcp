# Kubernetes-Cluster-gcp


Merhalabar, 

Öncelikle terraform u indiriyoruz terraformun olduğu doysa pathini bilgisayarımızda enviroment variables daki path bölümüne ekliyoruz. 
main.tf isimli terraform dosyasını oluşturuyoruz cmd komut ekranı ile main.tf dosyasının bulunduğu dosya dizinine gidiyoruz sırasıyla 
terraform init komutunu girip terrafom klasörünü oluşturur ve klasör için gerekli yapılandırmaları sağlar
terraform plan komutunu girip yapılıcak değişkenleri görürüz ve 
terraform apply diyerek belirlenen işlemleri gerçekleştiriyoruz .


Helm ile grafana ve prometheus kuruyoruz.

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts komutu ile prometheus kuruyoruz.

helm repo add grafana https://grafana.github.io/helm-charts komutu ile grafana repolarını ekliyoruz.

kubectl create namespace monitoring komutunu girip bir namespace oluşturuyoruz 

helm install my-grafana grafana/grafana --namespace monitoring komutu ile helm chartını kubernetes clusterına yüklüyoruz chart ismini my-grafana olarak belirliyoruz repository nameini girip repoları yüklüyoruz monitoring namespaceine chartı deploy ediyoruz

kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo komutu ile grafanaya giriş için password alıyoruz.

kubectl expose deployment my-grafana --type=LoadBalancer --name=grafana-service --port=3000 --target-port=3000 --protocol=TCP -n monitoring komutu ile loadbalancer server typeında grafanayı public olarak ayağa kaldırıyoruz.
grafanaya giriş yapıyoruz 
connections bölümüne girip add new connetcion diyoruz data source olarak prometheus u seçiyoruz ve add new data source a tıklanır.
connetction bölümüne prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090 komutu giriyoruz ve bağlantı sağlıyoruz.
Sol taraftaki menüde alerting e basup alert rules bölümüne giriyoruz 
New alert rule diyoruz 
Define query and alert condition bölümüne bu komutu girip increase(kube_deployment_metadata_generation{deployment="nginx-deployment"}[1m]) herhangi bir pod restartında bize uyarı göndericek alert rule u oluşturuyoruz. 
