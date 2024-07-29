#!/usr/bin/env python3

# based on https://github.com/urish/tt07-charge-pump/blob/main/art/make_gds.py

import gdspy
from PIL import Image

# Open the image
img = Image.open("art/tt_logo.png")

LAYER = 134  # TopMetal2
DATATYPE_DRAWING = 0
DATATYPE_SLIT = 24
PIXEL_SIZE = 2.0 # um

# Convert the image to grayscale
img = img.convert("L")

slits = set()
for j in range(img.height//6):
    for i in range(img.width//10):
        if (i + j) % 2 == 0:
            slits.add((i, j))

layout = gdspy.Cell("tt_logo")
for y in range(img.height):
    for x in range(img.width):
        color = img.getpixel((x, y))
        # Adjust y-coordinate to flip the image vertically
        flipped_y = img.height - y - 1
        if color < 128:
            layout.add(
                gdspy.Rectangle((x * PIXEL_SIZE, flipped_y * PIXEL_SIZE),
                                ((x + 1) * PIXEL_SIZE, (flipped_y + 1) * PIXEL_SIZE),
                                layer=LAYER, datatype=DATATYPE_DRAWING))
        else:
            if 1 <= x % 10 <= 8 and 1 <= flipped_y % 6 <= 4:
                slits.discard((x//10, flipped_y//6))

for i, j in slits:
    layout.add(
        gdspy.Rectangle(((10 * i + 2) * PIXEL_SIZE, (6 * j + 2) * PIXEL_SIZE),
                        ((10 * i + 8) * PIXEL_SIZE, (6 * j + 4) * PIXEL_SIZE),
                        layer=LAYER, datatype=DATATYPE_SLIT))

# Save the layout to a file
gdspy.write_gds("gds/tt_logo.gds")
