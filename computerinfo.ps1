$Strings = [string[]](Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Kylebrody/Powershell-automation/main/infofilter.txt").Content -split "`n"
$Strings = $Strings | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
$Strings
$computerInfo = Get-ComputerInfo

$outputLines = New-Object System.Collections.Generic.List[System.String]

foreach ($property in $Strings) {
	$property = $property.Trim()  
	if ($computerInfo.PSObject.Properties[$property]) {
		$value = $computerInfo.PSObject.Properties[$property].Value
		$outputLines.Add("$property : $value")
	} else {
		$outputLines.Add("$property : Property not found")
	}
}

$outputLines

$outputLines | Set-Content -Path "winfo.txt" -Force

Invoke-Item "winfo.txt"
#fin
