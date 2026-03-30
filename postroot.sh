#!/bin/bash
 
# Shell script which is executed by bash *AFTER* complete installation is done
# (*AFTER* postinstall and *AFTER* postupdate). Use with caution and remember,
# that all systems may be different!
#
# Exit code must be 0 if executed successfull.
# Exit code 1 gives a warning but continues installation.
# Exit code 2 cancels installation.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Will be executed as user "root".
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# You can use all vars from /etc/environment in this script.
#
# We add 5 additional arguments when executing this script:
# command <TEMPFOLDER> <NAME> <FOLDER> <VERSION> <BASEFOLDER>
#
# For logging, print to STDOUT. You can use the following tags for showing
# different colorized information during plugin installation:
#
# <OK> This was ok!"
# <INFO> This is just for your information."
# <WARNING> This is a warning!"
# <ERROR> This is an error!"
# <FAIL> This is a fail!"
 
# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry
PTEMPPATH=$6  # Sixth argument is full temp path during install (see also $1)
 
# Combine them with /etc/environment
PHTMLAUTH=$LBPHTMLAUTH/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR

# Check Python 3 availability and version
if ! command -v python3 &> /dev/null; then
  echo "<ERROR> Python 3 is required but not installed"
  exit 2
fi

PYTHON_VERSION=$(python3 -c 'import sys; print("{}.{}".format(sys.version_info.major, sys.version_info.minor))')
REQUIRED_VERSION="3.7"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
  echo "<ERROR> Python $REQUIRED_VERSION or higher is required. Found Python $PYTHON_VERSION"
  exit 2
fi

echo "<INFO> Python 3 version check passed: $PYTHON_VERSION"

# Motion
RELEASETAG="release-4.7.1"
VERSION="4.7.1-1"

echo "<INFO> Installing motion from GitHub..."
DEBIANVERSION=`. /etc/os-release && echo $VERSION_CODENAME`
URL="https://github.com/Motion-Project/motion/releases/download/$RELEASETAG"

if [ -e /opt/loxberry/config/system/is_arch_x86_64.cfg ]; then
  ARCH="amd64"
elif [ -e /opt/loxberry/config/system/is_x64.cfg  ]; then
  ARCH="amd64"
elif [ -e /opt/loxberry/config/system/is_arch_aarch64.cfg  ]; then
  ARCH="arm64"
elif [ -e /opt/loxberry/config/system/is_arch_armv7l.cfg  ]; then
  ARCH="armhf"
elif [ -e /opt/loxberry/config/system/is_raspberry.cfg  ]; then
  ARCH="armhf"
fi

if [ $ARCH != "" ]; then
  cd /tmp
  DOWNLOADURL="${URL}/${DEBIANVERSION}_motion_${VERSION}_${ARCH}.deb"
  echo "<INFO> Downloading Motion from: $DOWNLOADURL"
  if wget $DOWNLOADURL; then
    echo "<INFO> Installing Motion package..."
    if dpkg -i $DEBIANVERSION_motion_*.deb; then
      echo "<OK> Motion installed successfully."
      rm $DEBIANVERSION_motion_*.deb
    else
      echo "<ERROR> Motion installation failed. Trying to fix dependencies..."
      apt-get -f install -y
      if dpkg -i $DEBIANVERSION_motion_*.deb; then
        echo "<OK> Motion installed successfully after dependency fix."
        rm $DEBIANVERSION_motion_*.deb
      else
        echo "<FAIL> Motion installation failed completely."
        rm $DEBIANVERSION_motion_*.deb
        exit 2
      fi
    fi
  else
    echo "<ERROR> Failed to download Motion from: $DOWNLOADURL"
    exit 2
  fi
else
  echo "<ERROR> Cannot download motion - unknown architecture"
  exit 2
fi

echo "<INFO> Installing motioneye via pip..."
# Check if we need to use break-system-packages flag (for newer Debian versions)
if [ -f /usr/lib/python3*/EXTERNALLY-MANAGED ] 2>/dev/null; then
  echo "<INFO> Detected externally managed Python environment, using break-system-packages flag"
  if python3 -m pip install motioneye==0.43.1 --break-system-packages; then
    echo "<OK> MotionEye installed successfully."
  else
    echo "<FAIL> MotionEye could not be installed."
    exit 2;
  fi
else
  if python3 -m pip install motioneye==0.43.1; then
    echo "<OK> MotionEye installed successfully."
  else
    echo "<FAIL> MotionEye could not be installed."
    exit 2;
  fi
fi 

echo "<INFO> Creating /etc/motioneye..."
ln -s $PCONFIG /etc/motioneye

echo "<INFO> Deleting Motion Logrotate..."
rm /etc/logrotate.d/motion

echo "<INFO> Adding user loxberry to video group..."
usermod -a -G video loxberry

echo "<INFO> Installing MotionEye Servicefile..."
cp $PTEMPL/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
# If Shebang is still /usr/bin/python, change it to /usr/bin/python3
sed -i 's/^#!\(.*\)python$/#!\1python3/' /usr/local/bin/meyectl
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye

# Motion is handled by MotionEye - so disable it here
systemctl stop motion
systemctl disable motion

# Exit with Status 0
exit 0
