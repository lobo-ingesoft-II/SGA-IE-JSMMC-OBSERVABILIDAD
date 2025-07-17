#!/bin/bash

set -e

# 1. Detectar sistema operativo y arquitectura
ARCH=$(uname -m)
OS=$(uname -s)

if [[ "$OS" == "Linux" ]]; then
    OS_NAME="linux"
elif [[ "$OS" == "Darwin" ]]; then
    OS_NAME="darwin"
else
    echo "❌ Sistema operativo no soportado: $OS"
    exit 1
fi

if [[ "$ARCH" == "x86_64" ]]; then
    ARCH_NAME="amd64"
elif [[ "$ARCH" == "arm64" ]]; then
    ARCH_NAME="arm64"
else
    echo "❌ Arquitectura no soportada: $ARCH"
    exit 1
fi

# 2. Obtener última versión estable de Grafana
LATEST_VERSION=$(curl -s https://api.github.com/repos/grafana/grafana/releases/latest | grep tag_name | cut -d '"' -f 4)
VERSION_CLEAN=${LATEST_VERSION#v}

# 3. Descargar y descomprimir
echo "📥 Descargando Grafana $VERSION_CLEAN para $OS_NAME-$ARCH_NAME..."

wget "https://dl.grafana.com/oss/release/grafana-${VERSION_CLEAN}.${OS_NAME}-${ARCH_NAME}.tar.gz" -O grafana.tar.gz
tar -xzf grafana.tar.gz
rm grafana.tar.gz

# 4. Mover a carpeta `grafana/` y crear alias de inicio
DIR_NAME="grafana-v${VERSION_CLEAN}"
mv "$DIR_NAME" grafana

echo ""
echo "✅ Grafana descargado y extraído en ./grafana"
echo ""
echo "👉 Para iniciar Grafana ejecuta:"
echo "   cd grafana"
echo "   ./bin/grafana-server web"
echo ""
echo "🌐 Luego visita: http://localhost:3000 (usuario: admin / contraseña: admin)"
