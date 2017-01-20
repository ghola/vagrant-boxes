yum -y install zsh

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i -- 's/robbyrussell/agnoster/g' ~/.zshrc

cat >> ~/.zshrc << EOM
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_end
}
EOM
sed -i '/^# DISABLE_AUTO_UPDATE/s/^# //' ~/.zshrc

su - vagrant -c 'sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"'
su - vagrant -c 'sed -i -- 's/robbyrussell/agnoster/g' ~/.zshrc'
usermod -s /bin/zsh vagrant

cat >> /home/vagrant/.zshrc << EOM
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_end
}
EOM
sed -i '/^# DISABLE_AUTO_UPDATE/s/^# //' /home/vagrant/.zshrc

echo "source /etc/profile" >> /etc/zprofile