Title: IPython notes

## load modules on startup

Create config file:

    ipython profile create

This will generate file at:

     ~/.ipython/profile_default/ipython_config.py

Uncomment line 55 and add lines you want:

    c.TerminalIPythonApp.exec_lines = [
        'from datetime import *',
        'from collections import *',
    ]
