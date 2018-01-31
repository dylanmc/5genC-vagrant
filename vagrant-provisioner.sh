#!/bin/bash
#
# bootstrap.sh
#
# This file is specified in the Vagrantfile and is loaded by Vagrant as the
# primary provisioning script on the first `vagrant up` or subsequent 'up' with
# the '--provision' flag; also when `vagrant provision`, or `vagrant reload --provision`
# are used. You can also bring up your environment and explicitly not run provisioners 
# by specifying '--no-provision'.
set -e
# By storing the date now, we can calculate the duration of provisioning at the
# end of this script.
start_seconds="$(date +%s)"

if [[ -f /inst ]]; then
    echo "Skipping provisioning 5genC";
    exit;
else
    echo "Installing 5genC";
fi

sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt clean

sudo add-apt-repository -y ppa:hvr/ghc
sudo apt-get -y update
sudo apt-get -y install git
sudo apt-get -y install gcc g++
sudo apt-get -y install autoconf libtool make flex bison
sudo apt-get -y install libgmp-dev libmpfr-dev libssl-dev libflint-dev
sudo apt-get -y install cabal-install ghc
sudo apt-get -y install python perl
sudo apt-get -y install wget
sudo apt-get -y install bsdtar

#
# Install Z3
#

mkdir /inst
cd /inst
wget -q https://github.com/Z3Prover/z3/archive/z3-4.5.0.tar.gz
tar xf z3-4.5.0.tar.gz
cd z3-z3-4.5.0
sh ./configure
cd build
make -j8
sudo make install

#
# Install Cryptol
#

cd /inst
wget -q https://github.com/GaloisInc/cryptol/releases/download/2.4.0/cryptol-2.4.0-Ubuntu1404-64.tar.gz
tar xf cryptol-2.4.0-Ubuntu1404-64.tar.gz
export PATH="/inst/cryptol-2.4.0-Ubuntu14.04-64/bin:$PATH"
grep 'inst/cryptol' ~/.profile || echo 'export PATH=/inst/cryptol-2.4.0-Ubuntu14.04-64/bin:$PATH' | tee -a ~/.profile

#
# Install SAW
#

# We need to copy CryptolTC.z3 from the cryptol source repo for saw to work

cd /inst
git clone https://github.com/GaloisInc/cryptol.git
mkdir ~/.cryptol
cp cryptol/lib/CryptolTC.z3 ~/.cryptol

cd /inst
wget -q https://github.com/GaloisInc/saw-script/releases/download/v0.2/saw-0.2-2016-04-12-Ubuntu14.04-64.tar.gz
tar xf saw-0.2-2016-04-12-Ubuntu14.04-64.tar.gz
export PATH="/inst/saw-0.2-2016-04-12-Ubuntu14.04-64/bin:$PATH"
grep 'inst/saw-' ~/.profile || echo 'export PATH=/inst/saw-0.2-2016-04-12-Ubuntu14.04-64/bin:$PATH' | tee -a ~/.profile

#
# Install ABC
#

cd /inst
sudo apt-get -y install mercurial cmake libreadline-dev
hg clone https://bitbucket.org/alanmi/abc
cd abc
cmake .
make -j8
export PATH="/inst/abc:$PATH"
grep 'inst/abc' ~/.profile || echo 'export PATH=/inst/abc:$PATH' | tee -a ~/.profile

#
# Install yosys
#

cd /inst
sudo apt-get -y install yosys

#
# Install Sage
#

cd /inst
sudo apt-get -y install lbzip2 gfortran
wget -q http://mirrors.mit.edu/sage/linux/64bit/sage-7.6-Ubuntu_16.04-x86_64.tar.bz2
bsdtar xvf sage-7.6-Ubuntu_16.04-x86_64.tar.bz2
export PATH="/inst/SageMath:$PATH"
grep 'inst/SageMath' ~/.profile || echo 'export PATH=/inst/SageMath:$PATH' | tee -a ~/.profile

#
# Get 5gen-c repository
#

cd /inst
git clone https://github.com/5GenCrypto/5gen-c.git

cd 5gen-c
git pull origin master
/bin/bash ./build.sh

sudo update-locale LANG=en_US.UTF-8

sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt clean

end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$(expr $end_seconds - $start_seconds)" seconds"
