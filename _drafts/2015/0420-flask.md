Title: Flask学习笔记

## Hello World!
hello.py:

	#!/usr/bin/env python
	# -*- coding: utf-8 -*-
	
	from flask import Flask, request
	
	app = Flask(__name__)
	
	@app.route('/')
	def index():
	    return '<h1>Hello World!</h1>'
	
	if __name__ == '__main__':
	    app.run(debug=True)

how to run:

    chmod a+x hello.py
    ./hello.py

##  url 参数
	
	@app.route('/user/<name>')
	def user(name):
	    return '<h1>Hello, %s!</h1>' % name
	    
## 全局的request以及获取UA
	
	#!/usr/bin/env python
	# -*- coding: utf-8 -*-
	
	from flask import Flask, request
	
	app = Flask(__name__)
	
	@app.route('/')
	def index():
	    ua = request.headers.get('User-Agent')
	    return '<h1>Hello %s!</h1>' % ua
	
	
	if __name__ == '__main__':
	    app.run(debug=True)
	    
	    
## 查看当前 url 映射

	from hello import app
	print app.url_map
	
	
## make_response and set_cookie

	from flask import make_response
	
	@app.route('/')
	def index():
		r = make_response('<h1>This document</h1>')		r.set_cookie('answer', '42')
		return r

## redirect

	from flask import redirect
	@app.route('/')
	def redirect_example():
	    return redirect('www.apple.com')


## abort
	
	from flask import abort
	@app.route('/user/<id>')
	def get_user(id):
	    user = load_user(id)
	    if not user:
	        abort(404)
	    return '<h1>Hello, %s!</h1>' % user.name


## flask-script
can add command line options to flask
install:

    pip install flask-script

extension.py:
    
    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    from flask import Flask
    from flask.ext.script import Manager
    app = Flask(__name__)
    manager = Manager(app)

    @app.route('/')
    def index():
        return '<h1>Hello World!</h1>'

    if __name__ == '__main__':
        manager.run()

now, when you run this file, it will show:

    positional arguments:
      {shell,runserver}
        shell            Runs a Python shell inside Flask application context.
        runserver        Runs the Flask development server i.e. app.run()

so, you can use `./extension.py runserver` to run app
or, use `./extension.py shell` to enter the shell of the app
and, use './extension.py runserver --help' to get help for runserver

## use jinja2 templates

dir tree:

    .
    ├── app.py
    └── templates
        ├── index.html
        └── user.html

code:
    
    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    from flask import Flask, render_template
    from flask.ext.script import Manager

    app = Flask(__name__)
    manager = Manager(app)

    @app.route('/')
    def index():
        return render_template('index.html')

    @app.route('/user/<name>')
    def user(name):
        return render_template('user.html', name=name)

    if __name__ == '__main__':
        manager.run()

vars in templates:

    <p>{{ mydict['key'] }}</p>
    <p>{{ mylist[3] }}</p>
    <p>{{ mylist[myindex] }}</p>
    <p>{{ myobj.func() }}</p>

filter:

    <p>{{ name|capitalize }}</p>
