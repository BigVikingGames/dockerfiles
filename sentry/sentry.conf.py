
# This file is just Python, with a touch of Django which means you
# you can inherit and tweak settings to your hearts content.
from sentry.conf.server import *

import os.path

CONF_ROOT = os.path.dirname(__file__)

postgres = os.getenv('POSTGRES_PORT_5432_TCP_ADDR')
mysql = os.getenv('MYSQL_PORT_3306_TCP_ADDR')
if postgres:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql_psycopg2',
            'NAME': os.getenv('SENTRY_DB_NAME') or 'postgres',
            'USER': os.getenv('SENTRY_DB_USER') or 'postgres',
            'PASSWORD': os.getenv('SENTRY_DB_PASSWORD') or '',
            'HOST': postgres,
            'PORT': '',

            'OPTIONS': {
                'autocommit': True,
            },
        },
    }
elif mysql:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': (
                os.getenv('SENTRY_DB_NAME')
                or os.getenv('MYSQL_ENV_MYSQL_DATABASE')
                or ''
            ),
            'USER': (
                os.getenv('SENTRY_DB_USER')
                or os.getenv('MYSQL_ENV_MYSQL_USER')
                or 'root'
            ),
            'PASSWORD': (
                os.getenv('SENTRY_DB_PASSWORD')
                or os.getenv('MYSQL_ENV_MYSQL_PASSWORD')
                or os.getenv('MYSQL_ENV_MYSQL_ROOT_PASSWORD')
                or ''
            ),
            'HOST': mysql,
            'PORT': '',
        },
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': (
                os.getenv('SENTRY_DB_NAME')
                or os.path.join(CONF_ROOT, 'sentry.db')
            ),
            'USER': '',
            'PASSWORD': '',
            'HOST': '',
            'PORT': '',
        },
    }

# You should not change this setting after your database has been created
# unless you have altered all schemas first
#SENTRY_USE_BIG_INTS = True

# If you're expecting any kind of real traffic on Sentry, we highly recommend
# configuring the CACHES and Redis settings

###########
## Redis ##
###########

# Generic Redis configuration used as defaults for various things including:
# Buffers, Quotas, TSDB

SENTRY_OPTIONS['redis.clusters'] = {
    'default': {
        'hosts': {
            0: {
                'host': os.getenv('REDIS_PORT_6379_TCP_ADDR') or 'localhost',
                'port': os.getenv('REDIS_PORT_6379_TCP_PORT') or 6379,
                'password': os.getenv('SENTRY_REDIS_PASSWORD')
            }
        }
    }
}

###########
## Cache ##
###########

# If you wish to use memcached, install the dependencies and adjust the config
# as shown:
#
#   pip install python-memcached
#
# CACHES = {
#     'default': {
#         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
#         'LOCATION': ['127.0.0.1:11211'],
#     }
# }
#
# SENTRY_CACHE = 'sentry.cache.django.DjangoCache'

memcached = os.getenv('MEMCACHED_PORT_11211_TCP_ADDR')
if memcached:
    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
            'LOCATION': [memcached + ':11211'],
        }
    }
    SENTRY_CACHE = 'sentry.cache.django.DjangoCache'
else:
    SENTRY_CACHE = 'sentry.cache.redis.RedisCache'

###########
## Queue ##
###########

# See http://sentry.readthedocs.org/en/latest/queue/index.html for more
# information on configuring your queue broker and workers. Sentry relies
# on a Python framework called Celery to manage queues.

CELERY_ALWAYS_EAGER = False
BROKER_URL = (
    'redis://'
    + ':'
    + os.getenv('SENTRY_REDIS_PASSWORD')
    + '@'
    + os.getenv('REDIS_PORT_6379_TCP_ADDR') or 'localhost'
    + ':'
    + os.getenv('REDIS_PORT_6379_TCP_PORT') or '6379'
)

#################
## Rate Limits ##
#################

SENTRY_RATELIMITER = 'sentry.ratelimits.redis.RedisRateLimiter'

####################
## Update Buffers ##
####################

# Buffers (combined with queueing) act as an intermediate layer between the
# database and the storage API. They will greatly improve efficiency on large
# numbers of the same events being sent to the API in a short amount of time.
# (read: if you send any kind of real data to Sentry, you should enable buffers)

SENTRY_BUFFER = 'sentry.buffer.redis.RedisBuffer'

############
## Quotas ##
############

