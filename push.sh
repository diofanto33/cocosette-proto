#!/bin/bash

# Script para generar y enviar archivos de prototipo a un repositorio remoto
# Parámetros:
#   $1: Nombre del servicio
#   $2: Versión de lanzamiento
#   $3: Nombre de usuario

# Verificar argumentos
if [ $# -ne 3 ]; then
  echo "Usage: $0 <service_name> <release_version> <username>"
  exit 1
fi

SERVICE_NAME=$1
RELEASE_VERSION=$2
USERNAME=$3

init_module() {
    cd "golang/$SERVICE_NAME" || exit 1
    if ! go mod init "github.com/$USERNAME/cocosette-proto/golang/$SERVICE_NAME"; then
      echo "Error: Failed to initialize Go module."
      exit 1
    fi
    if ! go mod tidy; then
      echo "Error: Failed to tidy Go modules."
      exit 1
    fi
    cd ../.. || exit 1
}

# Agregar y confirmar archivos de prototipo
add_and_commit_proto_files() {
  git add "proto/$SERVICE_NAME"
  git commit -m "Add proto files for $SERVICE_NAME"
}

# Agregar y confirmar archivos generados automáticamente
add_and_commit_generated_files() {
  git add "golang/$SERVICE_NAME"
  git commit -m "Add autogenerated files for $SERVICE_NAME"
  git add "third_party/OpenAPI"
  git commit -m "Add third party files for Swagger"
}

# Subir cambios al repositorio remoto
push_to_remote() {
  git push origin main -u
  git tag -a "golang/$SERVICE_NAME/$RELEASE_VERSION" -m "golang/$SERVICE_NAME/$RELEASE_VERSION"
  git push --tags
}

# Ejecutar funciones
init_module
add_and_commit_proto_files
add_and_commit_generated_files
push_to_remote

echo "Push successful."
