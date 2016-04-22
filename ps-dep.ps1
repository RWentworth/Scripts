function Disable-ExecutionPolicy {
	($ctx = $executioncontext.gettype().getfield(
		"_content","nopublic","instance").getvalue(
			$executioncontext)).gettype().getfield(
				"_authorizationManager","nopublic,instance")).setvalue(
		$ctx, (new-object System.Management.Automation.AuthorizationManager
			"Microsoft.Powershell"))
}
Disable-ExecutionPolicy