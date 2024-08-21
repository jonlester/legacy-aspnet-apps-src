@echo off
set RemotePath=%1
set LocalPath=%SystemDrive%\IBuySpy

if not exist %RemotePath% (
echo remote path %RemotePath% doesn't exist
goto Error
)
if exist %LocalPath% (
rmdir /s /q %LocalPath%
)
mkdir %LocalPath%
xcopy /cherky %RemotePath%\Scripts\* %LocalPath%\.

:Sucess
echo IBuySpy Copied to LocalPath %LocalPath%
exit /b 0
:Error
echo Unable to Copy IBuySpy Scripts
exit /b 1
