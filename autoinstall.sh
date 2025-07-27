#!/bin/bash

set -e

SERVICE_NAME="monitoreo-sismico"
INSTALL_DIR="$HOME/monitoreo_sismico"
REPO_URL="https://github.com/akthanon/monitoreo_sismico.git"
PYTHON_EXEC="$(which python3)"

echo "📦 Instalando servicio de monitoreo sísmico en $INSTALL_DIR..."

# Instalar Python si no existe
if [ -z "$PYTHON_EXEC" ]; then
  echo "❌ No se encontró Python 3. Instalando..."
  sudo apt update
  sudo apt install -y python3 python3-pip
  PYTHON_EXEC="$(which python3)"
fi

# Instalar Flask si no está
if ! "$PYTHON_EXEC" -c "import flask" &> /dev/null; then
  echo "📦 Flask no está instalado. Instalando con pip..."
  pip3 install --user flask
else
  echo "✅ Flask ya está instalado."
fi

# Clonar el repositorio
if [ -d "$INSTALL_DIR" ]; then
  echo "📁 Ya existe $INSTALL_DIR. Eliminando..."
  rm -rf "$INSTALL_DIR"
fi

echo "🔻 Clonando desde $REPO_URL..."
git clone "$REPO_URL" "$INSTALL_DIR"

# Crear carpeta logs y archivo vacío
mkdir -p "$INSTALL_DIR/logs"
touch "$INSTALL_DIR/logs/data.csv"

# Crear archivo de servicio
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
echo "⚙️ Creando archivo de servicio en $SERVICE_FILE..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Servidor Flask de Monitoreo Sismográfico
After=network.target

[Service]
WorkingDirectory=$INSTALL_DIR
ExecStart=$PYTHON_EXEC app.py
Restart=on-failure
User=$USER
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

# Activar servicio
echo "🔄 Activando servicio..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo "✅ Servicio '$SERVICE_NAME' instalado y corriendo desde $INSTALL_DIR"
echo "🌐 Accede desde http://<IP>:80"
