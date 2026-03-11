#!/usr/bin/env python

"""Recover source code from assembler listing."""

import re
import sys


def space(n):
   for i in range(n):
      out(" ")


def tabify(column, spaces):
   while spaces >= 8:
      out("\t")
      spaces = spaces - 8
   if spaces == 0:
      return
   if (column % 8) == 0:
      out("\t")
   else:
      space(spaces)


def out(c):
   print(c, end="")


def output(line):
   spaces = 0
   line = line[13:]
   for i in range(len(line)):
      c = line[i]
      if c == " ":
         #Keep tabs (ha ha) of the number of spaces seen.
         spaces = spaces + 1
         continue
      if c == "\t":
         raise Exception("Tab in input.")
      elif c == "/":
         #Tab before comment, and output the rest.
         tabify(i, spaces)
         print(line[i:])
         return
      elif i == 8:
         #Tab before instruction.
         tabify(i, spaces)
      else:
         #All other spaces remain as is.
         space(spaces)
      spaces = 0
      out(c)
   print("")


def skip():
   sys.stdin.readline()


if __name__ == "__main__":
   for line in sys.stdin:
      line = line.rstrip("\r\n")
      if re.compile(r'^/.*PAGE 1').match(line):
         skip()
      elif re.compile(r'^/.*PAGE [0-9]*$').match(line):
         skip()
         print("")
      elif re.compile(r'^/.*PAGE [0-9-]*$').match(line):
         skip()
      elif re.compile(r'').match(line):
         pass
      elif re.compile(r'[^/]*;.*').match(line):
         for i in range(line.count(";")):
            skip()
         output(line)
      else:
         output(line)
