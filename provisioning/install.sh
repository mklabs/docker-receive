# EPEL
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

OPT_USER=${OPT_USER:-git}
DOCKER_NS=${DOCKER_NS:-$OPT_USER-docker}

yum install git docker-io nodejs npm vim -y

# adduser $OPT_USER -b /opt
#
# mkdir -p /opt/$OPT_USER/repos
# mkdir -p /opt/$OPT_USER/scripts
# mkdir -p /opt/$OPT_USER/apps
# mkdir -p /opt/$OPT_USER/conf

git config --global user.name "Server $OPT_USER"
git config --global user.email "$OPT_USER@server.com"

# Git receive
curl https://raw.githubusercontent.com/progrium/gitreceive/master/gitreceive > /usr/bin/gitreceive
chmod +x /usr/bin/gitreceive

# Git receive init
gitreceive init

# Docker

service docker start
chkconfig docker on

# Setup docker ui
docker build -t crosbymichael/dockerui github.com/crosbymichael/dockerui
docker run -d -p 9000:9000 -v /var/run/docker.sock:/docker.sock crosbymichael/dockerui -e /docker.sock
