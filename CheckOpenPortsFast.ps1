function test-port{
    param(
        [String]$computer,
        [String]$port
    ) 
	$HostIP = ( `
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
        -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress
	$tcpobject = new-Object system.Net.Sockets.TcpClient 
	#Connect to remote machine's port               
	$connect = $tcpobject.BeginConnect($computer,$port,$null,$null) 
	#Configure a timeout before quitting - time in milliseconds 
	$wait = $connect.AsyncWaitHandle.WaitOne(1000,$false) 
	If (-Not $Wait) {
			Write-output "$HOSTIP,$computer,$port,False"
	} Else {
		$error.clear()
		$tcpobject.EndConnect($connect) | out-Null 
		If ($Error[0]) {
			Write-output "$HOSTIP,$computer,$port,FalseError"
		} Else {
			Write-output "$HOSTIP,$computer,$port,True"
		}
	}
}

