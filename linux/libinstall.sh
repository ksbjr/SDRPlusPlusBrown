#!/bin/sh

# Dir for building pkgs
mkdir tmp

#####################################################
#
# prepeare your Linux system for compiling SDR++
#
######################################################
echo "First we need to make sure dependancies are installed."

echo "There may be several packages to install.  This could"

echo "take several minutes to complete."

################################################################
#
# All packages needed for SDR++
#
################################################################
echo "Installing Deps for building SDR++ / SDR++Brown"
sudo apt -y install build-essential
sudo apt -y install cmake
sudo apt -y install pkg-config
sudo apt -y install libcodec2-dev
sudo apt -y install libgtk-3-dev
sudo apt -y install portaudio19-dev
sudo apt -y install libfftw3-dev
sudo apt -y install libpulse-dev
sudo apt -y install libsoundio-dev
sudo apt -y install libasound2-dev
sudo apt -y install libhidapi-dev
sudo apt -y install libusb-dev
sudo apt -y install libglfw3-dev
sudo apt -y install libiio-dev
sudo apt -y install libiio-utils
sudo apt -y install libad9361-dev
sudo apt -y install librtaudio-dev
sudo apt -y install libvolk2-dev
sudo apt -y install libzstd-dev
sudo apt -y install zstd
echo "Done"

#########################################################
# Python make
#########################################################
echo "INSTALLING MAKO FOR PYTHON3"
sudo apt -y install python3-mako
echo "Done"

#########################################################
# Lib for bladerf
#########################################################
echo "INSTALLING BLADERF"
sudo apt -y install bladerf
sudo apt -y install libbladerf-dev
sudo apt -y install bladerf-firmware-fx3
sudo apt -y install bladerf-fpga-hostedx115
sudo apt -y install bladerf-fpga-hostedx40
sudo apt -y install bladerf-fpga-hostedxa4
sudo apt -y install bladerf-fpga-hostedxa5
sudo apt -y install bladerf-fpga-hostedxa9
echo "Done"

#########################################################
# Lib for RTL_SDR
#########################################################
echo "Installing RTL-SDR"
sudo apt -y install librtlsdr-dev
sudo apt -y install rtl-sdr
echo "Done"

#########################################################
# Lib for airspy / airspyhf
# Disable if you want to us soapysdr drivers
#########################################################
echo "INSTALLING AIRSPY"
sudo apt -y install airspy
sudo apt -y install libairspy-dev

echo "Installing AIRSPYHF"
sudo apt -y install airspyhf
sudo apt -y install libairspyhf-dev
echo "Done"

#########################################################
# Lib for hackers
# Disable if you want to us soapysdr drivers
#########################################################
echo "Installing HackRF"
sudo apt -y install hackrf
sudo apt -y install libhackrf-dev
echo "Done"

#########################################################
# Limes suite
#########################################################
echo "Installing LimeSuite"
sudo apt -y install limesuite
sudo apt -y install liblimesuite-dev
echo "Done"

################################################################
#
# This is for the SoapySDR universe
# This installs all the modules and firmware
# 
#
################################################################
echo "Installing SoapySDR and Deps"
sudo apt -y install libsoapysdr-dev
sudo apt -y install soapysdr-module-all
sudo apt -y install soapysdr-module-xtrx 
sudo apt -y install soapysdr-tools
sudo apt -y install libsoapysdr-doc
sudo apt -y install uhd-host
sudo apt -y install uhd-soapysdr
sudo apt -y install soapysdr-module-uhd
echo "Done"

################################################################
# GIt the sdrplay soapy audio module and build it.
################################################################
echo " building and installing SoapyAudio"
cd tmp
git clone https://github.com/pothosware/SoapyAudio.git
cd SoapyAudio
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

################################################################
# GIt the sdrplay soapyPlutoSDR module and build it.
################################################################
echo " building and installing SoapyPlutoSDR"
cd tmp
git clone https://github.com/pothosware/SoapyPlutoSDR.git
cd SoapyPlutoSDR
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

################################################################
# GIt the sdrplay soapyPlutoSDR module and build it.
################################################################
echo " building and installing SoapyMultiSDR"
cd tmp
git clone https://github.com/pothosware/SoapyMultiSDR.git
cd SoapyMultiSDR
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

################################################################
# GIt the sdrplay soapy NestSDR module and build it.
################################################################
echo " building and installing SoapyNetSDR"
cd tmp
git clone https://github.com/pothosware/SoapyNetSDR.git
cd SoapyNestSDR
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

################################################################
# GIt the sdrplay soapy FunCube module and build it.
################################################################
echo " building and installing SoapyFCDPP"
cd ~/tmp
git clone https://github.com/pothosware/SoapyFCDPP.git
cd SoapyFCDPP
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

################################################################
#
# INSTALL SDRPLAY API for Linux
#
################################################################
echo "Installing SDRPLAY API FOR Linux And SOAPYSDR"
wget https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-3.14.0.run
sudo chmod 755 ./SDRplay_RSP_API-Linux-3.14.0.run
sudo ./SDRplay_RSP_API-Linux-3.14.0.run
echo "Done"

################################################################
# GIt the sdrplay soapy module and build it.
################################################################
echo " building and installing SoapySDRPlay3"
cd ~/tmp
git clone https://github.com/pothosware/SoapySDRPlay3.git
cd SoapySDRPlay3
mkdir build
cd build
cmake ..
make
sudo make install
cd ~
echo "Done"

rm -rf tmp

echo ""
echo "IF any errors please report them so that they can be fixed"
echo ""
echo "If there were no errors reported, please reboot your machine."
echo "Everything should be ready to go."
echo "You can Now build SDR++ / SDR++Brown"
echo ""
