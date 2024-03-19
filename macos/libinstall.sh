#!/bin/sh

#####################################################
#
# prepeare your MacOS for compiling sdr++ sdr++brown
#
######################################################
################################################################
#
# a) MacOS does not have "realpath" so we need to fiddle around
#
################################################################

THISDIR="$(cd "$(dirname "$0")" && pwd -P)"

################################################################
#
# b) Initialize HomeBrew and required packages
#    (this does no harm if HomeBrew is already installed)
#
################################################################
  
#
# This installs the "command line tools", these are necessary to install the
# homebrew universe
#
xcode-select --install

#
# This installes the core of the homebrew universe
#
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#
# At this point, there is a "brew" command either in /usr/local/bin (Intel Mac) or in
# /opt/homebrew/bin (Silicon Mac). Look what applies
#
BREW=junk

if [ -x /usr/local/bin/brew ]; then
  BREW=/usr/local/bin/brew
fi

if [ -x /opt/homebrew/bin/brew ]; then
  BREW=/opt/homebrew/bin/brew
fi

if [ $BREW == "junk" ]; then
  echo HomeBrew installation obviously failed, exiting
  exit
fi

################################################################
#
# This adjusts the PATH. This is not bullet-proof, so if some-
# thing goes wrong here, the user will later not find the
# 'brew' command.
#
################################################################

if [ $SHELL == "/bin/sh" ]; then
$BREW shellenv sh >> $HOME/.profile
fi
if [ $SHELL == "/bin/csh" ]; then
$BREW shellenv csh >> $HOME/.cshrc
fi
if [ $SHELL == "/bin/zsh" ]; then
$BREW shellenv zsh >> $HOME/.zprofile
fi

################################################################
#
# create links in /usr/local if necessary (only if
# HomeBrew is installed in /opt/local)
#
# Should be done HERE if some of the following packages
# have to be compiled from the sources
#
# Note existing DIRECTORIES in /usr/local will not be deleted,
# the "rm" commands only remove symbolic links should they
# already exist.
################################################################

if [ ! -d /usr/local/lib ]; then
  echo "/usr/local/lib does not exist, creating symbolic link ..."
  sudo rm -f /usr/local/lib
  sudo ln -s /opt/local/lib /usr/local/lib
fi
if [ ! -d /usr/local/bin ]; then
  echo "/usr/local/bin does not exist, creating symbolic link ..."
  sudo rm -f /usr/local/bin
  sudo ln -s /opt/local/bin /usr/local/bin
fi
if [ ! -d /usr/local/include ]; then
  echo "/usr/local/include does not exist, creating symbolic link ..."
  sudo rm -f /usr/local/include
  sudo ln -s /opt/local/include /usr/local/include
fi

################################################################
#
# All homebrew packages needed for sdr++ sdr++brown
#
################################################################
$BREW install gtk+3
$BREW install librsvg
$BREW install pkg-config
$BREW install portaudio
$BREW install fftw
$BREW install libusb
$BREW install cmake
$BREW install glfw
$BREW install codec2
$BREW install libiio
$BREW install libad9361
$BREW install python-mako
$BREW install volk
$BREW install zstd


#########################################################
# Lib for bladerf
#########################################################
$BREW install libbladerf

#########################################################
# Lib for RTL_SDR
#########################################################
$BREW install rtl-sdr

#########################################################
# Lib for airspy / airspyhf
# Disable if you want to us soapysdr drivers
#########################################################
$BREW install airspy
$BREW install airspyhf

#########################################################
# Lib for hackers
# Disable if you want to us soapysdr drivers
#########################################################
$BREW install hackrf

#############################################################
#
# This is for the SoapySDR universe
# There are even more radios supported for which you need
# additional modules, for a list, goto the web page
# https://formulae.brew.sh
# and insert the search string "pothosware". In the long
# list produced, search for the same string using the
# "search" facility of your internet browser
#
################################################################

$BREW install pothosware/pothos/limesuite
$BREW install pothosware/pothos/soapysdr
$BREW install pothosware/pothos/soapyredpitaya
$BREW install pothosware/pothos/soapyplutosdr


################################################################
#
# This is for PrivacyProtection
#
################################################################
$BREW analytics off

################################################################
#
# INSTALL SDRPLAY API for Linux
#
################################################################
#echo "Installing SDRPLAY API FOR Linux And SOAPYSDR"
#wget https://www.sdrplay.com/software/SDRplayAPI-macos-installer-universal-3.14.0.pkg
#sudo ./SDRplayAPI-macos-installer-universal-3.14.0.pkg
#echo "Done"

################################################################
# GIt the sdrplay soapy module and build it.
################################################################
#echo " building and installing SoapySDRPlay3"
#git clone https://github.com/pothosware/SoapySDRPlay3.git
#cd SoapySDRPlay3
#mkdir build
#cd build
#cmake ..
#make
#sudo make install
#cd ~
#echo "Done"

#rm -rf tmp

echo ""
echo "IF any errors please report them so that they can be fixed"
echo ""
echo "If there were no errors reported, please reboot your machine."
echo "Everything should be ready to go."
echo "You can Now build SDR++ / SDR++Brown"
echo ""