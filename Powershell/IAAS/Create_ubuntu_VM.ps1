$resourceGroup = "vs_iaas"
$location = "eastus2"

New-AzureRmResourceGroup -Name $resourceGroup -Location $location

#storage account

$storageAccountName = "vsiaas"
New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup -Type Standard_LRS -Location $location

#create vnet

$vnetName = "vs-iaasnet"
$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix 10.0.1.0/24
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup

#LinuxServer

$nic2Name = "vm2-nic"
$pip2 = New-AzureRmPublicIpAddress -Name $nic2Name -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic
$nic2 = New-AzureRmNetworkInterface -Name $nic2Name -ResourceGroupName $resourceGroup -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip2.Id


#Create the VM

$vm2Name = "ub-proxy"
$vm2 = New-AzureRmVMConfig -VMName $vm2Name -VMSize "Basic_A1"

#Get the images
Get-AzureRmVMImageOffer -Location $location -PublisherName 'Canonical'
Get-AzureRmVMImageSku -Location $location -PublisherName 'Canonical'

$cred2 = Get-Credential -Message "admin credentials"
$vm2=Set-AzureRmVMOperatingSystem -VM $vm2 -Linux -ComputerName $vm2Name -Credential $cred2
$vm2 = Set-AzureRmVMSourceImage -VM $vm2 -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest"

$vm2 = Add-AzureRmVMNetworkInterface -VM $vm2 -id $nic2.Id
$disk2Name = "ub-os-disk"
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$osDisk2URI=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $disk2Name + ".vhd"
$vm2 = Set-AzureRmVMOSDisk -VM $vm2 -Name $disk2Name -VhdUri $osDisk2URI -CreateOption FromImage

New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vm2

#Get the public IP address that azure has dynamically assigned
Get-AzureRmVM -ResourceGroupName $resourceGroup -name $vm2Name
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -name $nic2Name

#Stop the azure VM
Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $vm2Name