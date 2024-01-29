#https://blog.admindroid.com/auto-assign-licenses-with-group-based-licensing-in-microsoft-365/

$groups=get-msolgroup -All
Write-host "Total number of Groups created are $($groups.count)"
$sku=Get-AzureADSubscribedSku
$gpinfo =$groups|?{$_.AssignedLicenses -ne $null}
foreach($Gp in $gpinfo)
{
 Write-host "Working on Group $($Gp.displayname)"
 $Licenses=Get-MsolGroup -ObjectId $Gp.Objectid |select -ExpandProperty AssignedLicenses
 

foreach($Lic in $Licenses)
{

   $Info=$lic | select -ExpandProperty AccountSkuId
   $LicNo=($sku|?{$_.SkuPartNumber -eq $info.SkuPartNumber}).ObjectId.split("_")[1]
   $sku|?{$_.SkuPartNumber -eq $info.SkuPartNumber}
   
  



   $licensesName=$Info.AccountName + ":" + $Info.SkuPartNumber
   Write-host "Working on Licenses $licensesName" -ForegroundColor Green
 
   $plans=$lic | select -ExpandProperty disabledserviceplans
   if($plans.count -gt 0)
   {
     foreach($plan in $Plans)
     {
      $obj=new-object psobject 
      $obj |add-member -NotePropertyname GroupDisplayname -NotePropertyValue $($Gp.displayname)
      $obj |add-member -NotePropertyname LicensesName -NotePropertyValue $licensesName
      $obj |Add-member -NotePropertyName LicensesID   -NotePropertyValue $LicNo                  
      $obj |add-member -NotePropertyname DisabledPlans -NotePropertyValue $Plan
      $obj |Export-csv LicensesReport.csv -Append -nti
      

     }
   
   }
   else
   {  
      $obj=new-object psobject 
      $obj |add-member -NotePropertyname GroupDisplayname -NotePropertyValue $($Gp.displayname)
      $obj |add-member -NotePropertyname LicensesName -NotePropertyValue $licensesName
      $obj |Add-member -NotePropertyName LicensesID   -NotePropertyValue $LicNo                  
      $obj |add-member -NotePropertyname DisabledPlans -NotePropertyValue ""
      $obj |Export-csv LicensesReport.csv -Append -nti
      
   }
}
}
