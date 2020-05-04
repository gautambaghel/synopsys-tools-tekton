@echo off
java -version > nul 2>&1
if errorlevel 1 (
	echo "Unable to find java command, Please install java version Oracle 11 (https://www.oracle.com/technetwork/java/javase/downloads/index.html) or OpenJDK 11.0.2 (https://jdk.java.net/archive/)"
	exit /b %errorlevel%
)
set result=F
for /f %%m in ('powershell -Command "&{(Get-Command java | Select-Object -ExpandProperty Version).toString().split('.')[0]}"') do (set version=%%m)

if "%version%"=="11" set result=T
if %result%==T (
	GOTO Code
) else (
	GOTO Message
)
goto Eof
:Code
if exist "Seeker_Agent.jar" (
	if exist "application.properties" (
		java -Xmx1024M -jar Seeker_Agent.jar --spring.config.additional-location=./application.properties
) else (
	echo "Unable to locate application.properties file under %cd%"
)
) else (
	echo "Unable to locate Seeker_Agent.jar file under %cd%"
)
GOTO Eof
:Message
	echo "Java version Oracle 11 or OpenJDK 11.0.2 is required to run the agent. Please check your java version..."
:Eof
PAUSE