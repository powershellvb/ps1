﻿<#
 \\192.168.112.129\c$\PerfLogs\TSQL005Trigger.ps1 # 129=61Node

#>


   

$pTServerInstance='PMD2016' 

 . C:\PerfLogs\TSQL005.ps1  $pTServerInstance $pGServerInstance $pTdatabase $pGdatabase $ptsec


function waitrun ([string]$th,[string] $tm){
 #$th='14' ;$tm='10'
}