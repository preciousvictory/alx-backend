#!/usr/bin/env python3
"""0-add file
"""
from flask import Flask, render_template

app = Flask(__name__)
app.url_map.strict_slashes = False


@app.route('/')
def hello() -> str:
    ''' ingle / route and an index.html template '''
    return render_template('0-index.html')
