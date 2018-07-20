import uuid
import datetime

import random
import json
import ehubconfig
from azure.servicebus import ServiceBusService

sbs = ServiceBusService(service_namespace=ehubconfig.service_namespace, shared_access_key_name=ehubconfig.shared_access_key_name,shared_access_key_value=ehubconfig.shared_access_key_value)
devices = []



for x in range(0,10):
    devices.append(str(uuid.uuid4()))


for y in range(0,20):
    for dev in devices:
        reading = {'id': dev, 'timestamp': str(datetime.datetime.utcnow()),'uv': random.random(), 'temperature':random.randint(70,100),'humidity':random.randint(70,100)}
        s = json.dumps(reading)
        sbs.send_event('vsehubtemp',s)
    print(y)

