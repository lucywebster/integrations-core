:: Install with TCP/IP enabled, see: https://chocolatey.org/packages/sql-server-2017

set sleep_time=5
set n_retries=5

for /l %%x in (1, 1, %n_retries%) do (
  choco install sql-server-2017 --params="'/TCPENABLED:1'"
  if not ERRORLEVEL 1 EXIT /B 0
  echo "Wait %sleep_time% seconds and retry sql-server install ..."
  timeout /t %sleep_time% /nobreak > nul
)

:: Set password
sqlcmd -Q "ALTER LOGIN sa with PASSWORD = 'Password12!';ALTER LOGIN sa ENABLE;"

:: Enable port
powershell -Command "stop-service MSSQLSERVER"
powershell -Command "set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.MSSQLSERVER\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpdynamicports -value ''"
powershell -Command "set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.MSSQLSERVER\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpport -value 1433"
powershell -Command "set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.MSSQLSERVER\mssqlserver\' -name LoginMode -value 2"
powershell -Command "start-service MSSQLSERVER"
