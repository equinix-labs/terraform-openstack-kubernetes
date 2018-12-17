init-with-storage:

	if [ -z ${SPACES_ACCESS_TOKEN} ]; then \
		read -p "Set SPACES_ACCESS_TOKEN: " yn; \
		export SPACES_ACCESS_TOKEN=$yn; fi
	if [ -z ${SPACES_SECRET_KEY} ]; then \
		read -p "Set SPACES_SECRET_KEY: " yn; \
		export SPACES_SECRET_KEY=$yn; fi
	if [ -z ${SPACES_TF_STATE_BUCKET} ]; then \
		read -p "Set name of state bucket (SPACES_TF_STATE_BUCKET): " yn; \
		export SPACES_TF_STATE_BUCKET=$yn; fi

	terraform init \
	 -backend-config="access_key=${SPACES_ACCESS_TOKEN}" \
	 -backend-config="secret_key=${SPACES_SECRET_KEY}" \
	 -backend-config="bucket=${SPACES_TF_STATE_BUCKET}"

validate-apply:
	terraform fmt && \
	terraform validate && \
	terraform plan 


