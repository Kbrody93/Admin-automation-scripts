Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()
$textPath = $PSScriptRoot

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(650,300)
$form.StartPosition = 'CenterScreen'

$netLabel = New-Object System.Windows.Forms.Label
$netLabel.Size = New-Object System.Drawing.Size(300,23)
$netLabel.Location = New-Object System.Drawing.Point(0.5,2)
$netLabel.Text = 'Quick Net Commands'
$form.Controls.Add($netLabel)

$iconf = New-Object System.Windows.Forms.Button
$iconf.Size = New-Object System.Drawing.Size(300,23)
$iconf.Location = New-Object System.Drawing.Point(0.5,25)
$iconf.Text = 'IP Config'
$form.Controls.Add($iconf)

$iconfAll = New-Object System.Windows.Forms.Button
$iconfAll.Location = New-Object System.Drawing.Point(0.5,50)
$iconfAll.Size = New-Object System.Drawing.Size(300,23)
$iconfAll.Text = 'IP Config All'
$form.Controls.Add($iconfAll)

$loopBack = New-Object System.Windows.Forms.Button
$loopBack.Location = New-Object System.Drawing.Point(0.5,75)
$loopBack.Size = New-Object System.Drawing.Size(300,23)
$loopBack.Text = 'Ping Loopback'
$form.Controls.Add($loopBack)

$pingOut = New-Object System.Windows.Forms.Button
$pingOut.Location = New-Object System.Drawing.Point(0.5,100)
$pingOut.Size = New-Object System.Drawing.Size(300,23)
$pingOut.Text = 'Ping https://google.com'
$form.Controls.Add($pingOut)

$pingGdns = New-Object System.Windows.Forms.Button
$pingGdns.Location = New-Object System.Drawing.Point(0.5,125)
$pingGdns.Size = New-Object System.Drawing.Size(300,23)
$pingGdns.Text = 'Ping Google DNS'
$form.Controls.Add($pingGdns)

$pingCFdns = New-Object System.Windows.Forms.Button
$pingCFdns.Location = New-Object System.Drawing.Point(0.5,150)
$pingCFdns.Size = New-Object System.Drawing.Size(300,23)
$pingCFdns.Text = 'Ping CloudFlare DNS'
$form.Controls.Add($pingCFdns)

$dns = New-Object System.Windows.Forms.Button
$dns.Location = New-Object System.Drawing.Point(0.5,175)
$dns.Size = New-Object System.Drawing.Size(300,23)
$dns.Text = 'Check client DNS address'
$form.Controls.Add($dns)

$browsSysutils = New-Object System.Windows.Forms.Label
$browsSysutils.Location = New-Object System.Drawing.Point(334,2)
$browsSysutils.size = New-Object System.Drawing.Size(300,23)
$browsSysutils.Text = "Browser Quick Commands"
$form.Controls.Add($browsSysutils)

$clearChrome = New-Object System.Windows.Forms.Button
$clearChrome.Location = New-Object System.Drawing.Point(334,25)
$clearChrome.Size = New-Object System.Drawing.Size(300,23)
$clearChrome.Text = 'Close/Clear Chrome Cache'
$form.Controls.Add($clearChrome)

$clearEdge = New-Object System.Windows.Forms.Button
$clearEdge.Location = New-Object System.Drawing.Point(334,50)
$clearEdge.Size = New-Object System.Drawing.Size(300,23)
$clearEdge.Text = 'Close/Clear Edge Cache'
$form.Controls.Add($clearEdge)

$sysutils = New-Object System.Windows.Forms.Label
$sysutils.Location = New-Object System.Drawing.Point(334,75)
$sysutils.size = New-Object System.Drawing.Size(300,23)
$sysutils.Text = "System Quick Commands"
$form.Controls.Add($sysutils)

$osInfo = New-Object System.Windows.Forms.Button
$osInfo.Location = New-Object System.Drawing.Point(334,100)
$osInfo.Size = New-Object System.Drawing.Size(300,23)
$osInfo.Text = 'System Info'
$form.Controls.Add($osInfo)

