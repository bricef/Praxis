#!/usr/bin/env python

import random
from PIL import Image, ImageChops, ImageFilter

mymap = Image.new("L", (255,255), color=0xffffff)

def randsize(offset=(0,0)):
    return (random.randint(1,mymap.size[0])+offset[0], random.randint(1,mymap.size[1])+offset[1])


files = [x.strip() for x in open("pngfiles.txt", "r").readlines()]

for i in range(100):
    filename = random.choice(files)
    try:
      print(filename)
      im = Image.open(filename)
      im = im.convert("L")
      im = im.rotate(random.randint(0,360)).resize(randsize())
      tmpmap = Image.new("L", mymap.size, "white")
      mymap.paste(im, randsize(offset=(-255/2,-255/2)), im)
      #mymap = ImageChops.blend(mymap,tmpmap,1)
    except IOError as err:
      print("[Error]: could not process %s"%filename)
    
#mymap = mymap.convert("L")
mymap = mymap.filter(ImageFilter.BLUR)
mymap = mymap.filter(ImageFilter.SMOOTH)

pix = mymap.load()

heightmap = [[0 for y in range(mymap.size[1])] for x in range(mymap.size[0])]

for x in range(mymap.size[0]):
  for y in range(mymap.size[1]):
    #print(pix[x,y])
    pass

mymap.show()
