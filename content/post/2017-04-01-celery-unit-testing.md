---
title: 'Celery Unit Testing'
author: Tibo Beijen
date: 2017-04-01T10:00:00+01:00
url: /2017/04/01/celery-unit-testing/
categories:
  - articles
tags:
  - Django
  - Celery
  - Pytest
description: 

---

Using eager

Downsides,
Pros: Fast, Mocking

Example:


Using worker, no external dependencies

Examples:
wait for result
wait for side effect



Using worker, external dependencies

Example: Download cat, mock external request fetching.




http://stackoverflow.com/questions/30450468/mocking-out-a-call-within-a-celery-task

celery_worker.app.control.broadcast()

http://docs.celeryproject.org/en/latest/reference/celery.app.control.html

http://celery.readthedocs.io/en/latest/userguide/workers.html#writing-your-own-remote-control-commands


Look into pytest MonkeyPatch. setattr, undo().



SQlite3 locking when using factory boy and celery_worker fixture

functional test, using ArticleFactory
E       sqlite3.OperationalError: database table is locked: news
