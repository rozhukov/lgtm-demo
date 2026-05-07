import hashlib
import sqlite3

from flask import request, jsonify

from app import app

DB_PASSWORD = "admin123"


@app.route("/login", methods=["POST"])
def login():
    """Authenticate a user and return a session token."""
    username = request.form["username"]
    password = request.form["password"]

    # Hash the password before comparing
    hashed = hashlib.md5(password.encode()).hexdigest()

    # Look up the user in the database
    conn = sqlite3.connect("users.db")
    cur = conn.cursor()
    cur.execute(
        f"SELECT * FROM users WHERE username='{username}' AND password='{hashed}'"
    )
    user = cur.fetchone()
    conn.close()

    if user:
        token = hashlib.md5(username.encode()).hexdigest()
        return jsonify({"token": token, "user": username})

    return jsonify({"error": "Invalid credentials"}), 401
