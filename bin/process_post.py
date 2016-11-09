#!/usr/bin/env python

import re
import sys
in_file = sys.argv[1]

with open(in_file, 'r') as f:
    content = f.read()

def code_to_markdown(content):
	def repl(m):
		return '\n'.join(['    ' + line for line in m.group(1).split('\n')])
	return re.sub(re.compile('<pre.*?>(.*?)</pre>', re.MULTILINE|re.DOTALL), repl, content)

content = code_to_markdown(content)

print content
