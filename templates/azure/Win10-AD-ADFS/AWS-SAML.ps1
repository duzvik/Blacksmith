$Name = "AWSGO"
$AwsARN = "165085906850"
$AwsProviderName = "ADFS2"
$SignatureAlgorithm = "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"

@"
@RuleTemplate = "MapClaims"
@RuleName = "NameId"
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/format"] = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent");

@RuleTemplate = "LdapClaims"
@RuleName = "RoleSessionName" 
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"] => issue(store = "Active Directory", types = ("https://aws.amazon.com/SAML/Attributes/RoleSessionName"), query = ";mail;{0}", param = c.Value);

@RuleName = "Get AD Group"
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"]=> add(store = "Active Directory", types = ("http://temp/variable"), query = ";tokenGroups;{0}", param = c.Value);

@RuleName = "Roless"
c:[Type == "http://temp/variable", Value =~ "(?i)^AWS-"]=> issue(Type = "https://aws.amazon.com/SAML/Attributes/Role", Value = RegExReplace(c.Value, "AWS-", "arn:aws:iam::${AwsARN}:saml-provider/${AwsProviderName},arn:aws:iam::${AwsARN}:role/ADFS-"));
"@ | Out-File "Issuance-Transform-Rules-ALL.txt"

Add-ADFSRelyingPartyTrust -name $Name -MetadataUrl https://signin.aws.amazon.com/static/saml-metadata.xml
Set-ADFSRelyingPartyTrust -TargetName $Name -IssuanceTransformRulesFile "Issuance-Transform-Rules-ALL.txt"
Set-ADFSRelyingPartyTrust -TargetName $Name -SignatureAlgorithm $SignatureAlgorithm
Set-AdfsRelyingPartyTrust -TargetName  $Name -AccessControlPolicyName "Permit everyone"
Remove-Item "Issuance-Transform-Rules-ALL.txt"
curl -o fedmeta.xml https://adfs.azsentinel.local/FederationMetadata/2007-06/FederationMetadata.xml

New-ADGroup -Name "AWS-Billing" -GroupScope Global -DisplayName "AWS-Billing"
$AccountPassword = "cJa,/#w8~?"
New-ADUser -Name Tom  -DisplayName Tom  -UserPrincipalName 'tom@azsentinel.local' -OtherAttributes @{'mail'="tom@azsentinel.local"} -AccountPassword  (ConvertTo-SecureString -AsPlainText $AccountPassword -Force)  -CannotChangePassword $True  -PasswordNeverExpires $true ` -Enabled $True
Add-ADGroupMember "AWS-Billing" -Members 'tom'
