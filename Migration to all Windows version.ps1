# FORCAGE DU MODE UTF-8 POUR CONSOLE (OPTIONNEL SI NON NECESSAIRE)
chcp 65001 > $null

# ENTETE DU SCRIPT
Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "MIGRATION D'EDITION DE WINDOWS 11" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "CE SCRIPT PERMET DE PASSER D'UNE EDITION A UNE AUTRE" -ForegroundColor Yellow
Write-Host "EXEMPLES : FAMILLE -> PRO / FAMILLE -> EDUCATION N / PRO -> PRO N" -ForegroundColor Yellow
Write-Host ""
Write-Host "ATTENTION : POUR CONSERVER VOS DONNEES, VOUS DEVEZ UTILISER UN ISO MULTI-EDITION" -ForegroundColor Red
Write-Host ""

# INSTRUCTIONS POUR TELECHARGER L'ISO
Write-Host "==================================================" -ForegroundColor DarkCyan
Write-Host "AVANT DE CONTINUER, TELECHARGEZ L'IMAGE DISQUE WINDOWS 11" -ForegroundColor DarkCyan
Write-Host "==================================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "1 - Rendez-vous sur : https://www.microsoft.com/software-download/windows11" -ForegroundColor Gray
Write-Host "2 - Descendez jusqu'à 'Télécharger l'image disque (ISO) Windows 11'" -ForegroundColor Gray
Write-Host "3 - Choisissez : 'Windows 11 (multi-edition ISO) pour les appareils x64'" -ForegroundColor Gray
Write-Host "4 - Sélectionnez la langue souhaitée" -ForegroundColor Gray
Write-Host "5 - Cliquez sur 'Télécharger' et enregistrez le fichier ISO" -ForegroundColor Gray
Write-Host ""
Write-Host "ENTREZ LE CHEMIN COMPLET VERS L'ISO WINDOWS 11 (exemple : C:\ISOS\WIN11.iso)" -ForegroundColor Green
Pause

# MENU DES EDITIONS
Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "CHOISISSEZ L'EDITION CIBLE POUR LA MIGRATION" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1 - Windows 11 Famille"
Write-Host "2 - Windows 11 Pro"
Write-Host "3 - Windows 11 Education"
Write-Host "4 - Windows 11 Famille N"
Write-Host "5 - Windows 11 Pro N"
Write-Host "6 - Windows 11 Education N"
Write-Host ""

$choix = Read-Host "ENTREZ LE NUMERO CORRESPONDANT A L'EDITION"

switch ($choix) {
    "1" {
        $EditionID = "Core"
        $ProductName = "Windows 11 Home"
    }
    "2" {
        $EditionID = "Professional"
        $ProductName = "Windows 11 Pro"
    }
    "3" {
        $EditionID = "Education"
        $ProductName = "Windows 11 Education"
    }
    "4" {
        $EditionID = "CoreN"
        $ProductName = "Windows 11 Home N"
    }
    "5" {
        $EditionID = "ProfessionalN"
        $ProductName = "Windows 11 Pro N"
    }
    "6" {
        $EditionID = "EducationN"
        $ProductName = "Windows 11 Education N"
    }
    Default {
        Write-Host "CHOIX INVALIDE. SCRIPT ANNULE." -ForegroundColor Red
        exit
    }
}

# CONFIRMATION
Write-Host ""
Write-Host "EDITION SELECTIONNEE : $ProductName" -ForegroundColor Green
Write-Host "LE REGISTRE VA ETRE MODIFIE POUR PERMETTRE LA MISE A NIVEAU." -ForegroundColor Yellow
Pause

# MODIFICATION DU REGISTRE
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "EditionID" -Value $EditionID
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "ProductName" -Value $ProductName
Write-Host "REGISTRE MODIFIE AVEC SUCCES." -ForegroundColor Green

# DEMANDE DU CHEMIN VERS L'ISO
Write-Host ""
Write-Host "ENTREZ LE CHEMIN COMPLET VERS L'ISO WINDOWS (ex: C:\ISOS\WIN11.iso)" -ForegroundColor Green
$isoPath = Read-Host

# MONTAGE DE L'ISO
Mount-DiskImage -ImagePath $isoPath
Start-Sleep -Seconds 2

# DETECTION DE LA LETTRE DU LECTEUR ISO
$disk = Get-Volume | Where-Object { $_.FileSystemLabel -like "*CCCOMA*" -or $_.DriveType -eq "CD-ROM" }
if ($disk -eq $null) {
    Write-Host "LECTEUR ISO NON DETECTE. ASSUREZ-VOUS QUE L'ISO EST MONTE." -ForegroundColor Red
    exit
}

# EXECUTION DE L'INSTALLATEUR
$setupPath = "$($disk.DriveLetter):\setup.exe"
Write-Host "LANCEMENT DE L'INSTALLATEUR WINDOWS..." -ForegroundColor Yellow
Start-Process -FilePath $setupPath

# MESSAGE FINAL
Write-Host ""
Write-Host "MIGRATION DEMARREE ! N'OUBLIEZ PAS D'ENTRER VOTRE CLE D'ACTIVATION A LA FIN DE L'INSTALLATION." -ForegroundColor Green
