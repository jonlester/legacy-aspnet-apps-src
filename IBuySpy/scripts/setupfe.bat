cd %SYSTEMROOT%\Microsoft.NET\Framework\v4.0.20908

aspnet_regiis.exe -i

netsh firewall add allowedprogram program="%WINDIR%\system32\inetsrv\inetinfo.exe" mode=ENABLE name="IISServer" scope=ALL
netsh firewall add portopening TCP 80 IISPORT ENABLE ALL


cd %WINDIR%\system32

set STORECSVS=%1

set IISVDirPath=%WINDIR%\system32\iisvdir.vbs

if exist %IISVDirPath% (
echo IIS VDIR present - 6.0 detected
CScript %IISVDirPath% /create w3svc/1/ROOT StoreCSVS %STORECSVS%
)

if not exist %IISVDirPath% (
%WINDIR%\System32\inetsrv\appcmd add app /site.name:"Default Web Site" /path:/StoreCSVS /physicalpath:c:\StoreCSVS
)


xcopy /cherky %3\_PublishedWebsites\IBuySpy\* C:\StoreCSVS\
copy %3\IBuySpy.dll C:\StoreCSVS\bin\. /y

cd C:\IBuySpy

set HOSTNAME=%2
ReplaceText.exe %STORECSVS%\Web.Config DBSERVERURL "Data Source=%HOSTNAME%\SQLEXPRESS;Initial Catalog=Store;Integrated Security=True"
rem "%1\ReplaceText.exe" "%1\Web.Config" SERVERNAME %2
