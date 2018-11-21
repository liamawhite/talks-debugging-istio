

reset:
	kubectl apply -f install/bookinfo.yaml -f install/bookinfo-gateway.yaml	
	kubectl apply -f install/frontend.networkpolicy.yaml -f install/backend.networkpolicy.yaml
	kubectl delete pods -n istio-system --wait=false $$(kubectl get pods -n istio-system -l istio=pilot -o jsonpath='{range .items[*]}{.metadata.name}{" "}{end}')
	kubectl delete po -n default --all

fixone.diff:
	diff -C 20 install/backend.networkpolicy.yaml fix-one/backend.networkpolicy.yaml

fixone:
	kubectl apply -f fix-one/backend.networkpolicy.yaml

fixtwo.diff:
	diff -C 20 install/bookinfo-gateway.yaml fix-two/bookinfo-gateway.yaml

fixtwo:
	kubectl apply -f fix-two/bookinfo-gateway.yaml
	
install.istio:
	-kubectl create namespace istio-system
	-kubectl label namespace istio-system istio=istio --overwrite
	-kubectl label namespace default istio-injection=enabled --overwrite
	kubectl apply -f install/crd.yaml -f install/istio-demo.yaml
