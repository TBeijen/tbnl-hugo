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
<!-- description: HOWTO on setting up pyenv and pyenv-virtualenv on OSX. -->

---
Until recently I relied on OS X native python for anything 2.7.x and Homebrew's python3 for anything 3.x.x. As already implied by the lots of 'x'-es: Far from ideal. But it worked. Until I accidentally ran a ``brew upgrade`` which put my python 3 version to a bleeding edge ``3.6.0``. Newer than what's provisioned on our stack and besides that I ran into some errors when installing requirements in a new virtualenv that I suspected to be related to the python version bump.

So... how to downgrade? After some googling I quickly found [this gist](https://gist.github.com/Bouke/11261620), where it's [advised in the comments](https://gist.github.com/Bouke/11261620#gistcomment-1573091) to use ``pyenv``. Combined with [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv) it was easy to get back to the python version of before.

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

## Adding python versions
Very straightforward:

```
pyenv install 3.5.3
```

## Creating a virtualenv

By default virtualenvs created using pyenv-virtualenv are located in ``~/.pyenv/versions/``. The syntax has changed as well, compared to 'vanilla' virtualenv. As virtualenvs are now in a central location, my advise would be to simply name them similar to the project they belong to. So if you're working on a project called 'api', create a virtualenv using:

```
pyenv virtualenv 3.5.3 api
```

## Making auto-activate work
To have the previously added bash profile commands work, the folder's python version needs to be set not to the python version but to the virtualenv name:

```
pyenv local api
```

This wasn't immediately clear from the [readme on GitHub](https://github.com/yyuu/pyenv-virtualenv) but makes sense when you look how the ``~/.pyenv`` folder is organized:

<pre>
(api) [api:]$ cat .python-version
api
(api) [api-2:]$ ls -1 ~/.pyenv/versions/
3.5.3
api
(api-2) [api-2:]$ ls -l ~/.pyenv/versions/
# edited for readability
3.5.3
api-2 -> /Users/tibobeijen/.pyenv/versions/3.5.3/envs/api-2
</pre>

## Finding your virtualenv
Finding your virtualenv in PyCharm or Intellij is a bit trickier than before. As the virtualenv now resides in a hidden folder you need to have those visible by default in open dialogs (I believed I already tweaked that, I might be wrong or Sierra has messed up). Anyway, as [pointed out on StackExchange](http://apple.stackexchange.com/questions/99213/is-it-possible-to-always-show-hidden-dotfiles-in-open-save-dialogs), do so by:

```
defaults write -g AppleShowAllFiles -bool true
```

## When Xcode doesn't play nice
As a sidenote, if you run into all kinds of compile errors, it doesn't hurt to check the state of your xcode installation. Things not working after a xcode update has bitten me more than once (The xcode update after upgrading to Sierra caused my command line tools to disappear).

```
xcode-select --install
xcodebuild -license
```

That's it. Hope the above helps setting ``pyenv`` up quickly.