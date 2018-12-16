initialize-storage:
	terraform init \
	 -backend-config="access_key=$SPACES_ACCESS_TOKEN" \
	 -backend-config="secret_key=$SPACES_SECRET_KEY" \
	 -backend-config="bucket=$SPACE_BUCKET_NAME"

validate-tf:
	terraform fmt && \
	terraform validate

plan-apply:
	terraform plan && \
	terraform apply


