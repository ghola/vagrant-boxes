yum -y install zsh

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i -- 's/robbyrussell/agnoster/g' ~/.zshrc

su - vagrant -c 'sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"'
su - vagrant -c 'sed -i -- 's/robbyrussell/agnoster/g' ~/.zshrc'
