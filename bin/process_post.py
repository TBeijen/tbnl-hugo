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

def fix_img_tags(content):
	def repl(m):
		# replaces img locations
		m = m.group(1).replace('http://www.tibobeijen.nl/blog/wp-content/', '/media/wp-content/')
		# remove width & height
		m = re.sub(r'(width|height)="\d+"', '', m)
		return m
	return re.sub(re.compile('(<img.*?/>)', re.MULTILINE|re.DOTALL), repl, content)

def github_to_gitlab(content):
	return content.replace(': https://github.com/TBeijen/', ': https://gitlab.com/TBeijen-blog-sample-code/')

def remove_layout_post(content):
	return re.sub(r'layout:\spost\n', '', content)

content = code_to_markdown(content)
content = fix_img_tags(content)
content = github_to_gitlab(content)
content = remove_layout_post(content)

print content
