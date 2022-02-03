from flask import Flask
from flask import request
import json

app = Flask(__name__)

@app.route('/', methods=['POST', 'GET'])
def index():
    q = request.args.get('q', request.form.get('q', ''))
    # potentially try to load the contents as javascript:
    # j = json.loads(q)
    # do some processing ...
    ret = {
      'r': 'Echo %s' % q
    }
    return json.dumps(ret)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
