Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\ADM_Pstreif1> Test-NetConnection -ComputerName QTTNWLERC00036 -port 50601 -InformationLevel "Detailed"
WARNING: TCP connect to (10.137.183.133 : 50601) failed


ComputerName            : QTTNWLERC00036
RemoteAddress           : 10.137.183.133
RemotePort              : 50601
NameResolutionResults   : 10.137.183.133
MatchingIPsecRules      :
NetworkIsolationContext : Private Network
InterfaceAlias          : Ethernet0 2
SourceAddress           : 10.156.125.136
NetRoute (NextHop)      : 10.156.125.129
PingSucceeded           : True
PingReplyDetails (RTT)  : 45 ms
TcpTestSucceeded        : False