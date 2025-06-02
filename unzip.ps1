$gzFolder = "C:\Users\kyles\Desktop\dmarc"
$logFile = Join-Path $gzFolder "gunzip_log.txt"

Write-Host "`n===== Starting extraction script =====`n"
Add-Content -Path $logFile -Value "`n===== Script started at $(Get-Date) ====="

# Get both .gz and .zip files
$files = Get-ChildItem -Path "$gzFolder\*" -Include *.gz, *.zip -File


if ($files.Count -eq 0) {
    Write-Host "No .gz or .zip files found in $gzFolder"
    Add-Content -Path $logFile -Value "No .gz or .zip files found in $gzFolder"
}
else {
    foreach ($file in $files) {
        $filePath = $file.FullName
        $extension = $file.Extension.ToLower()

        if ($extension -eq ".gz") {
            # --- Handle GZ Files ---
            $outPath = [System.IO.Path]::ChangeExtension($filePath, $null)

            Write-Host "Extracting GZ: $filePath"
            Add-Content -Path $logFile -Value "Extracting GZ: $filePath"

            try {
                $sourceStream = [System.IO.File]::OpenRead($filePath)
                $targetStream = [System.IO.File]::Create($outPath)
                $gzipStream = New-Object System.IO.Compression.GzipStream($sourceStream, [System.IO.Compression.CompressionMode]::Decompress)
                $gzipStream.CopyTo($targetStream)

                $gzipStream.Close()
                $targetStream.Close()
                $sourceStream.Close()

                Write-Host "Extracted to: $outPath"
                Add-Content -Path $logFile -Value "Extracted to: $outPath"

                Remove-Item -Path $filePath -Force
                Write-Host "Deleted: $filePath"
                Add-Content -Path $logFile -Value "Deleted: $filePath"
            }
            catch {
                Write-Host "Error with `${filePath}`:`n$($_.Exception.Message)" -ForegroundColor Red
                Add-Content -Path $logFile -Value "Error with `${filePath}`:`n$($_.Exception.Message)"
            }
        }
        elseif ($extension -eq ".zip") {
            # --- Handle ZIP Files ---
            $outDir = [System.IO.Path]::Combine($file.DirectoryName, $file.BaseName)

            Write-Host "Extracting ZIP: $filePath"
            Add-Content -Path $logFile -Value "Extracting ZIP: $filePath"

            try {
                Expand-Archive -LiteralPath $filePath -DestinationPath $outDir -Force

                Write-Host "Extracted to: $outDir"
                Add-Content -Path $logFile -Value "Extracted to: $outDir"

                Remove-Item -Path $filePath -Force
                Write-Host "Deleted: $filePath"
                Add-Content -Path $logFile -Value "Deleted: $filePath"
            }
            catch {
                Write-Host "Error with `${filePath}`:`n$($_.Exception.Message)" -ForegroundColor Red
                Add-Content -Path $logFile -Value "Error with `${filePath}`:`n$($_.Exception.Message)"
            }
        }
    }
}

Write-Host "`n===== Script finished at $(Get-Date) =====`n"
Add-Content -Path $logFile -Value "`n===== Script finished at $(Get-Date) ====="
Write-Host "`n===== we are done here little buddy =============="
