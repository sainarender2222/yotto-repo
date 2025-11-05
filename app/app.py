from flask import Flask, Response
import os
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)
REQ = Counter('sample_app_requests_total', 'Total requests')

@app.route('/')
def index():
    REQ.inc()
    tenant = os.getenv('TENANT_NAME', 'unknown')
    return f"Hello from {tenant}!\n"

@app.route('/healthz')
def healthz():
    return "ok", 200

@app.route('/live')
def live():
    return "alive", 200

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))
