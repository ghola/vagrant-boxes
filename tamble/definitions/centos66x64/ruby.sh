# Install RVM and ruby 2.1.5
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -fsSL https://get.rvm.io | bash -s -- --version latest
/usr/sbin/usermod -a -G rvm vagrant
/usr/sbin/usermod -a -G rvm veewee
/usr/sbin/usermod -a -G rvm root
/usr/local/rvm/bin/rvm install 2.1.5
/usr/local/rvm/bin/rvm alias create default 2.1.5

read -d '' rvmcode <<"EOF"
\# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

  \# First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"

elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

  \# Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"

else

  printf "ERROR: An RVM installation was not found.\n"

fi
EOF

echo "$rvmcode" >> /root/.bashrc
echo "$rvmcode" >> /home/veewee/.bashrc
echo "$rvmcode" >> /home/vagrant/.bashrc


# Disable docs for gems for faster installs
cat > /etc/gemrc << EOM
gem: --no-rdoc --no-ri
EOM