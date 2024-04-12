BUF_VERSION:=v1.17.0
SWAGGER_UI_VERSION:=v4.15.5

generate: generate/proto generate/swagger-ui
generate/proto:
	go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION) generate
generate/swagger-ui:
	SWAGGER_UI_VERSION=$(SWAGGER_UI_VERSION) ./scripts/generate-swagger-ui.sh

clean:
	rm -rf golang
	rm -rf third_party/OpenAPI
