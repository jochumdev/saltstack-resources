### HOWTO - Prepare a minimal lxc image for salt.

These are basic commands i use to prepare a minimal lxc image for saltstack.

**Login as lxd**

if you have got a unprivileged install like me.

    $ ssh lxd@localhost

**Download the Image**

I use the btrfs [Backing store](https://help.ubuntu.com/lts/serverguide/lxc.html#lxc-backinstores) driver here, see its [man page](http://man7.org/linux/man-pages/man1/lxc-create.1.html) for more.

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

    service salt-minion stop
    echo -e "master: salt\nipv6: True" > /etc/salt/minion.d/master.conf
    rm -rf /etc/salt/minion_id /etc/salt/pki/

**Remove ssh keys, let salt provision it**

    rm -f /etc/ssh/ssh_host_*_key*

**Set the hostname to FQDN so you have it later with a FQDN in your saltmaster**

    $ sed -i -e's|trusty64|trusty64.example.com|' /etc/hosts

**Delete default "ubuntu" user (want salt to provision the id:1000 user)**

    userdel -rf ubuntu

**Detatch and stop the image**

    exit
    
Your **back**  as **lxd@localhost**

    lxc-stop -n trusty64

### Now every time you need a new testing/production machine
**Clone it and let your salt master provision it :)**

I use the [snapshot](http://man7.org/linux/man-pages/man1/lxc-clone.1.html) feature here.

replace *jupiter* with your destination hostname.

    $ lxc-clone -s trusty64 jupiter
    $ lxc-start -n jupiter
    
**Get info from your new machine**

    $ lxc-ls -f

**On the Master**

    $ salt-key -A 'jupiter.*'
    
**Wanna do it again?**

Destroy the machine (**as lxd@localhost**)

    $ lxc-destroy -n jupiter

Remove the key on the Master

    $ salt-key -r 'jupiter.*'
    
Clone it again and let the master provision it (again **as lxd@localhost**)

    $ lxc-clone -s trusty64 jupiter
    $ lxc-start -n jupiter