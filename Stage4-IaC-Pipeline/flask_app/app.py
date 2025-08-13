# import the Flask class from the flask library to create the application
from flask import Flask

# Create an instance of the Flask application
# '__name__' is a special python variable that gets the name of the current module
# Flask uses this to know where to find resources like templates and static files
app = Flask(__name__)

# This is a 'decorator' that tells Flask which URL should trigger our function
# In this case, when a user visits the root URL ('/'), the 'hellow_world' function runs
@app.route('/')
def hello_world():
    # This function returns the string that will be displayed in the web browser
    # Use an <h1> HTML tag to make the text a large heading
    return '<h1>Hellow, World! From our container</h1>'

# This is a standard Python block that checks if the script is being run directly
# If it is, 'app.run()' starts the web server
if __name__ == '__main__':
    # `host='0.0.0.0'` makes the server accessible from outside the container
    # which is necessary for Docker
    # `port=5000` sets the port where the application will listen for requests
    app.run(host='0.0.0.0', port='5000')
