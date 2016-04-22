$objSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-21-2639968619-2551131868-2516129401-129371")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value