
Goals:

- /opt/$user/$app to host repositories
- Git based, deploy per push, commit each push
- Docker based, apps are project with Dockerfile
- DockerUI to manage them
- Gitlab ? for /opt/ repo viewing
- Built in monitoring
- Access logs, start, stop containers


- CentOS based
- Gitreceive

## Install

    vagrant up

It'll run [provisioning/install.sh](provisioning/install.sh) script to
install everything needed on a CentOS box.

A `git` user is created, with `/home/git` as a base directory.

## Usage

### Add SSH key

    $ cat ~/.ssh/id_rsa.pub | ssh vagrant@192.168.33.30 "sudo gitreceive upload-key $USER"

### Init repo

Create a Dockerfile for your app, add a remote to the deploy server:

    $ git remote add deploy git@192.168.33.30:example.git

And push your app for deployment. It'll create a docker image, and tag
with the git revision, like so `example.git:798f68a77bb1ce92a22928eeb4c245d8a3089131`

The `example.git` repository is automatically created on first push.

### Run / Stop the app

Head over to http://192.168.33.30
