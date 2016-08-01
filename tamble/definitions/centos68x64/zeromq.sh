wget https://github.com/zeromq/zeromq3-x/releases/download/v3.2.5/zeromq-3.2.5.tar.gz
tar -xzf zeromq-3.2.5.tar.gz

cd zeromq-3.2.5

./autogen.sh && ./configure && make -j 4
make install && sudo ldconfig

cd ..
rm -rf zeromq-3.2.5*