$defaultVMSystem = 'VirtualBox'

. (Join-Path (Split-Path $MyInvocation.MyCommand.Path) "VirtualBoxMachineManagement.ps1")

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
