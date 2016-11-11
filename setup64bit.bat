@echo off

:Win8
cls
echo Are your running Windows 8?
echo.
SET /P ANSWER= If you're runnning Windows 8 then select yes, otherwise No (Y/N)? 
echo Select: %ANSWER% 
if /i {%ANSWER%}=={y} (goto :w8yes) 
if /i {%ANSWER%}=={yes} (goto :w8no) 
goto :installStuff
:w8yes 
Echo Preparing the correct version of Xpadder for Windows 8  ...
rename Arcade\Tools\Xpadder\xpadder.exe xpadder_W7.exe  
rename Arcade\Tools\Xpadder\xpadder_Windows8.exe xpadder.exe 
:xboxno 
goto :installStuff

:installStuff
cls
Echo Here we go ...
Echo Installing .NET Framework ...
start /wait Tools\Runtimes\NET\dotnetfx35.exe /q /norestart
Echo Installing C++ 2005 Runtimes ...
start /wait Tools\Runtimes\2005\vcredist_x86.exe /q 
Echo Installing C++ 2008 Runtimes ...
start /wait Tools\Runtimes\2008\install.exe /q 
Echo Installing C++ 2010 Runtimes ...
start /wait Tools\Runtimes\2010\vcredist_x64.exe /q /repair /norestart
Echo Installing C++ 2012 Runtimes ...
start /wait Tools\Runtimes\2012\vcredist_x64.exe /q /repair /norestart
Echo Installing C++ 2013 Runtimes ...
start /wait Tools\Runtimes\2013\vcredist_x64.exe /q /repair /norestart
Echo Installing DirectX 9.0c Libraries needed for older emulators...
start /wait Tools\DirectX\9.0c\DXSETUP.EXE 
Echo Installing Microsoft XNA Runtime Libraries needed for older emulators...
start /wait Tools\XNA\xnafx31_redist.msi 
echo.
Echo Installing Visual Basic Runtime for Zinc ...
start /wait Tools\VBRuntime\msvbvm50.exe /q

:RocketLauncher font
Echo BebasNeue rocketLauncher font
start /wait Arcade\RocketLauncher\Media\Fonts\BebasNeue.ttf

:disable flash player hardware support
Echo disable flash player hardware support
start /wait Tools\firefox\setup.exe /q
start /wait Tools\firefox\flashplayer23_xa_install.exe /q
echo. Read the guide first. Once close installation will begin.
echo.
start /wait notepad.exe Tools/firefox/flashGuide.txt
echo. 

:XboxDriver
cls
echo Do you want to install the latest XBOX 360 Controller Drivers?
echo.
SET /P ANSWER=Install Drivers (Y/N)? 
echo Select: %ANSWER% 
if /i {%ANSWER%}=={y} (goto :xboxyes) 
if /i {%ANSWER%}=={yes} (goto :xboxyes) 
goto :xpadder
:xboxyes 
Echo Installing Current Xbox 360 Controller (x64) Driver  ...
start /wait  tools\xbox360driver\Xbox360_64Eng.exe

:xboxno 
goto :xpadder

:xpadder
echo Executing Xpadder for the first time ... 
echo Please step through the installation process, then exit Xpadder to continue
echo You exit the application by middle clicking the Xpadder tray icon
start /wait d:\arcade\tools\xpadder\xpadder.exe
cls
Echo After Reboot Please watch the videos in the Extras directory to load your xpadder profile
Pause 
CLS
ECHO One last step.
ECHO.
Echo DeamonTools must be installed. Once completed your machine will reboot. 
Echo Please save any open documents or programs before continuing 
echo.
echo. 
echo. Read the guide first. Once close installation will begin.
echo.
start /wait notepad.exe tools/daemontools/dtguide.txt
echo. 
echo. Starting DaemonTools Installation ...
echo.
start /wait tools\daemontools\DTLite4481-0347.exe
goto :reboot

:reboot
cls
echo Your system needs to be rebooted so new system changes can take effect.
echo.
SET /P ANSWER=Do you want to reboot now (Y/N)? 
echo Select: %ANSWER% 
if /i {%ANSWER%}=={y} (goto :rebootyes) 
if /i {%ANSWER%}=={yes} (goto :rebootyes) 
goto :rebootno 
:rebootyes 
shutdown /r /t 0
exit /b 0
:rebootno 
exit /b 1
































