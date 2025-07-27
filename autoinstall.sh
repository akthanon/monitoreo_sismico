#!/bin/bash

set -e

SERVICE_NAME="monitoreo-sismico"
REPO_URL="https://github.com/akthanon/monitoreo_sismico.git"
INSTALL_DIR="/opt/monitoreo_sismico"
PYTHON_EXEC="$(which python3)"

echo "📥 Clonando repositorio en $INSTALL_DIR..."

# Elimina versión anterior si existe
sudo rm -rf "$INSTALL_DIR"

# Clona el repositorio
sudo git clone "$REPO_URL" "$INSTALL_DIR"

# Verifica que app.py exista
if [ ! -f "$INSTALL_DIR/app.py" ]; then
  echo "❌ No se encontró app.py en el repositorio clonado."
  exit 1
fi

# Crear archivo de servicio
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "⚙️ Creando archivo de servicio systemd..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Servidor Flask de Monitoreo Sismográfico
After=network.target

[Service]
WorkingDirectory=$INSTALL_DIR
ExecStart=$PYTHON_EXEC app.py
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

# Hacer ejecutable por si acaso
sudo chmod +x "$INSTALL_DIR/app.py"

# Recargar systemd y habilitar el servicio
echo "🔄 Activando servicio..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "✅ Servicio '$SERVICE_NAME' instalado y en ejecución."
echo "📡 Accede a la página desde el navegador una vez que esté activo."
