Unofficial list of saltstack resources and Howtos
---
This repo contains a lot of saltstack **formulas** and **states** as submodules which i've found here on github.

I use it to quickly find examples/formulas for my work.

### Get it

    $ git clone https://github.com/pcdummy/saltstack-resources.git
    $ cd saltstack-resources/
    $ git submodule update --init --recursive
  
### Howtos available here

* [Install lxc on Ubuntu](docs/ubuntu-lxc-install.md)
* [Prepare a ubuntu lxc base image](docs/ubuntu-lxc-image.md) for salt.


Usefull saltstack links:
---
### Quickstart

  * [Official Walktrough](http://salt.readthedocs.org/en/latest/topics/tutorials/walkthrough.html) - This is the place to get started with salt.
  * [Git Fileserver](http://salt.readthedocs.org/en/latest/topics/tutorials/gitfs.html#tutorial-gitfs) - Very usefull when you want to reuse code from others, as ubuntu user also have a look at this ppa [pygit2](https://launchpad.net/~dennis/+archive/ubuntu/python)
  * [Basics about Formulas](http://salt.readthedocs.org/en/latest/topics/development/conventions/formulas.html) - See how easy you can get your OS managed with formulas from others.
  * [Salt Modules](http://salt.readthedocs.org/en/latest/salt-modindex.html) - See how Salt integrates into your environment.

### Cheatsheets

  * [Commandline](http://www.xenuser.org/saltstack-cheat-sheet/) - Using salt as "mass executor", get infos and so on.
  * [State development](https://github.com/saltstack/salt/wiki/Cheat-Sheet) - Some basic's about states.
  * [Lots of useful infos condensed on single page](https://gist.github.com/elmariofredo/8964467) - General purpose

### Advanced

  * [The Forman Module](http://salt.readthedocs.org/en/latest/salt-modindex.html) - You want a UI for your mates? Look at [The Forman](http://theforeman.org/)

Contributing:
---
Clone this repo and create add a pull request, i'll happly accept anything related to saltstack, make sure you accept the CC0 license below.

LICENSE:
---
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)
