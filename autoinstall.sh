#!/bin/bash

set -e

SERVICE_NAME="monitoreo-sismico"
INSTALL_DIR="/opt/monitoreo_sismico"
PYTHON_EXEC="$(which python3)"

echo "📦 Instalando servicio de monitoreo sísmico..."

# Verificar si python3 está disponible
if [ -z "$PYTHON_EXEC" ]; then
  echo "❌ No se encontró Python 3. Instalando..."
  sudo apt update
  sudo apt install -y python3 python3-pip
  PYTHON_EXEC="$(which python3)"
fi

# Instalar Flask si no está
if ! "$PYTHON_EXEC" -c "import flask" &> /dev/null; then
  echo "📦 Flask no está instalado. Instalando..."
  sudo pip3 install flask
else
  echo "✅ Flask ya está instalado."
fi

# Crear carpeta destino
echo "📁 Copiando archivos al directorio $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r ./* "$INSTALL_DIR"

# Crear carpeta logs y archivo vacío si no existe
echo "🗃️ Verificando carpeta 'logs'..."
sudo mkdir -p "$INSTALL_DIR/logs"
sudo touch "$INSTALL_DIR/logs/data.csv"

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
User=root

[Install]
WantedBy=multi-user.target
EOF

# Hacer ejecutable
sudo chmod +x "$INSTALL_DIR/app.py"

# Activar servicio
echo "🔄 Activando servicio..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo "✅ Servicio '$SERVICE_NAME' instalado y corriendo desde http://<IP>:80"
