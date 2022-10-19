# -*- coding: utf-8 -*-
"""
Created on Tue Oct 18 14:44:41 2022

from the matplotlib tutorial:
    https://matplotlib.org/stable/tutorials/introductory/images.html#sphx-glr-tutorials-introductory-images-py
This tutorial teaches the basics of reading an image in python.
"""

# connect IPython to a GUI event loop
%matplotlib

# import matplotlib plot interface as plt
import matplotlib.pyplot as plt

# import matplotlib image as mpimg
import matplotlib.image as mpimg

"""
# ----- test load bear image -----
# load Bear-morning-stretch image
# ./ looks in the current working directory
bearImage = mpimg.imread('./images/Bear-morning-stretch.jpg')
# display bear image
bearPlot = plt.imshow(bearImage)
# filter and display bear image
bearEdges = filters.sobel(bearImage)
io.imshow(bearEdges)
print(bearImage)
#---------------------------------
# anger... no cursor on lines already coded
"""

# import stinkbug image as a numpy array and print
img = mpimg.imread('./images/stinkbug.png')
print(img)

# plot the numpy array as an image
imgplot = plt.imshow(img)

# apply pseudocolor to the luminosity image
lum_img = img[:,:,0]
# plot the color image
imgplot = plt.imshow(lum_img)
# plot using a colormap
imgplot = plt.imshow(lum_img, cmap="hot")
# set colormap on existing plot
imgplot.set_cmap('nipy_spectral')
# color scale reference
plt.colorbar()

# plot histogram
plt.hist(lum_img, bins=256)
# contrast stretching
imgplot = plt.imshow(lum_img, clim=(0.0, 0.7))

# create a figure and change properties
fig = plt.figure()
ax = fig.add_subplot(1,2,1)
imgplot = plt.imshow(lum_img)
ax.set_title('Before')
plt.colorbar(orientation='horizontal')
ax = fig.add_subplot(1,2,2)
imgplot = plt.imshow(lum_img, clim=(0.0, 0.7))
ax.set_title('After')
plt.colorbar(orientation='horizontal')

# Interpolation
# import Image from PIL library
from PIL import Image
img = Image.open('./images/stinkbug.png')
# reduce size to 64x64
img.thumbnail((64, 64))
# default bilinear interpolation
imgplot = plt.imshow(img)
# nearest neighbor interpolation
implot = plt.imshow(img, interpolation="nearest")
# bicubic interpolation
# bicubic interpolation makes the image look blurry instead of pixelated
implot = plt.imshow(img, interpolation="bicubic")


  

