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

#NIC

$nicName = "vm1-nic"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id


#Create the VM

$vmName = "win-web"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Basic_A1"
$cred = Get-Credential -Message "admin credentials"
$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
$vm = Add-AzureRmVMNetworkInterface -VM $vm -id $nic.Idgit commi
$diskName = "os-disk"
$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -name $storageAccountName
$osDiskURI=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $diskName + ".vhd"
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskURI -CreateOption FromImage

New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vm

#Get the public IP address that azure has dynamically assigned
Get-AzureRmVM -ResourceGroupName $resourceGroup -name $vmName
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -name $nicName

#Stop the azure VM
Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $vmName