Function Get-Deb
{
param(
[string]$package
)
$deb=$null
$Buildpath=Join-Path -Path (Join-Path -Path $pwd -ChildPath $Package) -ChildPath 'build'
If (Test-path $buildpath)
{
$deb=(Get-childitem -Path ('{0}\*.deb' -f $Buildpath) -file).fullname
}
return $deb
}
$packages = @('aasdk', 'qt-gstreamer', 'openauto', 'pulseaudio', 'opendsh')
Foreach ($package in $packages) {
    $deb = Get-Deb -Package $package
    $deb
    IF ($deb) {
        $packagename = ((get-item $deb).name -split '_')[0]
        reprepro -A armhf --basedir packagerepo/apt/debian remove buster $packagename
        reprepro -A armhf --basedir packagerepo/apt/debian remove bullseye $packagename
        reprepro -A armhf --basedir packagerepo/apt/debian includedeb buster $deb
    }
}