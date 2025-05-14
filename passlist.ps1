###################################################################################################
######### Get IT Glue API Key
###################################################################################################
If($ITG_API -eq $null){
    $ITG_API = Read-Host "Enter your API key" #Ask for the IT Glue API  Key
}
else{
    Write-Host "Using existing API:" $ITG_API
}
###################################################################################################
######### API Headers
###################################################################################################

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("x-api-key", "$ITG_API")
$headers.Add("Content-Type", "application/vnd.api+json")

###################################################################################################
######### Set API Endpoint
###################################################################################################

$OrgID = '6513082' #Enter your ORG ID

$Pass_Object_name = 'Postman-updated-password' #Enter the password name

$URLID = "https://api.itglue.com/organizations/$OrgID/relationships/passwords"


###################################################################################################
######### Fetch the passwords ID
###################################################################################################

try{

    $getid = Invoke-RestMethod $URLID -Method 'GET' -Headers $headers

}
catch{

    Write-Host $_.exception.message

}

###################################################################################################
######### Fetch the passwords Name and Value
###################################################################################################
Foreach ($password in $($getid.data)){

    $URLDetails = "https://api.itglue.com/passwords/$($password.id)"


    try{

        $getpassword = Invoke-RestMethod $URLDetails -Method 'GET' -Headers $headers

        $getpassword.data.attributes | Select-Object @{N='Name';E={$_.name}}, @{N='Password';E={$_.password}} | ? {$_.name -eq "$Pass_Object_name"}

    }
    catch{

    Write-Host $_.exception.message

    }
}

###################################################################################################
######### End
###################################################################################################
