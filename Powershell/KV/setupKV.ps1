$kvName = 'VSKV'
$rgName = 'VSRG'
$location = 'East US'
$secret = 'VSClientSecret'
$aadClientSecret = ConvertTo-SecureString  $secret -AsPlainText -Force
$appDisplayName = 'VSEncryptApp'

New-AzureRmResourceGroup -name $rgName -Location $location
New-AzureRmKeyVault -VaultName $kvName -ResourceGroupName $rgName -Location $location

Set-AzureRmKeyVaultAccessPolicy  -VaultName $kvName -ResourceGroupName $rgName -EnabledForDiskEncryption

# add app using powershell

#start from here
$aadApp  = New-AzureRmADApplication -DisplayName $appDisplayName -HomePage 'http://homepageplazencrypeapp' -IdentifierUris 'http://urivsencryptapp' -Password $aadClientSecret
$appID = $aadApp.ApplicationId

#Need a service principal for the application to register with the AAD
$aadServicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $appID

#this acess policy to the KV is given to the application which allows the application to do encryption and decryption
Set-AzureRmKeyVaultAccessPolicy -VaultName $kvName -ServicePrincipalName $appID -PermissionsToKeys all
