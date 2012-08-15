$fileName =
@{
  powershellModulePath = "Documents\WindowsPowerShell\Modules\VirtualMachineManagement"
}

function New-Symlink {
  <#
  .SYNOPSIS
    Creates a symbolic link.
  #>
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string] $Link,
    [Parameter(Position=1, Mandatory=$true)]
    [string] $Target,
    [switch] $Force
  )

  Invoke-MKLINK @psBoundParameters -Symlink
}

function New-Hardlink {
  <#
  .SYNOPSIS
    Creates a hard link.
  #>
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string] $Link,
    [Parameter(Position=1, Mandatory=$true)]
    [string] $Target,
    [switch] $Force
  )

  Invoke-MKLINK @psBoundParameters -HardLink
}

function New-Junction {
  <#
  .SYNOPSIS
    Creates a directory junction.
  #>
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string] $Link,
    [Parameter(Position=1, Mandatory=$true)]
    [string] $Target,
    [switch] $Force
  )

  Invoke-MKLINK @psBoundParameters -Junction
}

function Invoke-MKLINK {
  <#
  .SYNOPSIS
    Creates a symbolic link, hard link, or directory junction.
  #>
  [CmdletBinding(DefaultParameterSetName = "Symlink")]
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string] $Link,
    [Parameter(Position=1, Mandatory=$true)]
    [string] $Target,

    [Parameter(ParameterSetName = "Symlink")]
    [switch] $Symlink = $true,
    [Parameter(ParameterSetName = "HardLink")]
    [switch] $HardLink,
    [Parameter(ParameterSetName = "Junction")]
    [switch] $Junction,
    [switch] $Force
  )

  # Ensure target exists.
  if (-not(Test-Path $Target)) {
    throw "Target does not exist.`nTarget: $Target"
  }

  # Ensure link does not exist.
  if (Test-Path $Link) {
    if($Force)
    {
      try
      {
        (Get-Item $Link).Delete()
      }
      catch{}
      if(Test-Path $Link)
      {
        Remove-Item $Link -Recurse -Force
      }
    }
    else
    {
      throw "A file or directory already exists at the link path.`nLink: $Link"
    }
  }

  $isDirectory = (Get-Item $Target).PSIsContainer
  $mklinkArg = ""

  if ($Symlink -and $isDirectory) {
    $mkLinkArg = "/D"
  }

  if ($Junction) {
    # Ensure we are linking a directory. (Junctions don't work for files.)
    if (-not($isDirectory)) {
      throw "The target is a file. Junctions cannot be created for files.`nTarget: $Target"
    }

    $mklinkArg = "/J"
  }

  if ($HardLink) {
    # Ensure we are linking a file. (Hard links don't work for directories.)
    if ($isDirectory) {
      throw "The target is a directory. Hard links cannot be created for directories.`nTarget: $Target"
    }

    $mkLinkArg = "/H"
  }

  # Capture the MKLINK output so we can return it properly.
  # Includes a redirect of STDERR to STDOUT so we can capture it as well.
  $output = cmd /c mklink $mkLinkArg `"$Link`" `"$Target`" 2>&1

  if ($lastExitCode -ne 0) {
    throw "MKLINK failed. Exit code: $lastExitCode`n$output"
  }
  else {
    Write-Output $output
  }
}

function Get-CurrentScriptPath
{
  Split-Path $myInvocation.ScriptName
}

function Install-VirtualMachineManagement
{
  Write-Host "Installing VirtualMachineManagement..." -NoNewLine

  $userpsmodules = Join-Path $HOME $fileName.powershellModulePath

  if(!(Test-Path $userpsmodules))
  {
    New-Item $userpsmodules -Type Directory | Out-Null
  }

  $dotFile = Get-CurrentScriptPath

  write-host $userpsmodules
  write-host $dotFile

  New-Junction $userpsmodules $dotFile -Force | Out-Null
  Write-Host "done" -ForegroundColor DarkGreen
}

try
{
  Install-VirtualMachineManagement
}
catch
{
  Write-Error ($_.Exception)
}

