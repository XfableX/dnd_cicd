# Remove existing directories if they exist
if (Test-Path -Path "dnd_flutter") {
    Remove-Item -Recurse -Force "dnd_flutter"
}

if (Test-Path -Path "dnd_java") {
    Remove-Item -Recurse -Force "dnd_java"
}

# Clone repositories
git clone https://github.com/XfableX/dnd_flutter.git
git clone https://github.com/XfableX/dnd_java.git

# Set full permissions (equivalent to chmod 777)
$acl = Get-Acl "dnd_flutter"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
Set-Acl "dnd_flutter" $acl

$acl = Get-Acl "dnd_java"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($rule)
Set-Acl "dnd_java" $acl

# Build Java project
Set-Location "dnd_java"
.\gradlew.bat build
Set-Location ..

# Build Flutter web app
Set-Location "dnd_flutter"

# Get IP address (PowerShell equivalent)
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected" }).IPv4Address.IPAddress

# Run Flutter web build
docker run --rm -it -v ${PWD}:/dnd_flutter --workdir /dnd_flutter ghcr.io/cirruslabs/flutter:stable flutter build web --dart-define=WEBHOST=$IP

Set-Location ..

# Output and run Docker Compose
Write-Host "Running on http://$IP:80"
docker compose up