import logging

logging.basicConfig(level=logging.INFO)
from azure.datalake.store.core import AzureDLFileSystem
from azure.datalake.store.lib import auth


adls = ""
tenant = ""
client = ""
clientsecret = ""


def azurelistfile():
    token = auth(tenant_id=tenant, client_id=client, client_secret=clientsecret)
    azureDLS = AzureDLFileSystem(store_name=adls, token=token)
    childItems = azureDLS.ls("/")
    print '\n'.join([str(item) for item in childItems])


def azurewritefile():
    token = auth(tenant_id=tenant, client_id=client, client_secret=clientsecret)
    azureDLS = AzureDLFileSystem(store_name=adls, token=token)
    with azureDLS.open('vishfile', 'wb') as f:
        f.write(b'example')


def azurereadfile(filename):
    token = auth(tenant_id=tenant, client_id=client, client_secret=clientsecret)
    azureDLS = AzureDLFileSystem(store_name=adls, token=token)
    with azureDLS.open('vishfile', blocksize=2 ** 20) as f:
        print(f.readline())


if __name__ == '__main__':
    azurelistfile()
    azurewritefile()
    azurereadfile(filename="vishfile")



