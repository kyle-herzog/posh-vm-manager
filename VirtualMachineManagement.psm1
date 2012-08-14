$defaultVMSystem = 'VirtualBox'

. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "VirtualBoxMachineManagement.ps1")

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

function Control-VirtualMachine
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $vmsystem = $defaultVMSystem
  )
  & "Control-$($vmsystem)VirtualMachine"
}
Set-Alias Control-VM Control-VirtualMachine

function Get-VirtualMachine
{
  param
  (
    [Parameter(Mandatory=$false)] [string] $machineSearch = "*"
  )
  & "Get$($vmsystem)VirtualMachine" $machineSearch
}
Set-Alias Get-VM Get-VirtualMachine


