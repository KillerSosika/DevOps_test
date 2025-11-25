import os
import signal
import sys
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST", "DB_HOST_IS_UNSET")
VERSION = "v1.0"


def shutdown_handler(signal, frame):
    print(f"[{VERSION}] Received signal {signal}. Starting graceful shutdown...")
    sys.exit(0)

signal.signal(signal.SIGTERM, shutdown_handler)


@app.route('/healthz')
def health_check():
    """Health check endpoint. Повертає 200 OK."""
    return jsonify({
        "status": "Healthy",
        "version": VERSION
    }), 200

@app.route('/api/v1/status')
def get_status():
    """Основний ендпоінт, що показує конфігурацію."""
    return jsonify({
        "message": "Service operational.",
        "db_host": DB_HOST,
        "version": VERSION
    })


if __name__ == '__main__':
    print("Running in development mode...")
    app.run(host='0.0.0.0', port=5000, debug=True)