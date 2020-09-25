import sys
import os
import re

class Colors():
    BRED = '\033[91m'
    BBLUE = '\033[94m'
    BCYAN = '\033[96m'
    BYELLOW = '\033[93m'
    BGREEN = '\033[92m'
    BWHITE = '\033[97m'

    RED = '\033[31m'
    BLUE = '\033[34m'
    CYAN = '\033[36m'
    YELLOW = '\033[33m'
    GREEN = '\033[32m'
    WHITE = '\033[37m'

    ULINE = '\033[4m'
    END = '\033[0m'

class Printer():

    def __init__(self):
        self.c = Colors()

    def wrt(self, line):
        sys.stdout.write(line + self.c.END)
        sys.stdout.flush()

    def interpolate(self, line):
        c = self.c

        if line == 'Automatic pdb calling has been turned ON\n':
            exit(0)

        if 'DEBUG/MainProcess' in line:
            return

        if re.match(r'^=*$|^-*$', line):
            self.wrt(c.CYAN + line)

        elif '!@#' in line:
            self.wrt(c.BYELLOW + line)

        elif 'Error submitting packet:' in line:
            self.wrt(c.YELLOW + line)

        elif re.match(r'ERROR: .*$|FAIL: .*', line):
            line = line.split(' ', 1)
            self.wrt('{} {}'.format(c.RED + line[0], c.BYELLOW + line[1]))

        elif line.startswith('Traceback'):
            self.wrt(c.GREEN + line)

        elif re.match(r'.*File ".*$', line):
            '''File <File Path>, line <num>, in <func>'''
            line = line.split(' ')
            line.extend([''] * (8 - len(line)))
            self.wrt('  {} {} {} {} {} {}'.format(c.BYELLOW + line[2], c.BCYAN + line[3],
                                                  c.BYELLOW + line[4], c.BCYAN + line[5],
                                                  c.BYELLOW + line[6], c.BCYAN + line[7]))

        elif re.match(r'^.+Error: .*|^.+Exception: .*', line):
            line = line.split(' ', 1)
            self.wrt('{} {}'.format(c.ULINE + c.BWHITE +line[0] + c.END, c.GREEN + line[1]))

        elif line.startswith('-'):
            # may not work due to - regex
            self.wrt(c.GREEN + line)

        elif line.startswith('+'):
            self.wrt(c.BRED + line)

        elif re.match(r'^[.EF]*$', line):
            for ch in line:
                if ch == '.':
                    self.wrt(c.BGREEN + ch)
                else:
                    self.wrt(c.RED + ch)

        elif re.match(r'^OK$', line):
            self.wrt(c.BGREEN + line)

        elif re.match(r'^FAILED .*$|ERROR .*$', line):
            self.wrt(c.RED + line)

        else:
            self.wrt(c.BWHITE + line)
        return


printer = Printer()
line = ""

while True:
    char = os.read(0,1)
    line += char
    if line == "":
        break
    if char == '\n':
        printer.interpolate(line)
        line = ""

