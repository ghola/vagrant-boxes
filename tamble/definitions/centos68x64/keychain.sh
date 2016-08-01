# Install keychain for automated ssh key loading
yum -y install keychain

# Set keychain to load ssh keys
cat > /etc/profile.d/keychain.sh << EOM
### START-Keychain ###
# Let re-use ssh-agent and/or gpg-agent between logins
if [[ \$- == *i* ]]; then
    if [ -d "/home/vagrant/synced_folder/vagrant/dotfiles/.ssh" ]; then
        mkdir -p ~/.ssh
        /bin/cp -rf /home/vagrant/synced_folder/vagrant/dotfiles/.ssh/* ~/.ssh
        if [ -f ~/.ssh/id_dsa ]; then
            chmod 0600 ~/.ssh/id_*
        fi
    fi
    /usr/bin/keychain -q --ignore-missing ~/.ssh/id_dsa
    source ~/.keychain/\$HOSTNAME-sh
fi
### End-Keychain ###
EOM