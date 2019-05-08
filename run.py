#!/usr/bin/env python3
from src.api.__init__ import app

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)