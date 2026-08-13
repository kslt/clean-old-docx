$AllowedUser = "DOMAIN\USER"
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

if ($CurrentUser -ne $AllowedUser) {
    Write-Error "Behörighet saknas. Endast $AllowedUser får köra detta skript."
    Start-Sleep -Seconds 3
    exit
}

$ProtokollMapp = "I:\YOUR\FILE\PATH"

if (Test-Path $ProtokollMapp) {
    Write-Host "Välkommen till protokollrensaren, $CurrentUser!" -ForegroundColor Cyan
    Write-Host "v1.3.0" -ForegroundColor Cyan
    Write-Host "--------------------------------------------------------"
    Write-Host ""
    Write-Host "Söker efter gamla protokoll i: $ProtokollMapp" -ForegroundColor Cyan
    Write-Host "--------------------------------------------------------"
    
    $FilesToDelete = Get-ChildItem -Path "$ProtokollMapp\*.docx" | Sort-Object LastWriteTime -Descending | Select-Object -Skip 1

    if ($FilesToDelete) {

        Write-Host "Följande filer har identifierats och kan raderas:" -ForegroundColor Yellow
        $FilesToDelete | ForEach-Object { 
            Write-Host "- $($_.Name)" -ForegroundColor White
        }
        Write-Host ""

        $Svar = Read-Host "Vill du ta bort alla dessa filer? (J/N)"

        if ($Svar -eq "J" -or $Svar -eq "j") {
            Write-Host ""
            # Loopa igenom och radera om svaret var Ja
            $FilesToDelete | ForEach-Object { 
                Remove-Item $_.FullName -Force 
                Write-Host "-> Raderade: $($_.Name)" -ForegroundColor Red
            }
        } else {
            Write-Host ""
            Write-Host "-> Avbröt: Inga filer raderades." -ForegroundColor Green
        }

        Write-Host "--------------------------------------------------------"
        Write-Host "Genomgången av gamla protokoll är klar!" -ForegroundColor Cyan
    } else {
        Write-Host "Hittade inga äldre protokoll att ta bort, bara det senaste (eller inget) finns i mappen. Avbryter skriptet." -ForegroundColor Green
    }
} else {
    Write-Host "Fel: Kunde inte hitta mappen '$ProtokollMapp'." -ForegroundColor Red
    Write-Host "Kontrollera att du har skrivit in rätt sökväg högst upp i skriptet." -ForegroundColor Red
}

Write-Host ""
Read-Host "Tryck på Enter för att stänga fönstret"
