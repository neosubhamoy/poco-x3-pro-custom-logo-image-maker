:: Created By neo_subhamoy (Contact me @ https://neosubhamoy.com)
:: Created By Gokul NC (Contact me @ https://about.me/GokulNC )
:: Created By Pzqqt (Contact me @ https://t.me/Pzqqt )
:: WARNING: DO NOT MODIFY THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING!

:: This is for POCO X3 Pro (vayu) device only, please do not try on other devices..
:: For other devices: http://forum.xda-developers.com/android/software-hacking/guide-how-to-create-custom-boot-logo-t3470473

@echo off
echo.
echo.#--------------------------------------------------#
echo.#        POCO X3 Pro (vayu) Logo Image Maker       #
echo.#                                                  #
echo.#     By ** neo_subhamoy ^& Gokul NC ^& Pzqqt **     #
echo.#--------------------------------------------------#
echo.
echo.
echo.Creating logo.img ........
echo.
echo.
echo.

set output_file=logo.img
set output_file_path=output\%output_file%

set output_zip=flashable_logo.zip
set output_zip_path=output\%output_zip%

setlocal
if not exist "output\" mkdir "output\"
if not exist "temp\" ( mkdir "temp\"& attrib /S /D +h "temp" )
del /Q temp\* 2>NUL
del /Q %output_file_path% 2>NUL
del /Q %output_zip_path% 2>NUL

set resolution=1080x2400

:VERIFY_FILES
set logo_path="not_found"
if exist "pics\logo.jpg" set logo_path="pics\logo.jpg"
if exist "pics\logo.jpeg" set logo_path="pics\logo.jpeg"
if exist "pics\logo.png" set logo_path="pics\logo.png"
if exist "pics\logo.gif" set logo_path="pics\logo.gif"
if exist "pics\logo.bmp" set logo_path="pics\logo.bmp"
if %logo_path%=="not_found" echo.logo picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

set fastboot_path="not_found"
if exist "pics\fastboot.jpg" set fastboot_path="pics\fastboot.jpg"
if exist "pics\fastboot.jpeg" set fastboot_path="pics\fastboot.jpeg"
if exist "pics\fastboot.png" set fastboot_path="pics\fastboot.png"
if exist "pics\fastboot.gif" set fastboot_path="pics\fastboot.gif"
if exist "pics\fastboot.bmp" set fastboot_path="pics\fastboot.bmp"
if %fastboot_path%=="not_found" echo.fastboot picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

set system_corrupt_path="not_found"
if exist "pics\system_corrupt.jpg" set system_corrupt_path="pics\system_corrupt.jpg"
if exist "pics\system_corrupt.jpeg" set system_corrupt_path="pics\system_corrupt.jpeg"
if exist "pics\system_corrupt.png" set system_corrupt_path="pics\system_corrupt.png"
if exist "pics\system_corrupt.gif" set system_corrupt_path="pics\system_corrupt.gif"
if exist "pics\system_corrupt.bmp" set system_corrupt_path="pics\system_corrupt.bmp"
if %system_corrupt_path%=="not_found" echo.system_corrupt picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

:: Create BMP
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %logo_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_1.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %fastboot_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_2.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %logo_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_3.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %system_corrupt_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_4.bmp" > NUL


:: Create the full logo.img by concatenating header and all BMP files
copy /b "bin\header.bin"+"temp\logo_1.bmp"+"bin\footer.bin"+"temp\logo_2.bmp"+"bin\footer.bin"+"temp\logo_3.bmp"+"bin\footer.bin"+"temp\logo_4.bmp"+"bin\footer.bin" %output_file_path% >NUL

if exist %output_file_path% ( echo.SUCCESS! &echo.%output_file% created in "output" folder
) else ( echo.PROCESS FAILED.. Try Again&echo.&echo.&pause&exit )

echo.&echo.&set /P INPUT=Do you want to create a flashable zip? [yes/no]
If /I "%INPUT%"=="y" goto :CREATE_ZIP
If /I "%INPUT%"=="yes" goto :CREATE_ZIP

echo.&echo.&echo Flashable ZIP not created..&echo.&echo.&pause&exit

:CREATE_ZIP
copy /Y bin\New_Logo.zip %output_zip_path% >NUL
cd output
..\bin\7za a %output_zip% %output_file% >NUL
cd..

if exist %output_zip_path% (
 echo.&echo.&echo.SUCCESS!
 echo.Flashable zip file created in "output" folder
 echo.You can flash the '%output_zip%' from any custom recovery like TWRP/OrangeFox
) else ( echo.&echo.&echo Flashable ZIP not created.. )

echo.&echo.&pause&exit
