.PHONY: install reset delete watch fixone fixtwo fixthree

reset:
	-kubectl create namespace istio-system
	kubectl apply -f install/istio.yaml
	kubectl apply -f install/pilot.yaml
	kubectl apply -f install/bookinfo.yaml	
	kubectl apply -f install/frontend.networkpolicy.yaml
	kubectl apply -f install/backend.networkpolicy.yaml
	istioctl replace -f install/gateway.yaml || istioctl create -f install/gateway.yaml
	istioctl replace -f install/virtualservice.yaml || istioctl create -f install/virtualservice.yaml
	kubectl delete pods $$(kubectl get pod | grep -v NAME | awk {'print $$1'})

reset.soft:
	kubectl apply -f install/pilot.yaml
	kubectl apply -f install/bookinfo.yaml	
	kubectl apply -f install/frontend.networkpolicy.yaml
	kubectl apply -f install/backend.networkpolicy.yaml
	istioctl replace -f install/gateway.yaml || istioctl create -f install/gateway.yaml
	istioctl replace -f install/virtualservice.yaml || istioctl create -f install/virtualservice.yaml
	kubectl delete pods $$(kubectl get pod | grep -v NAME | awk {'print $$1'})

delete:
	kubectl delete -f install/istio.yaml
	kubectl delete -f install/pilot.yaml
	kubectl delete -f install/bookinfo.yaml	
	kubectl delete -f install/frontend.networkpolicy.yaml
	kubectl delete -f install/backend.networkpolicy.yaml

fixone.diff:
	diff -C 20 install/frontend.networkpolicy.yaml fix-one/frontend.networkpolicy.yaml

fixone:
	kubectl apply -f fix-one/frontend.networkpolicy.yaml
	kubectl delete pods $$(kubectl get pod -l app=productpage | grep -v NAME | awk {'print $$1'})

fixtwo.diff:
	diff -C 3 install/pilot.yaml fix-two/pilot.yaml

fixtwo:
	kubectl apply -f fix-two/pilot.yaml

fixthree.diff:
	diff -C 20 install/virtualservice.yaml fix-three/virtualservice.yaml

fixthree:
	istioctl replace -f fix-three/virtualservice.yaml || istioctl create -f fix-three/virtualservice.yaml

watch:
	watch -n 10 kubectl get po --all-namespaces
	