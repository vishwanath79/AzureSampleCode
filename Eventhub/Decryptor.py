import base64
from Crypto.Cipher import AES



BLOCK_SIZE=16



def encryptor2(message, key):
    passphrase = key
    IV = "9511111111111111"
    aes = AES.new(passphrase, AES.MODE_CFB, IV)
    return base64.b64encode(IV + aes.encrypt(message))

def decryptor2(encrypted, key):
    passphrase = key
    encrypted = base64.b64decode(encrypted)
    IV = "9511111111111111"
    aes = AES.new(passphrase, AES.MODE_CFB, IV)
    return aes.decrypt(encrypted[BLOCK_SIZE:])

# Test
print(encryptor2("this is a test", "1234567891012145"))
print(decryptor2("OTUxMTExMTExMTExMTExMT2Mtg1fC4XwyEsTznxH", "1234567891012145"))


