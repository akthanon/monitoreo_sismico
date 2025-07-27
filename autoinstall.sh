#!/bin/bash

set -e

SERVICE_NAME="monitoreo-sismico"
INSTALL_DIR="$HOME/monitoreo_sismico"
PYTHON_EXEC="$(which python3)"

echo "📦 Instalando servicio de monitoreo sísmico en $INSTALL_DIR..."

# Verificar Python y Flask
if [ -z "$PYTHON_EXEC" ]; then
  echo "❌ No se encontró Python 3. Instalando..."
  sudo apt update
  sudo apt install -y python3 python3-pip
  PYTHON_EXEC="$(which python3)"
fi

if ! "$PYTHON_EXEC" -c "import flask" &> /dev/null; then
  echo "📦 Flask no está instalado. Instalando..."
  pip3 install --user flask
else
  echo "✅ Flask ya está instalado."
fi

# Crear carpeta logs y archivo vacío
mkdir -p "$INSTALL_DIR/logs"
touch "$INSTALL_DIR/logs/data.csv"

# Crear archivo de servicio
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
echo "⚙️ Creando archivo de servicio en $SERVICE_FILE..."

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Servidor Flask de Monitoreo Sismográfico (usuario)
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

# Recargar y habilitar el servicio
echo "🔄 Activando servicio..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo "✅ Servicio '$SERVICE_NAME' está corriendo desde $INSTALL_DIR"
echo "🌐 Accede desde http://<IP>:80"
