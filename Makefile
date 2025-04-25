.PHONY: init-server server-up

init-server:
	direnv allow
	uv run python -c "import base64, secrets; print(base64.b64encode(secrets.token_bytes(32)).decode('ascii'))" > ./secret && chmod 0600 ./secret
	docker-compose up -d

server-up:
	direnv allow
	docker-compose up -d