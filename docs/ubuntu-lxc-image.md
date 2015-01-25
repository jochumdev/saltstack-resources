### HOWTO - Prepare a minimal lxc image for salt.

These are basic commands i use to prepare a minimal lxc image for saltstack.

**Login as lxd**

if you have got a unprivileged install like me.

    $ ssh lxd@localhost

**Download the Image**

I use the btrfs [backing store](https://help.ubuntu.com/lts/serverguide/lxc.html#lxc-backinstores) driver here, see its [man page](http://man7.org/linux/man-pages/man1/lxc-create.1.html) for more.

    $ lxc-create -B btrfs -t download -n trusty64 -- -d ubuntu -r trusty -a amd64

**Start and attach**

    lxc-start -n trusty64
    lxc-attach -n trusty64

**Upgrade the base system**

You'r now in the machine, its like *chroot* on *steroids*

    apt-get update && apt-get -qy dist-upgrade

**Install openssh-server**

    apt-get -qy install openssh-server

**Install salt-minion**

    apt-get -qy install software-properties-common
    add-apt-repository -y ppa:saltstack/salt
    apt-get update
    apt-get -qy install salt-minion

**Configure salt-minion for the first connect**

I enable ```IPv6``` here as i use a IPv6 only network to play around.

    service salt-minion stop
    echo -e "master: salt\nipv6: True" > /etc/salt/minion.d/master.conf
    rm -rf /etc/salt/minion_id /etc/salt/pki/

**Remove ssh keys, let salt provision it**

    rm -f /etc/ssh/ssh_host_*_key*

**Set the hostname to FQDN so you have it later with a Domain in your saltmaster**

Replace ```lxc.example.lan``` with the domain you have in ```/etc/default/lxc-net```

    $ sed -i -e's|trusty64|trusty64.lxc.example.lan|' /etc/hosts

**Delete default "ubuntu" user (want salt to provision the id:1000 user)**

    $ userdel -rf ubuntu

**Now** get back on your machine:

    $ exit

**and** stop the base image you must made:

    $ lxc-stop -n trusty64

### Do this every time you need a new testing/production machine
**Clone it and let your salt master provision it :)**

I use the [snapshot](http://man7.org/linux/man-pages/man1/lxc-clone.1.html) feature here.

replace ```jupiter``` with your own hostname.

    $ lxc-clone -s trusty64 jupiter
    $ lxc-start -n jupiter
    
**Get info from your new machine**

    $ lxc-ls -f

**On the Master**

    $ salt-key -a 'jupiter.*'

If you have a firewalled development saltmaster you may want to activate [auto_accept](http://docs.saltstack.com/en/latest/ref/configuration/master.html#auto-accept)
    
**Wanna do it again?**

Destroy the machine (**as lxd@localhost**)

    $ lxc-destroy -n jupiter

Remove the key on the Master

    $ salt-key -d 'jupiter.*'
    
Clone it again and let the master provision it (**again as lxd@localhost**)

    $ lxc-clone -s trusty64 jupiter
    $ lxc-start -n jupiter
