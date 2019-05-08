import unittest

# parses json to string or files (or python dict and []
import json

# from config file
from src.api.__init__ import app, EnvironmentName, databases

'''
 201  ok resulting to  creation of something
 200  ok
 400  bad request
 404  not found
 401  unauthorized
 409  conflict
'''


# tests all functionality of servicepackage.py and there defined methods
class MealTestCases(unittest.TestCase):
    # testing client using testing environment
    def setUp(self):
        self.app = app.test_client()
        EnvironmentName('TestingEnvironment')
        databases.create_all()

        # creating a service package for testing purpose
        self.payloads = json.dumps({'name': 'Chicken', 'price': 500, 'description': 'Half chicken'})

    def tearDown(self):
        databases.session.remove()
        databases.drop_all()

    # test 1
    def test_1(self):
        pass

    # test 2
    def test_2(self):
        pass

    # test 3
    def test_3(self):
        pass

    # test 4
    def test_4(self):
        pass


