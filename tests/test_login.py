def test_login_rejects_bad_credentials(client):
    resp = client.post("/login", data={"username": "nobody", "password": "wrong"})
    assert resp.status_code == 401
    assert resp.json["error"] == "Invalid credentials"
