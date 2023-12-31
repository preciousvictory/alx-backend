#!/usr/bin/env python3
"""A Basic Flask app.
"""
from flask_babel import Babel
from flask import Flask, render_template, request, g

app = Flask(__name__)
app.url_map.strict_slashes = False
babel = Babel(app)


users = {
    1: {"name": "Balou", "locale": "fr", "timezone": "Europe/Paris"},
    2: {"name": "Beyonce", "locale": "en", "timezone": "US/Central"},
    3: {"name": "Spock", "locale": "kg", "timezone": "Vulcan"},
    4: {"name": "Teletubby", "locale": None, "timezone": "Europe/London"},
}


class Config:
    """Represents a Flask Babel configuration.
    """
    LANGUAGES = ["en", "fr"]
    BABEL_DEFAULT_LOCALE = "en"
    BABEL_DEFAULT_TIMEZONE = "UTC"


app.config.from_object(Config)


@babel.localeselector
def get_locale():
    """dddd """
    locale = request.args.get('locale')
    if locale:
        return locale

    user = request.args.get('login_as')
    if user:
        user_locale = users.get(int(user)).get('locale')
        if user_locale in app.config['LANGUAGES']:
            return user_locale

    headers = request.headers.get("locale")
    if headers:
        return headers
    return request.accept_languages.best_match(app.config['LANGUAGES'])


def get_user():
    """ get_user """
    user = request.args.get('login_as')
    if user:
        return users.get(int(user))
    return None

@babel.timezoneselector
def get_timezone:
    """get_timezone"""
    timezone = request.args.get('timezone')

    user = request.args.get('login_as')
    if user and not timezone:
        timezone = users.get(int(user)).get('timezone')

    try:
        return pytz.timezone(timezone).zone
    except pytz.exceptions.UnknownTimeZoneError:
        return app.config['BABEL_DEFAULT_TIMEZONE']


@app.before_request
def before_request():
    """ before_request """
    g.user = get_user()


@app.route('/')
def hello() -> str:
    ''' render index.html template '''
    return render_template('5-index.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
