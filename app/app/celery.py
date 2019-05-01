from __future__ import absolute_import, unicode_literals
import os
from django.conf import settings
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')

app = Celery('app')

app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)


@app.task(bind=True)
def debug_task(self):
    print('Request: {0!r}'.format(self.request))


app.conf.update(
    BROKER_URL='redis://:{password}@redis:6379/0'.format(password=os.environ.get('REDIS_PASSWORD')),
    CELERYBEAT_SCHEDULER='django_celery_beat.schedulers:DatabaseScheduler',
    CELERY_RESULT_BACKEND='redis://:{password}@redis:6379/1'.format(password=os.environ.get('REDIS_PASSWORD')),
    CELERY_DISABLE_RATE_LIMITS=True,
    CELERY_ACCEPT_CONTENT=['json', ],
    CELERY_TASK_SERIALIZER='json',
    CELERY_RESULT_SERIALIZER='json',
)
app.conf.timezone = settings.TIME_ZONE
