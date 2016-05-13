from os import listdir
from os.path import isfile, isdir, join
import os
import shutil
import imghdr
from PIL import Image
from random import shuffle

# Models
models = ['Citaro', 'Colorado', 'R8']

# Image paths
# (source_path_list, destination_path)
paths = [
    (['raw/audir8-2',
      'raw/audir8-3',
      'raw/audir8-4',
      'raw/audir8-5',
      'raw/audir8-6',
      'raw/audir8-7'],
     'train/R8/'),

    (['raw/ciatro-1',
      'raw/ciatro-2'],
     'train/Citaro/'),

    (['raw/colorado-1',
      'raw/colorado-2'],
     'train/Colorado/')
]

# Image size
size = 256

for srcs, dst in paths:
    print 'Building data set in %s' % dst
    if isdir(dst):
        shutil.rmtree(dst)

    os.makedirs(dst)

    files = [join(src, f)
             for src in srcs
             for f in listdir(src)
             if isfile(join(src, f))]

    i = 0
    for fname in files:
        try:
            img = Image.open(fname)
            width, height = img.size
            if width > height:
                height = int(float(height) / float(width) * size)
                width = size
            else:
                width = int(float(width) / float(height) * size)
                height = size

            ext = imghdr.what(fname) or 'jpeg'
            resized = img.resize((width, height), Image.ANTIALIAS)
            resized.save(dst + str(i).zfill(5) + '.' + ext)
            i += 1
        except IOError:
            print "Cannot create copy for %s" % fname

# Labeling
data = [(model, 'train/' + model) for model in models]
pairs = [join(src[1], f) + ' ' + src[0]
         for src in data
         for f in listdir(src[1])
         if isfile(join(src[1], f))]

shuffle(pairs)

label = open('train/labels.txt', 'w')
label.write('\n'.join(models))
label.close()

train = open('train/train.txt', 'w')
train.write('\n'.join(pairs))
train.close()
