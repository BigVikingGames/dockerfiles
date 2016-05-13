#!/usr/bin/env python

from os import getenv, path
from jinja2 import Environment, Template, FileSystemLoader

env = Environment(loader=FileSystemLoader(path.dirname(path.realpath(__file__))))

def env_override(value, key):
  return getenv(key, value)

env.filters['env_override'] = env_override

template = env.get_template('config.jinja')
print template.render()
