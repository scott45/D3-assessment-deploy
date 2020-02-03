[![AssessmentD3](https://img.shields.io/badge/Scott%20Businge-D3-green.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Eat-out CI & CD   E3 Assessment

## Introduction;
Done to demonstrate CD & CD skills on a Flask application. 
The Application is live on http://104.154.204.229:8000/ (this might be down after sometime to cut on GCP billing costs)

To test out the CI & CD functionality;

```
Clone the repo `git clone https://github.com/scott45/D3-assessment-deploy.git`

Create a virtual env and activate it `virtualenv kate` and `source kate/bin/activate`

Install the requirements `pip install -r requirements.txt` 

To test out the application locally, run `python run.py`

Navigate to `src/api/templates` and edit something in the `index.html` file

Commit your changes and push to github `on the master branch` (Make sure you've accepted the github invite to get push access)

CircleCI will pick up the changes, run the build, deploy steps. Docker will dockerize the application and Kubernetes will set the new built image as the latest deployment.

Navigate to the browser on `http://104.154.204.229:8000/` and look out for your changes that will be baked in the new image.
```

## Tools & platforms;

```
Docker

Google Cloud / Kubernetes

CircleCI

Flask / YAML / BASH
 ```

## License

### The MIT License (MIT)

Copyright (c) 2019 [BUSINGE SCOTT [ANDELA]]

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
