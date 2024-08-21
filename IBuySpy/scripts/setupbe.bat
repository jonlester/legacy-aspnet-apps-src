REM Usage: Domain name, iis_machine_name, scripts_directory

sc config sqlbrowser start= auto
sc start sqlbrowser

set SQLExpressPath=%PROGRAMFILES%\microsoft sql server\MSSQL10.SQLEXPRESS

if exist %SQLExpressPath% (
echo SQL Express present
netsh firewall add allowedprogram program="%PROGRAMFILES%\microsoft sql server\MSSQL10.SQLEXPRESS\MSSQL\Binn\sqlservr.exe" mode=ENABLE name="SQLServer" scope=ALL
goto NEXT
)



echo Assuming SQL Complete Install is present
netsh firewall add allowedprogram program="%PROGRAMFILES%\microsoft sql server\MSSQL10.MSSQLSERVER\MSSQL\Binn\sqlservr.exe" mode=ENABLE name="SQLServer" scope=ALL

:NEXT


"%PROGRAMFILES%\microsoft sql server\100\tools\binn\sqlcmd.exe" -S .\SQLEXPRESS -v DOMAIN_NAME=%1 -v MACHINE_NAME=%2 -i "%3\SetupBE.sql" 
"%PROGRAMFILES%\microsoft sql server\100\tools\binn\sqlcmd.exe" -S .\SQLEXPRESS -i "%3\StoreDB.sql"
