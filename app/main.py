from app import app
from flask import jsonify


@app.route("/health")
def health():
    return jsonify({"status": "ok"})
