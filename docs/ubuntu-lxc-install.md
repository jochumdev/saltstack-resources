### HOWTO - Install lxc and prepare it for a unprivileged user.

This howto is based on: [LXC 1.0: Unprivileged containers [7/10]](https://www.stgraber.org/2014/01/17/lxc-1-0-unprivileged-containers/)

I started to play around with [LXD (pronounced lex-dee)](https://github.com/lxc/lxd) but its far from beeing usable IMHO thats why my lxc **unpriviliged** user is called lxd.

Replace **lxd** with any other user, maybe ```yours```?

Install the latest stable lts kernel
---
    $ sudo apt-get -y install linux-image-utopic-lts
    
Enable "memory swapaccount" [found here](http://www.flockport.com/start/)
---
Edit **/etc/default/grub**

    $ gksudo gedit /etc/default/grub

Replace GRUB_CMDLINE_LIINUX_DEFAULT="quiet splash" with:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1"

**Or** use **sed** (i have a LUKS encrypted disk, ```quiet splash``` is buggy):

    $ sed -i -e's|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"|GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"|' /etc/default/grub


Then **update grub**:

    $ sudo update-grub
   
And **reboot**:
    
    $ sudo reboot

Install LXC from the the *daily* ppa
---
I use the *daily* ppa for the latest lxc-features here on my testing laptop.

    $ sudo add-apt-repository -y ppa:ubuntu-lxc/daily
    $ sudo apt-get update
    $ sudo apt-get -y install lxc cgmanager uidmap lxc-templates
    
[LXCFS](https://linuxcontainers.org/lxcfs/introduction/ seems to be unstable here, remove it:

    $ sudo apt-get -y purge lxcfs

Create the user **lxd**
---
A valid shell so i can "ssh lxd@localhost", see this [Permission denied](https://www.stgraber.org/2014/01/17/lxc-1-0-unprivileged-containers/#comment-183371)

    $ sudo useradd -r -d /var/lib/lxd -s /bin/bash lxd     
    
Give lxd 99 uid/gid ranges to map.
---
    $ for i in {1..99}; do \
    	sudo usermod --add-subuids ${i}00000-${i}65536 lxd \
    	sudo usermod --add-subgids ${i}00000-${i}65536 lxd \
    done # This takes a while
    
Create a basic config for that new user
---    
    $ sudo mkdir /var/lib/lxd
    $ sudo chown lxd:lxd /var/lib/lxd
    $ sudo sudo -H -u lxd mkdir -p /var/lib/lxd/.config/lxc/
    
    $ sudo sudo -H -u lxd sh -c 'cat <<EOF > /var/lib/lxd/.config/lxc/default.conf
    lxc.include = /etc/lxc/default.conf
    lxc.id_map = u 0 100000 65537
    lxc.id_map = g 0 100000 65537
    EOF'


Install openssh-server so you can ```$ ssh lxd@localhost```
---
    $ sudo apt-get -y install openssh-server
    
and copy your key
---

    $ sudo mkdir /var/lib/lxd/.ssh/
    $ sudo cp $HOME/.ssh/id_ecdsa.pub /var/lib/lxd/.ssh/authorized_keys
    $ sudo chown -R lxd:lxd /var/lib/lxd/.ssh/

Allow lxd to create machines witch use the ```lxcbr0``` interface
---
    $ echo 'lxd veth lxcbr0 100'| sudo tee -a /etc/lxc/lxc-usernet 1>/dev/null
    $ sudo service lxc restart

Usefull commands
---

  Get CPU, Disk and Memory Usage of your containers
  
  $ lxc-top
    
Now create your first base image
---
[Prepare a minimal lxc image for salt](/docs/ubuntu-lxc-image.md)