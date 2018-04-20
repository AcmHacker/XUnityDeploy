@echo off
REM 
REM Copyright 2015-2016 Bugly, Tencent Inc. All rights reserved.
REM 
REM Usage:
REM     buglySymboliOS.bat <so_path> [out.zip]
REM 
REM Extract symbols from so file.
REM It call 'buglySymboliOS.jar', so make sure there is Java environment on the system.
REM 
REM 

goto main

:printIndroduction
echo Bugly���ű���iOS�� -- Bugly Symtab Tool for iOS
echo ����ƽ̨ -- Applicable platform: Windows
echo Copyright 2015-2016 Bugly, Tencent Inc. All rights reserved.
echo.
goto :EOF

:printUsage
echo ----
echo %1
echo ----
echo �÷� -- Usage: buglySymboliOS.bat ^<so_path^> [out.zip]
echo.
echo ����˵�� -- Introduction for arguments
echo ^<so_path^>��
echo 	SO�ļ�·���� -- Path where so file exist
echo.
echo [out.zip] (��ѡ -- Optional)��
echo 	����ļ��� -- Zip file name for output
echo 	���[out.zip]���Ǿ���·������[out.zip]�������ڽű�����Ŀ¼
echo 	-- If it's not a absolute path, the [out.zip] will be generated into the directory of the script.
goto :EOF

:extractSymbol
java -Xms512m -Xmx1024m -jar %jarPath% %*
goto :EOF

:main
call :printIndroduction

REM Check Java environment
java -version >nul 2>&1
if not %errorlevel%==0 (
	echo ----
	echo ϵͳ��δ��װJava����δ����Java���������飡-- Please check if your system has installed Java or configured environment for Java!
	echo Java���� -- Java Web Site��www.java.com
	goto end
)

set pathName=%~dp0
set jarName=buglySymboliOS.jar
set jarPath="%pathName%%jarName%"

REM Check the jar
if not exist %JarPath% (
	echo ----
	echo δ�ҵ���%JarName%����-- Can not find %JarName%
	echo �뽫��%JarName%�����Ƶ���%pathName%���У�
	echo -- Please copy %JarName% to %pathName%!
	goto end
)

call :extractSymbol %*

:end
pause
exit /B