# docker-receive

git push docker container, build docker image, deploy them.

> wip, learning docker

This repo is essentially a [receiver](provisioning/templates/receiver)
script to build out Docker images and container on top of [git receive][gitreceive].

---

Goals:

- Built for CentOS (using [chef/centos-6.5][chef])
- Git based, deploy per push, commit each push
- [Docker][docker] based, apps are project with Dockerfile
- [DockerUI][dockerui] to manage them
- [Gitreceive][gitreceive] to handle git push
- /opt/git to host repositories (/home/git for now)
- Built in monitoring
- Access logs / metrics, start, stop containers
- conf management (ENV based)

[chef]: https://vagrantcloud.com/chef/centos-6.5
[docker]: https://www.docker.io/
[dockerui]: https://github.com/crosbymichael/dockerui
[gitreceive]: https://github.com/progrium/gitreceive

---


## Install

    vagrant up

It'll run [provisioning/install.sh](provisioning/install.sh) script to
install everything needed on a CentOS box.

A `git` user is created, with `/home/git` as a base directory.

## Usage

### Add SSH key

    $ cat ~/.ssh/id_rsa.pub | ssh vagrant@192.168.33.30 "sudo gitreceive upload-key $USER"

The user is only used for information, no authentification is performed (yet, consider [gitreceived](https://github.com/flynn/gitreceived))

### Init repo

Create a Dockerfile for your app, add a remote to the deploy server:

    $ git remote add deploy git@192.168.33.30:example.git

And push your app for deployment. It'll create a docker image, and tag
it with the git revision, like so
`example.git:798f68a77bb1ce92a22928eeb4c245d8a3089131`

- Docker image tag name: `example:798f68a77bb1ce92a22928eeb4c245d8a3089131`
- Docker container: `example`
- Docker build image path: `/home/git/example`

The `example.git` repository is automatically created on first push and
namespaces should be supported (`user/project.git`).

```
# Ex with git@github.com:gasi/docker-node-hello.git
$ git remote add deploy git@192.168.33.30:node-hello.git
$ git push deploy master
Counting objects: 20, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (14/14), done.
Writing objects: 100% (20/20), 4.49 KiB | 0 bytes/s, done.
Total 20 (delta 6), reused 20 (delta 6)
remote: Creating app /home/git/node-hello
remote: Building docker image
remote: docker build -t node-hello:83b8537d9141d4a1baae1346b7f9c8359c073c6d
remote: Uploading context 12.29 kB
remote: Uploading context
remote: Step 0 : FROM    centos:6.4
remote:  ---> 539c0211cd76
remote: Step 1 : RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i
386/epel-release-6-8.noarch.rpm
remote:  ---> Using cache
remote:  ---> b36ebb27564e
remote: Step 2 : RUN     yum install -y npm
remote:  ---> Using cache
remote:  ---> cf3eec84637a
remote: Step 3 : ADD . /src
remote:  ---> d900b9a7b978
remote: Removing intermediate container e9a5248200e8
remote: Step 4 : RUN cd /src; npm install
remote:  ---> Running in 81562d8a8761
remote: npm http GET https://registry.npmjs.org/express/3.2.4
remote: npm ...
remote: express@3.2.4 node_modules/express
remote: ├── methods@0.0.1
remote: ├── fresh@0.1.0
remote: ├── range-parser@0.0.4
remote: ├── debug@0.8.1
remote: ├── cookie-signature@1.0.1
remote: ├── buffer-crc32@0.2.1
remote: ├── cookie@0.0.5
remote: ├── commander@0.6.1
remote: ├── mkdirp@0.3.4
remote: ├── send@0.1.0 (mime@1.2.6)
remote: └── connect@2.7.9 (pause@0.0.1, qs@0.6.4, bytes@0.2.0, formidable@1.0.13
)
remote:  ---> b7f47da5dc75
remote: Removing intermediate container 81562d8a8761
remote: Step 5 : EXPOSE  8080
remote:  ---> Running in 28f1353f86ac
remote:  ---> 82b8b860330f
remote: Removing intermediate container 28f1353f86ac
remote: Step 6 : CMD ["node", "/src/index.js"]
remote:  ---> Running in a4d37f3ddfe8
remote:  ---> 3a37a3ff136d
remote: Removing intermediate container a4d37f3ddfe8
remote: Successfully built 3a37a3ff136d
remote: Running container node-hello:83b8537d9141d4a1baae1346b7f9c8359c073c6d
remote: 7b5ddb53462ce8aa459e137ad781598706cdaf86874d73b09090eef0954e0b5d
To git@192.168.33.30:node-hello.git
 * [new branch]      master -> master
```

### Run / Stop the app

Head over to http://192.168.33.30:9000 to access [dockerui][dockerui]

#### Few docker commands

For more info, refer to [docker documentation](https://docs.docker.io/reference/commandline/cli/)

Start / stop containers

    $ docker start <name>
    $ docker stop <name>

See logs

    $ docker logs <name>

Attach to container

    $ docker attach <name>

Figure out wich port the container is running on (containers are bound
with `-P`, meaning random ports between `49000..49900` are assigned. For
more, see [Redirect
ports](https://docs.docker.io/use/port_redirection/#auto-map-all-exposed-ports-on-the-host))

    $ docker port <name> <port>

    # Ex.
    [git@dockeropt ~]$ docker port node-hello 8080
    0.0.0.0:49154

    # Then access: http://192.168.33.30:49154
