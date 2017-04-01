---
title: 'Taming PYTHONPATH in PyCharm and IntelliJ'
author: Tibo Beijen
date: 2017-04-03T17:00:00+01:00
url: /2017/04/03/taming-pythonpath-pycharm-intellij/
categories:
  - articles
tags:
  - Python
  - Pytest
  - Django
  - Unit Test
  - PyCharm
  - IntelliJ
description: PyCharm and IntelliJ default PYTHONPATH shenanigans. 

---
In a project we're working on we recently witnessed quite some builds fail on tests that apprently passed on local development environments. As it turned out all of the failures where related to import errors and were caused by developers accidentally importing relative to the main django application instead of the project root. We're human, we make mistakes. That's why it was quite annoying that the unit tests we write to signal these mistakes quickly, only started failing on the CI system.

