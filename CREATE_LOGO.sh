# Created By neo_subhamoy (Contact me @ https://neosubhamoy.com)
# Created By Gokul NC (Contact me @ https://about.me/GokulNC )
# Created By Pzqqt (Contact me @ https://t.me/Pzqqt )
# WARNING: DO NOT MODIFY THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING!

# This is for POCO X3 Pro (vayu) device only, please do not try on other devices..
# For other devices: http://forum.xda-developers.com/android/software-hacking/guide-how-to-create-custom-boot-logo-t3470473

#!/bin/bash

echo ""
echo "#--------------------------------------------------#"
echo "#        POCO X3 Pro (vayu) Logo Image Maker       #"
echo "#                                                  #"
echo "#     By ** neo_subhamoy ^& Gokul NC ^& Pzqqt **   #"
echo "#--------------------------------------------------#"
echo ""
echo ""
echo "Creating logo.img ........"
echo ""
echo ""
echo ""

output_file="logo.img"
output_file_path="output/${output_file}"

output_zip="flashable_logo.zip"
output_zip_path="output/${output_zip}"

resolution="1080x2400"

# CREATE FOLDERS AND DELETE OLD FILES
mkdir -p output
mkdir -p temp
rm -f temp/*
rm -f "$output_file_path"
rm -f "$output_zip_path"

# VERIFY FILES
logo_path="not_found"
for ext in jpg jpeg png gif bmp; do
    if [ -e "pics/logo.${ext}" ]; then
        logo_path="pics/logo.${ext}"
        break
    fi
done

fastboot_path="not_found"
for ext in jpg jpeg png gif bmp; do
    if [ -e "pics/fastboot.${ext}" ]; then
        fastboot_path="pics/fastboot.${ext}"
        break
    fi
done

system_corrupt_path="not_found"
for ext in jpg jpeg png gif bmp; do
    if [ -e "pics/system_corrupt.${ext}" ]; then
        system_corrupt_path="pics/system_corrupt.${ext}"
        break
    fi
done

if [ "$logo_path" == "not_found" ]; then
    echo "Logo picture not found in 'pics' folder.. EXITING"
    echo ""
    echo ""
    read -p "Press Enter to exit..."
    exit
fi

if [ "$fastboot_path" == "not_found" ]; then
    echo "Fastboot picture not found in 'pics' folder.. EXITING"
    echo ""
    echo ""
    read -p "Press Enter to exit..."
    exit
fi

if [ "$system_corrupt_path" == "not_found" ]; then
    echo "System corrupt picture not found in 'pics' folder.. EXITING"
    echo ""
    echo ""
    read -p "Press Enter to exit..."
    exit
fi

# Create BMP
ffmpeg -hide_banner -loglevel quiet -i "$logo_path" -pix_fmt rgb24 -s "$resolution" -y "temp/logo_1.bmp" > /dev/null
ffmpeg -hide_banner -loglevel quiet -i "$fastboot_path" -pix_fmt rgb24 -s "$resolution" -y "temp/logo_2.bmp" > /dev/null
ffmpeg -hide_banner -loglevel quiet -i "$logo_path" -pix_fmt rgb24 -s "$resolution" -y "temp/logo_3.bmp" > /dev/null
ffmpeg -hide_banner -loglevel quiet -i "$system_corrupt_path" -pix_fmt rgb24 -s "$resolution" -y "temp/logo_4.bmp" > /dev/null

# Create the full logo.img by concatenating header and all BMP files
cat "bin/header.bin" "temp/logo_1.bmp" "bin/footer.bin" "temp/logo_2.bmp" "bin/footer.bin" "temp/logo_3.bmp" "bin/footer.bin" "temp/logo_4.bmp" "bin/footer.bin" > "$output_file_path"

if [ -e "$output_file_path" ]; then
    echo "SUCCESS!"
    echo "$output_file created in 'output' folder"
else
    echo "PROCESS FAILED.. Try Again"
    echo ""
    echo ""
    read -p "Press Enter to exit..."
    exit
fi

read -p "Do you want to create a flashable zip? [yes/no] " INPUT
if [ "$INPUT" == "y" ] || [ "$INPUT" == "yes" ]; then
    create_zip=true
else
    echo ""
    echo "Flashable ZIP not created.."
    echo ""
    echo ""
    read -p "Press Enter to exit..."
    exit
fi

if [ "$create_zip" == true ]; then
    cp "bin/New_Logo.zip" "$output_zip_path" > /dev/null
    cd output || exit
    7za a "$output_zip" "$output_file" > /dev/null
    cd ..
    
    if [ -e "$output_zip_path" ]; then
        echo ""
        echo "SUCCESS!"
        echo "Flashable zip file created in 'output' folder"
        echo "You can flash the '$output_zip' from any custom recovery like TWRP/OrangeFox"
    else
        echo ""
        echo "Flashable ZIP not created.."
    fi
fi

echo ""
echo ""
read -p "Press Enter to exit..."