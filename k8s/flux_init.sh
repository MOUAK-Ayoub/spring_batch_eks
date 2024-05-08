flux bootstrap github --token-auth \
--owner=MOUAK-Ayoub --repository=flux-apps \
--personal  --branch=main --reconcile --private=false  \
--components-extra=image-reflector-controller,image-automation-controller



git clone https://github.com/MOUAK-Ayoub/flux-apps.git

mkdir {sources,helmreleases}

flux create source git  demo-chart \
   --url=https://github.com/MOUAK-Ayoub/spring_batch_eks.git \
   --branch=master \
   --namespace=default \
   --username=ayoub.mouak.2015@gmail.com \
   --password=$GITHUB_TOKEN \
   --export > sources/demo-chart.yaml

cd sources
kustomize create --autodetect --recursive
cd ..

flux create helmrelease demo-from-git \
  --interval=1m \
  --source=GitRepository/demo-chart \
  --chart=./k8s/demo \
  --namespace=default \
  --export > helmreleases/demo-helmrelease.yaml

cd helmreleases
kustomize create --autodetect --recursive
cd ..

git add .
git commit -am "commit sources and helmreleases"
git push