from flask import Flask, render_template, jsonify, send_file
from sensor import get_latest
import os

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route('/logs')
def descargar_csv():
    # Ruta absoluta o relativa desde donde se ejecuta el script
    return send_file(os.path.join('logs', 'data.csv'), as_attachment=True)

@app.route("/data")
def data():
    return jsonify(get_latest())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5770)
