[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$rgName,    
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$vmName
)


## Run the tests
describe 'Check VM size' {
    it 'The VM size is Standard B1s' {
        $hw = (Get-AzVM -ResourceGroupName $rgName -Name $vmName).HardwareProfile
        $hw.VmSize | Should Be "Standard_B1s"
    }
}