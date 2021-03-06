param
(
  [Parameter(Mandatory = $true, HelpMessage = "Resource group name to remove deployments from")]
  [string] $ResourceGroupName,

  [Parameter(Mandatory = $false, HelpMessage = "Negative number (how many days ago to start removal")]
  [int] $HowManyDaysBefore = -0
)

Write-Host "Start removal ..."

$deployments = Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName
Write-Host "Deployments: $($deployments.Count)"

$deploymentsToDelete = $deployments | where { $_.Timestamp -lt ((get-date).AddDays($HowManyDaysBefore)) }

foreach ($deployment in $deploymentsToDelete) {
        $deploymentName = $deployment.DeploymentName
        Write-Host "Removing deployment $deploymentName"
        Remove-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -DeploymentName $deploymentName
}

Write-Host "All done!"