# Quotas allow you to rate limit individual projects or the Sentry install as
# a whole.

SENTRY_QUOTAS = 'sentry.quotas.redis.RedisQuota'

##########
## TSDB ##
##########

# The TSDB is used for building charts as well as making things like per-rate
# alerts possible.

SENTRY_TSDB = 'sentry.tsdb.redis.RedisTSDB'

################
## Web Server ##
################

# You MUST configure the absolute URI root for Sentry:
SENTRY_OPTIONS['system.url-prefix'] = os.getenv('SENTRY_URL_PREFIX') or 'http://localhost' # No trailing slash!

# If you're using a reverse proxy, you should enable the X-Forwarded-Proto
# and X-Forwarded-Host headers, and uncomment the following settings
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
USE_X_FORWARDED_HOST = True

SENTRY_WEB_HOST = '0.0.0.0'
SENTRY_WEB_PORT = 9000
SENTRY_WEB_OPTIONS = {
    'workers': os.getenv('SENTRY_WEB_WORKERS') or 3,  # the number of gunicorn workers
    'limit_request_line': 0,  # required for raven-js
    'secure_scheme_headers': {'X-FORWARDED-PROTO': 'https'},
}

#################
## Mail Server ##
#################

# For more information check Django's documentation:
#  https://docs.djangoproject.com/en/1.3/topics/email/?from=olddocs#e-mail-backends

# TODO figure out a solid normalized emailing solution :(

SENTRY_OPTIONS['mail.backend'] = 'django.core.mail.backends.smtp.EmailBackend'

SENTRY_OPTIONS['mail.host'] = os.getenv('EMAIL_HOST') or 'localhost'
SENTRY_OPTIONS['mail.password'] = os.getenv('EMAIL_HOST_PASSWORD') or ''
SENTRY_OPTIONS['mail.username'] = os.getenv('EMAIL_HOST_USER') or ''
SENTRY_OPTIONS['mail.port'] = int(os.getenv('EMAIL_PORT') or 25)
SENTRY_OPTIONS['mail.use-tls'] = int(os.getenv('EMAIL_USE_TLS') or 0) > 0

# The email address to send on behalf of
SENTRY_OPTIONS['mail.from'] = os.getenv('EMAIL_FROM') or 'root@localhost'

###########
## etc. ##
###########

# If this file ever becomes compromised, it's important to regenerate your SECRET_KEY
# Changing this value will result in all current sessions being invalidated
SENTRY_OPTIONS['system.secret-key'] = os.getenv('SECRET_KEY') or 'QqD2ncal7vLDnMLNliLdCN9uRqLujMiXIrOlSYsXvKeSPkyeYQwEXg=='

# http://twitter.com/apps/new
# It's important that input a callback URL, even if its useless. We have no idea why, consult Twitter.
TWITTER_CONSUMER_KEY = os.getenv('TWITTER_CONSUMER_KEY') or ''
TWITTER_CONSUMER_SECRET = os.getenv('TWITTER_CONSUMER_SECRET') or ''

# http://developers.facebook.com/setup/
FACEBOOK_APP_ID = os.getenv('FACEBOOK_APP_ID') or ''
FACEBOOK_API_SECRET = os.getenv('FACEBOOK_API_SECRET') or ''

# http://code.google.com/apis/accounts/docs/OAuth2.html#Registering
GOOGLE_OAUTH2_CLIENT_ID = os.getenv('GOOGLE_OAUTH2_CLIENT_ID') or ''
GOOGLE_OAUTH2_CLIENT_SECRET = os.getenv('GOOGLE_OAUTH2_CLIENT_SECRET') or ''

# https://github.com/settings/applications/new
GITHUB_APP_ID = os.getenv('GITHUB_APP_ID') or ''
GITHUB_API_SECRET = os.getenv('GITHUB_API_SECRET') or ''

# https://trello.com/1/appKey/generate
TRELLO_API_KEY = os.getenv('TRELLO_API_KEY') or ''
TRELLO_API_SECRET = os.getenv('TRELLO_API_SECRET') or ''

# https://confluence.atlassian.com/display/BITBUCKET/OAuth+Consumers
BITBUCKET_CONSUMER_KEY = os.getenv('BITBUCKET_CONSUMER_KEY') or ''
BITBUCKET_CONSUMER_SECRET = os.getenv('BITBUCKET_CONSUMER_SECRET') or ''
