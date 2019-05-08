
'''
 201  ok resulting to  creation of something
 200  ok
 400  bad request
 404  not found
 401  unauthorized
 409  conflict
'''

'''
    (UTF) Unicode Transformation Format
    its a character encoding
    A character in UTF8 can be from 1 to 4 bytes long
    UTF-8 is backwards compatible with ASCII
    is the preferred encoding for e-mail and web pages
'''
from src.api.__init__ import app, databases
from flask import render_template

@app.route('/')
def homepage():
    """ The homepage route
    :return: A welcome message
    """
    return render_template('index.html')

# put API views here