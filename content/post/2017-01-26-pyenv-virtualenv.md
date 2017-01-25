---
title: 'Using pyenv and pyenv-virtualenv on OSX'
author: Tibo Beijen
date: 2017-01-26T10:00:00+01:00
url: /2017/01/09/using-pyenv-and-pyenv-virtualenv-on-osx/
categories:
  - articles
tags:
  - Python
  - OSX
  - Homebrew
  - Pyenv
  - Virtualenv
description: 

---
Until recently I relied on OS X native python for anything 2.7.x and Homebrew's python3 for anything 3.x.x. As already implied by the lots of 'x'-es: Far from ideal. But it worked. Until I accidentally ran a ``brew upgrade`` which put my python 3 version to a bleeding edge ``3.6.0``. Newer than what's provisioned on our stack and besides that I ran into some errors when creating a new virtualenv that I suspected to be related to the python version bump.

So... how to downgrade? After some googling I quickly found [this gist](https://gist.github.com/Bouke/11261620), where it's [advised in the comments](https://gist.github.com/Bouke/11261620#gistcomment-1573091) to use {{pyenv}}. Combined with [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv) it was easy to get back to the python version of before.

## Installation
Installation is straightforward:
```
brew update
brew install pyenv
brew install pyenv-virtualenv
```

Furthermore, add this to your ``~/.bashrc`` or ``~/.bash_profile`` (whatever fits your setup best) to have a virtualenv automatically be enabled for a certain folder:

```
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

## Creating a virtualenv

Creating a virtualenv is slightly different as it was. Furthermore, by default virtualenvs are now created in ``~/.pyenv/versions/``.




## Finding your virtualenv
Finding your virtualenv in PyCharm or Intellij is a bit trickier than before. As the virtualenv now resides in a hidden folder you need to have those visible by default in open dialogs (I believed I already tweaked that, I might be wrong or Sierra has messed up). Anyway, as [pointed out on StackExchange](http://apple.stackexchange.com/questions/99213/is-it-possible-to-always-show-hidden-dotfiles-in-open-save-dialogs), do so by:

```
defaults write -g AppleShowAllFiles -bool true

```
