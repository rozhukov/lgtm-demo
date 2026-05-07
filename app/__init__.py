from flask import Flask

app = Flask(__name__)

from app import main  # noqa: E402, F401
from app.auth import login  # noqa: E402, F401
