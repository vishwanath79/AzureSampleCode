import adal
import requests

from Environ_watcher.Configurator import *

context = adal.AuthenticationContext(authority_uri)
token_response = context.acquire_token_with_client_credentials(resource_uri, application_id, application_secret)

access_token = token_response.get('accessToken')
print(access_token)

headers = {"Authorization": 'Bearer ' + access_token}
json_output = requests.get(endpoint, headers=headers).json()
print(json_output)
for sub in json_output["value"]:
    print(sub["displayName"] + ': ' + sub["subscriptionId"])

r = requests.get(clusterURL, headers=headers)
clusterdetails = r.json()
print(clusterdetails)

print('HERE ARE THE DETAILS \n')
print(clusterdetails['value'][0]["name"])
print(clusterdetails['value'][0]["properties"]['clusterDefinition']['kind'])
print(clusterdetails['value'][0]["properties"]['computeProfile']['roles'][0]['targetInstanceCount'])
print(clusterdetails['value'][0]["properties"]['clusterState'])
print(clusterdetails['value'][0]["properties"]['quotaInfo']['coresUsed'])
print(clusterdetails['value'][0]["properties"]['createdDate'])
print(clusterdetails['value'][0]['location'])