$iconSweep = New-Object System.Windows.Forms.Button
$iconSweep.Location = New-Object System.Drawing.Point(334,125)
$iconSweep.Size = New-Object System.Drawing.Size(300,23)
$iconSweep.Text = 'Remove all desktop shortcuts'
$form.Controls.Add($iconSweep)

$iconf.Add_Click(

    {
        ipconfig.exe | out-file -append smallIPconfig.txt
        Invoke-Item smallIPconfig.txt

    }

)

$iconfAll.Add_Click(

    {
        ipconfig.exe /all |out-file -append FullIPConfig.txt
        Invoke-Item FullIPConfig.txt
    }

)

$loopBack.Add_Click(

    {
        Test-Connection 127.0.0.1 | Select IPV4Address, ResponseTime, @{N="Date";E={Get-Date}} | 
        format-Table -autosize | out-file -append testLoopback.txt
        Invoke-Item testLoopback.txt
    }

)

$pingOut.Add_click(
    {
        Test-Connection www.google.com | Select IPV4Address, ResponseTime, @{N="Date";E={Get-Date}} | 
        format-Table -autosize | out-file -append testgoogle.txt
        Invoke-Item testgoogle.txt
    }    
)

$pingGdns.Add_click(
    {
        Test-Connection 8.8.8.8 | Select IPV4Address, ResponseTime, @{N="Date";E={Get-Date}} | 
        format-Table -autosize | out-file -append testgoogledns.txt
        Invoke-Item testgoogledns.txt
    }    
)

$pingCFdns.Add_click(
    {
        Test-Connection 1.1.1.1 | Select IPV4Address, ResponseTime, @{N="Date";E={Get-Date}} | 
        format-Table -autosize | out-file -append testcloudflaredns.txt
        Invoke-Item testcloudflaredns.txt
    }    
)


$dns.Add_click(
    {
        $hostname = hostname.exe
        $clientDNS = Resolve-DnsName -Name $hostname | format-Table -autosize | out-file -append dnsquerry.txt
        Invoke-Item dnsquerry.txt
    }    
)

$clearChrome.Add_click(
    {
        $p = Get-Process -Name "chrome"
        $cArray = @(get-childitem "$env:localappdata\Google\Chrome\User Data\profile***" -Name)
        Stop-Process -InputObject $p

        for ($i = 0; $i -lt $cArray.Count; $i++){
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\Cache\Cache_Data" -Recurse -Force -EA SilentlyContinue -Verbose
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\DawnCache" -Recurse -Force -EA SilentlyContinue -Verbose
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\DawnGraphiteCache" -Recurse -Force -EA SilentlyContinue -Verbose
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\DawnWebGPUCache" -Recurse -Force -EA SilentlyContinue -Verbose 
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\Code Cache" -Recurse -Force -EA SilentlyContinue -Verbose
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\GPUCache" -Recurse -Force -EA SilentlyContinue -Verbose   
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\History" -Recurse -Force -EA SilentlyContinue -Verbose 
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\History-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\InterestGroups" -Recurse -Force -EA SilentlyContinue -Verbose  
            Remove-Item -path "$env:localappdata\Google\Chrome\User Data\$($cArray[$i])\Network Action Predictor" -Recurse -Force -EA SilentlyContinue -Verbose                                                         
        }
        
        Remove-Item -Path "$env:localappdata\Google\Chrome\User Data\Default\Cache" -Recurse -Force -EA SilentlyContinue -Verbose
    }
)

$clearEdge.Add_click(
    {   
        $p = Get-Process -Name "msedge"
        Stop-Process -InputObject $p
        Stop-Process 
        Remove-Item -Path "$env:localappdata\Microsoft\Edge\User Data\Default\Cache\Cache_Data" -Recurse -Force -EA SilentlyContinue -Verbose
    }
        
)
$osInfo.Add_click(
    {   
        & .\sysparams.ps1
    }     
)

$iconSweep.Add_click(
    {
        $desktop = [System.Environment]::GetFolderPath('Desktop')
        $desktopFiles = Get-ChildItem -Path $desktop -Recurse -Include *.lnk
        foreach ($file in $desktopFiles){
            Remove-Item -Path $file.FullName -Force -Verbose
        }
    }
)

$form.Topmost = $true

$form.Add_Shown({$form.Activate()})

$form.ShowDialog()
