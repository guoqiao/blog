Title: Flask Notes

## Hello World
vim `hello.py`:

    from flask import Flask
    app = Flask(__name__)

    @app.route("/")
    def hello():
        return "Hello World!"

    if __name__ == "__main__":
        app.run()

run it:

    python hello.py

visit site at:

    http://127.0.0.1:5000

## URL with params:

    @app.route('/user/<name>')
    def user(name):
        return '<h1>Hello, %s!</h1>' % name

## manage script:
vim `manage.py`:

    from flask import Flask
    from flask.ext.script import Manager
    app = Flask(__name__)
    manager = Manager(app)

    @app.route('/')
    def index():
        return '<h1>Hello World!</h1>'

    if __name__ == '__main__':
        manager.run()

then you can run site like django:

    python manage.py runserver

or run a shell for site:

    python manage.py shell

