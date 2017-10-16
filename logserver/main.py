from flask import Flask, request, make_response, session, url_for, redirect, render_template, escape

# create the application instance
app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return log_request()


@app.route('/logrequest', methods=['GET', 'POST'])
def log_request():
    app.logger.info("%s %s", request.method, request.url)
    app.logger.info("%s", request.headers)
    app.logger.info("%s", request.data)
    first_line = '{} {}'.format(request.method, request.path)
    response = make_response(
        render_template('request.html',
                        first_line=first_line,
                        headers=request.headers,
                        body=request.data)
        , 200)
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0')


