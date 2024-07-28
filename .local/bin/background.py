#!/usr/bin/env python3

import random
import subprocess

from os import listdir
from os.path import isfile, join, expanduser, isdir

def filter(string, substring):
    return [s for s in string if any(sub in s.lower() for sub in substring)]


home = expanduser("~")
fixpath = home + "/nextcloud-backup/Wallpaper"
imgdirs = ["others", "alphacoders", "elden_ring", "nobunaga", "nexus",
           "cirno", "lodoss", "kancolle", "lies_of_p", "ships", "eiyuden_chronicles"]
imgpaths = [join(fixpath, p) for p in imgdirs]

for imgpath in imgpaths:
    imgpaths += [join(imgpath, p) for p in listdir(imgpath) if isdir(join(imgpath, p))]

imgpaths.sort()

images = []

for imgpath in imgpaths:
    images += [join(imgpath, f) for f in listdir(imgpath) if isfile(join(imgpath, f))]

images = filter(images, [".jpg", ".png", ".jpeg"])

image = random.choice(images)

feh = "feh --bg-fill " + image
wal = "wallust run " + image

if __name__ == "__main__":
    subprocess.run(feh, shell=True)
    subprocess.run(wal, shell=True)
