initialize-with-storage:
	terraform init \
	 -backend-config="access_key=${SPACES_ACCESS_TOKEN}" \
	 -backend-config="secret_key=${SPACES_SECRET_KEY}" \
	 -backend-config="bucket=${SPACES_TF_STATE_BUCKET}"

validate-tf:
	terraform fmt && \
	terraform validate


