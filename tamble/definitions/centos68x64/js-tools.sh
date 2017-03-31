curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

yum -y install nodejs

npm install webpack -g
npm install --global gulp-cli

wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
yum -y install yarn