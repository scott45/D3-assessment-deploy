#!/usr/bin/env python3
import os

from src.api.v1.models import Meal

from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand

from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView

from src.api.__init__ import app, databases

migrate = Migrate(app, databases)
manager = Manager(app)
manager.add_command('databases', MigrateCommand)

admin = Admin(app)
admin.add_view(ModelView(Meal, databases.session))

@manager.command
def init_db():
    os.system('createdb servicepkg_db')
    os.system('createdb sptesting_db')
    print('Databases created')


@manager.command
def drop_db():
    os.system(
        'psql -c "DROP DATABASE IF EXISTS aptesting_db"')
    os.system(
        'psql -c "DROP DATABASE IF EXISTS servicepkg_db"')
    print('Databases dropped')


if __name__ == '__main__':
    manager.run()
