KEY_NAME := id_rsa
SECRET_NAME := ssh-key
ns ?= ssh
key ?= ~/.ssh/id_rsa

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

.SILENT: create-deployment install uninstall value connect
.PHONY: create-deployment install uninstall value connect

install: create-deployment
	kubectl apply -f deployment.yaml;

create-deployment:
	if [ -f ${key} ]; then \
		cat templates/namespace.yaml > deployment.yaml; \
		sed 's/{{ .Values.secretName }}/${SECRET_NAME}/' templates/secret.yaml | \
		sed 's/{{ .Values.keyName }}/${KEY_NAME}/' >> deployment.yaml; \
		cat ${key} | base64 | sed 's/^/    /' > key.base64; \
		sed -i -e '/{{ .Values.privateKey }}/{r key.base64' -e 'd}' deployment.yaml;\
		sed 's/{{ .Values.secretName }}/${SECRET_NAME}/' templates/replication.yaml | \
		sed 's/{{ .Values.keyName }}/${KEY_NAME}/' >> deployment.yaml; \
		sed -i 's/{{ .Release.Namespace }}/${ns}/' deployment.yaml; \
		rm key.base64; \
	else \
		echo "file ${key} doesn't exist, try executing make with key=path_to_private_key"; \
		exit 1; \
	fi

value:
	if [ -f ${key} ]; then \
		cat ${key} | base64 > helm/key.base64; \
	else \
		echo "file ${key} doesn't exist, try executing make with key=path_to_private_key"; \
		exit 1; \
	fi

connect:
	./connect.sh ${ns} $(call args,'')

uninstall:
	if [ -f deployment.yaml ]; then \
		kubectl delete -f deployment.yaml; \
		rm deployment.yaml; \
	else \
		echo "Couldn't find deployment.yaml, try executing \nmake create-deployment key=path_to_private_key"; \
	fi 
	
	