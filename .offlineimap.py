import os

def get_pass(keyfile):
    return os.popen("scripts/gd " + keyfile).read().strip()
