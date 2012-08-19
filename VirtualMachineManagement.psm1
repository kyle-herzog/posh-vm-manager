$defaultVMSystem = 'VirtualBox'

function Get-CurrentScriptPath
{
  Split-Path $myInvocation.ScriptName
}

function Get-CurrentScriptName
{
  (Get-Item ($myInvocation.ScriptName)).BaseName
}

function Get-VirtalMachineManagementSystems
{
  Get-Item "*$(Get-CurrentScriptName).ps1"
}

function Set-VirtualMachineSystem
{
  param
  (
    [Parameter(Mandatory=$true)] [string] $vmsystem
  )
  $defaultVMSystem = $vmsystem
}
Set-Alias Start-VMSystem Start-VirtualMachineSystem

function Start-VirtualMachine
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $vmsystem = $defaultVMSystem
  )
  & "Start-$($vmsystem)VirtualMachine"
}
Set-Alias Start-VM Start-VirtualMachine

function Shutdown-VirtualMachine
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $vmsystem = $defaultVMSystem
  )
  & "Shutdown-$($vmsystem)VirtualMachine"
}
Set-Alias Shutdown-VM Shutdown-VirtualMachine

function Send-VirtualMachineCommand
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $vmsystem = $defaultVMSystem
  )
  & "Send-$($vmsystem)VirtualMachineCommand"
}
Set-Alias Send-VMCommand Sned-VirtualMachineCommand

function Get-VirtualMachine
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $machineSearch = "*"
  )
  & "Get-$($vmsystem)VirtualMachine" $machineSearch
}
Set-Alias Get-VM Get-VirtualMachine


$virtualMachineManagementSystems = Get-VirtalMachineManagementSystems
$virtualMachineManagementSystems | Foreach-Object {
  Write-Host "Loading VirtualMachineManamgentSystem - " $_.BaseName
  . $_
}
