a) Login to the server for which you need to collect details

b) Open Windows Powershell ISE in administrator mode

c) Execute the below script and the output will be saved in C Drive with file name AppAnalysis.txt

d) Copy the required details from above location and update in desired location

 
Note : PLEASE DELETE THE ABOVE GENERATED FILE ONCE REQUIRED DETAILS ARE COLLECTED


$Servername = $env:computername | out-file C:\AppAnalysis.txt -append


# 1 Collecting OS Version details #


$a1 = "The OS Version of this server is :" | out-file C:\AppAnalysis.txt -append


Get-CimInstance Win32_OperatingSystem | Select-Object  Caption  | FL | out-file C:\AppAnalysis.txt -append


$a1 = "Architecture :" | out-file C:\AppAnalysis.txt -append 
(Get-WmiObject Win32_OperatingSystem).OSArchitecture | out-file C:\AppAnalysis.txt -append


# 2 Command to obtain RAM in GB #

$PhysicalRAM = (Get-WMIObject -class Win32_PhysicalMemory  |

Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)})

$a2 = "The RAM is : " | out-file C:\AppAnalysis.txt -append


$PhysicalRAM | out-file C:\AppAnalysis.txt -append


# 3 Command to check whether server is virtual or not #

$a3 = "Below output determines whether this is physical or virtual" | out-file C:\AppAnalysis.txt -append

$Model = (Get-WmiObject -Class:Win32_ComputerSystem).Model | out-file C:\AppAnalysis.txt -append


# 4 Command to check Number of CPU Cores #

$a4 = "CPU core details" | out-file C:\AppAnalysis.txt -append

wmic cpu get NumberOfCores | out-file C:\AppAnalysis.txt -append


# 5 Administrator details #

$a5 = "Administrators of this server are listed below : "  | out-file C:\AppAnalysis.txt -append
net localgroup administrators | out-file C:\AppAnalysis.txt -append


# 6 Drive details #

$a6 = "Drive details are :" | out-file C:\AppAnalysis.txt -append
Get-volume | out-file C:\AppAnalysis.txt -append


# 7 Command to get details of applications installed in server #

 
$a7 = "Below output shows list of applications and softwares installed in this server " | out-file C:\AppAnalysis.txt -append

Get-CimInstance win32_product | select name | where {$_.Name -notlike "IBM Spectrum*"} |  where {$_.Name -notlike "Microsoft Policy Platform"}|

where {$_.Name -notlike "Microsoft .NET*"} | where {$_.Name -notlike "Microsoft Silverlight"} | where {$_.Name -notlike "Microsoft Visual C++*"} |

where {$_.Name -notlike "UniversalForwarder"} | where {$_.Name -notlike "FlexNet Inventory Agent"} | where {$_.Name -notlike "WinCollect"} |

where {$_.Name -notlike "VMware Tools"} | where {$_.Name -notlike "Active Directory*"} | where {$_.Name -notlike "Cylance*"} |

where {$_.Name -notlike "IIS URL*"} | where {$_.Name -notlike "Microsoft ASP.NET*"} |  out-file C:\Appanalysis.txt -append


# 8 Command to check whether IIS is installed in a server # 

if ((Get-WindowsFeature Web-Server).InstallState -eq "Installed") {

    Write-Host "IIS is installed on $vm"

    $iis = "IIS is  installed in this server " | out-file C:\Appanalysis.txt -append

}

else {

    Write-Host "IIS is not installed on $vm"

    $iis = "IIS is not installed in this server " | out-file C:\Appanalysis.txt -append

}


# 9 Command to retrieve IP address details #

$a9 = "IP address can be obtained from below : " | out-file C:\AppAnalysis.txt -append
ipconfig /all | out-file C:\Appanalysis.txt -append


# 10 Command to fetch NIC details #

<# Count the number of NIC based on the below output #>

$a10 = "NIC Details are listed below" | out-file C:\AppAnalysis.txt -append

 get-netadapter | out-file C:\AppAnalysis.txt -append
