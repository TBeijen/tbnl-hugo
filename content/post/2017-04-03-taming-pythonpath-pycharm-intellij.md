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
**TL;DR:** PyCharm and IntelliJ have some odd defaults that can mask mistakes until they hit CI.

## Introduction

In a project we're working on we recently witnessed quite some builds fail on unit tests that apprently passed on local development environments. As it turned out all of the failures where related to import errors and were caused by developers accidentally importing relative to the main django application instead of the project root. We're human, we make mistakes. That's why it was quite annoying that the unit tests we write to signal these mistakes quickly, only started failing on the CI system.

## Analysis: PYTHONPATH shenanigans

Tests failed when run from the command line also but as most of our team uses either PyCharm or IntelliJ to run the test suite, it was clear that there was some issue in how we set up our projects in those IDEs.

Project layout is as follows:
```
(api-2) [api-2:]$ pwd
/Users/tibobeijen/projects/repos/api-2
(api-2) [api-2:]$ tree -L 1 -d
.
├── __pycache__
├── api
├── config
├── deploy
├── docs
├── htmlcov
├── requirements
├── scripts
├── static
└── tests

10 directories
```
Comparing ``sys.path`` from the command line and from code run by the IDE showed that in the IDE the directories ``/Users/.../api-2/api`` and ``/Users/.../api-2/config`` were added to the ``PYTHONPATH`` [^footnote_pythonpath].

## Configuring PyCharm and IntelliJ

Looking into the configuration options in IntelliJ, there are several places where adding of directories to ``PYTHONPATH`` can be configured. 

### Project configuration
First of all there is the project configuration that determines what are the 'content roots' and the 'source roots' (See [PyCharm's content root documentation](https://www.jetbrains.com/help/pycharm/2016.3/content-root.html)).

{{< figure src="/img/pythonpath_pycharm__project_settings.png" title="Project settings" >}}

### Application preferences
In the application preferences there are options to add content roots and source roots to the python console and django console. Source roots is off by default so that's good.

{{< figure src="/img/pythonpath_pycharm__preferences.png" title="IntelliJ preferences" >}}

### Configuration defaults
Finally, there are per-project configuration defaults for 'Django server' and 'py.test'. Herein lies the problem, as for both the default is to add source roots to ``PYTHONPATH``. This is the one that masks the import errors as 'api' and 'config' folders were marked as source roots.

{{< figure src="/img/pythonpath_pycharm__configuration_defaults.png" title="Configuration defaults" >}}

I'm not sure what the case would be to have these on by default, as eventually code has to run outside of the IDE. Interfere less by default seems the more defensive (meaning: better) strategy here, but I might be overlooking something. Our project is loosely based on the [Cookiecutter Django project template](https://github.com/pydanny/cookiecutter-django/tree/master/%7B%7Bcookiecutter.project_slug%7D%7D) so these defaults likely impact more projects.

## Don't control all the IDEs, control the project
Of course we discussed these findings in our team chat. Nevertheless I prefer a situation where fail-fast will definitely happen, and not by the mercy of having unchecked the right boxes in a configuration screen. Luckily ``pytest`` has the incredibly flexible concept of ``fixtures`` that makes it trivial to revert unwanted ``PYTHONPATH`` additions.

```
# From: conftest.py

@pytest.fixture(autouse=True)
def fix_sys_path():
    project_root = str(Path(__file__).parents[1])
    paths_to_remove = [
        'api', 'config', 'tests'
    ]
    for p in paths_to_remove:
        try:
            sys.path.remove(os.path.join(project_root, p))
        except ValueError:
            pass  # path might not have been added to sys.path
```

Problem solved. That's it. I hope this helped save anyone who googled here at least the amount of time it took to read this. 

 [^footnote_pythonpath]: ``sys.path`` consists of various directories _and_ the paths in the optional environment variable ``$PYTHONPATH``.