

1. 安装依赖包
   yum -y install wget make gcc gcc-c++

2. 下载、安装 nodejs
   官方下载：http://www.nodejs.org/download/

   cd /usr/local/src
   wget http://nodejs.org/dist/v0.10.18/node-v0.10.18.tar.gz
   tar -xvf node-v0.10.18.tar.gz
   cd /usr/local/src/node-v0.10.18
   ./configure --prefix=/usr/local/nodejs
   make
   make install

   sed '//d'
   echo 'export PATH=$PATH:/usr/local/nodejs/bin' >> /etc/profile  
   source /etc/profile 


3. 安装 express
   cd /usr/local/nodejs/lib/node_modules/npm
   npm install
   npm install -g express
   
   node -v
   express -V


