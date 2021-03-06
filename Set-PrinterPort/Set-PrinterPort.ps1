﻿#Requires -Version 3.0

function Set-PrinterPort
{
<#
.Synopsis
   Set TCP/IP to PrinterName you specified.
.DESCRIPTION
   This Cmdlet will Assign current TCP/IP Port include what you specified.
.EXAMPLE
    Set-PrinterPort -TCPIPport 192.168.1.2 -printerName "HP-hogehoge"
.EXAMPLE
    Set-PrinterPort -TCPIPport 192.168.1.2 -printerName "HP-hogehoge" -Verbose
#>

    [CmdletBinding()]
    Param
    (
        # Input TCP/IP port number you want to create, assign to Printer
        [Parameter(
            Mandatory,
            Position = 0)]
        [ipaddress]
        $TCPIPport,

        # Input Printer Name to asshign Port Number you want
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string]
        $printerName
    )

    process
    {
        if (-not(Get-PrinterPort | where Name -eq $TCPIPport))
        {
            throw ("Printer Port '{0}' not found exception!" -f $TCPIPport)
        }
        else
        {
            Write-Verbose ("Printer port '{0}' found." -f $TCPIPport)
        }

        $printers = Get-CimInstance -Class Win32_printer | where name -eq $printerName

        if ($printers.count -ne 0)
        {
            foreach ($printer in $printers)
            {
                if ($printer.PortName -ne $TCPIPport)
                {
                    Write-Verbose ("Setting Printer '{0}' port from '{1}' to '{2}'" -f $printer.Name, $printer.PortName, $TCPIPport)
                    $printer.PortName = $TCPIPport
                }
                else
                {
                    Write-Verbose ("Printer '{0}' port '{1}' was already '{2}'" -f $printer.Name, $printer.PortName, $TCPIPport)
                }
            }
        }
        else
        {
            throw ("Printer name '{0}' not exist exception!" -f $printerName)
        }
    }
}