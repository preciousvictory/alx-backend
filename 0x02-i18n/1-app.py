#!/usr/bin/env python3
"""A Basic Flask app.
"""
from flask_babel import Babel
from flask import Flask, render_template

app = Flask(__name__)
app.url_map.strict_slashes = False
babel = Babel(app)


class Config:
    """Represents a Flask Babel configuration.
    """
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"


app.config.from_object(Config)

    
@app.route('/')
def hello() -> str:
    ''' render index.html template '''
    return render_template('0-index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
