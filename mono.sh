#   Easy Mono Install Script
#       by Chase Ideas
#
#     www.chaseideas.com
#

#!/bin/bash -e
CURDIR=$(pwd)
BUILDDIR=$CURDIR/build
PREFIX=/opt/mono-2.8

export PATH=$PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

echo "Updating OS ... Please wait ..."
yum update -y

echo "Installing some required packages"
yum install -y make bzip2 automake gettext wget glibc-devel gcc-c++ gcc glib2-devel pkgconfig subversion bison gettext-libs autoconf httpd httpd-devel libtool libtiff-devel libexif-devel libexif libjpeg-devel gtk2-devel atk-devel pango-devel giflib-devel $

mkdir -p $BUILDDIR

echo
echo "Downloading mono files"
echo

cd $BUILDDIR

echo "Building libgdiplus..."
wget http://download.mono-project.com/sources/libgdiplus/libgdiplus-2.10.tar.bz2
tar xjvf libgdiplus-2.10.tar.bz2
cd libgdiplus-2.10
./configure --prefix=/opt/mono-2.10.8
make
make install


echo "Build mono..."
wget http://download.mono-project.com/sources/mono/mono-2.10.8.tar.bz2
tar xjvf mono-2.10.8.tar.bz2
cd mono-2.10.8
./configure  --with-large-heap=yes --prefix=/opt/mono-2.10.8 --with-libgdiplus=/opt/mono-2.10.8 --with-moonlight=no
make
make install

echo "Building mono-basic..."
wget http://download.mono-project.com/sources/mono-basic/mono-basic-2.10.tar.bz2
tar xjvf mono-basic-2.10.tar.bz2
cd mono-basic-2.10
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig ./configure --prefix=/opt/mono-2.10.8
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig make
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig make install

echo "Building xsp..."
wget http://download.mono-project.com/sources/xsp/xsp-2.10.2.tar.bz2
tar xjvf xsp-2.10.2.tar.bz2
cd xsp-2.10.2
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig ./configure --prefix=/opt/mono-2.10.8
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig make
PATH=$PATH:/opt/mono-2.10.8/bin PKG_CONFIG_PATH=/opt/mono-2.10.8/lib/pkgconfig make install

echo "Building mod_mono..."
wget http://pkgs.fedoraproject.org/repo/pkgs/mod_mono/mod_mono-2.8.tar.bz2/0460af8b017a1796998dc2aa947a860b/mod_mono-2.8.tar.bz2
tar xjvf mod_mono-2.8.tar.bz2
cd mod_mono-2.8*
./configure
make
make install

echo "mod_mono installed successfully!"
echo ""

echo "Time to restart apache for the new config"

echo "Stopping apache (ignore errors if fails on 'service stop')"
/sbin/service httpd stop

echo "Starting apache"
/sbin/service httpd start


echo "Apache restarted! Default mod_mono.conf has been added to the apache config file"
echo "To further configure mod_mono please visit http://go-mono.com/config-mod-mono/"

echo ""
PATH=$PATH:/opt/mono-2.10.8/bin

echo "Mono path alias created, displaying version of installed mono"
mono --version
