mkdir tools
cd tools
PREFIX=$PWD
wget https://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz
tar xvf automake-1.15.tar.gz
cd automake-1.15
./configure --prefix=$PREFIX
make install
cd ..
wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
tar xvf autoconf-2.69.tar.xz
cd autoconf-2.69
./configure --prefix=$PREFIX
make install
cd ..
wget https://ftp.gnu.org/gnu/m4/m4-1.4.tar.gz
tar xvf m4-1.4.tar.gz
cd m4-1.4
./configure --prefix=$PREFIX
make install
cd ..
wget https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz
tar xvf libtool-2.4.6.tar.gz
cd libtool-2.4.6
./configure --prefix=$PREFIX
make install
cd ..
wget --no-check-certificate https://pkgconfig.freedesktop.org/releases/pkg-conf
cd pkg-config-0.29.2
./configure --prefix=$PREFIX
make install
cd ..

