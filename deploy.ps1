Function Get-Deb
{
param(
[string]$package
)
$Buildpath=Join-Path -Path (Join-Path -Path $pwd -ChildPath $Package) -ChildPath 'build'
If (Test-path $buildpath)
{
$deb=(Get-childitem -Path ('{0}\*.deb' -f $Buildpath) -file).fullname
}
return $deb
}
$packages = @('aasdk', 'qt-gstreamer', 'openauto', 'pulseaudio', 'dash')
Foreach ($package in $packages) {
    $deb = Get-Deb -Package $package
    IF ($deb) {
        $packagename = ((get-item $deb).name -split '_')[0]
        reprepro --basedir packagerepo/debian remove buster $packagename
        reprepro --basedir packagerepo/debian remove bullseye $packagename
        reprepro --basedir packagerepo/debian includedeb buster $deb
    }
}