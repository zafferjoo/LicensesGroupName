$Report=import-csv ExtendedLicensesReport.csv

$groups=$Report |Group-Object GroupDisplayName
foreach($group in $groups){
 
 $licInfo=($Report |?{$_.GroupDisplayName -eq $group.Name}).LicensesID | Group-Object 
   foreach($lic in $LicInfo)
   {
     $disab=$Report|?{$_.GroupDisplayName -eq $group.Name -and $_.LicensesID -eq $Lic.name}
     $plans=@()
        foreach($d in $disab)
           {

               #Write-host " The disabled Plans are for Group $($group.Name)  with Licenses  $($lic.name) are  $($d.DisabledPlans)" -ForegroundColor Green
               $plans+=$($d.DisabledPlansID)

           }

#========================
if($plans -match "No Disable")
{
$plans=""
}


$params = @{
	AddLicenses = @(
		@{
			DisabledPlans =$plans
			SkuId = $lic.Name
		}
		
	)
	RemoveLicenses = @(
	)
}
$y="======================="
$y
$group.Values
$params['addlicenses']
$group.Name

$y="======================="
$y


#Set-MgGroupLicense -GroupId "89a53ccd-e5d2-4eba-a290-ee09c893ef1a" -BodyParameter $params
 
   }
   
 
# $LicId=($Report |?{$_.GroupDisplayName -eq $group.Name}).LicensesID
 #    $disab=$Report|?{$_.GroupDisplayName -eq $group.Name -and $_.LicensesName -eq $Lic}


 #$licInfo
 #$disab
 #$LicId
 #$group.Name
 #$LicId
 #$Licinfo 
 
 Write-Host "*************************"


}
