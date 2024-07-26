#!/usr/bin/env python3

# based on https://github.com/urish/tt07-charge-pump/blob/main/art/make_gds.py

import gdspy
from PIL import Image

# Open the image
img = Image.open("art/tt_logo.png")

LAYER = 134  # TopMetal2
DATATYPE = 0 # drawing
PIXEL_SIZE = 2.0 # um

# Convert the image to grayscale
img = img.convert("L")

layout = gdspy.Cell("tt_logo")
for y in range(img.height):
    for x in range(img.width):
        color = img.getpixel((x, y))
        if color < 128:
            # Adjust y-coordinate to flip the image vertically
            flipped_y = img.height - y - 1
            layout.add(
                gdspy.Rectangle((x * PIXEL_SIZE, flipped_y * PIXEL_SIZE),
                                ((x + 1) * PIXEL_SIZE, (flipped_y + 1) * PIXEL_SIZE),
                                layer=LAYER, datatype=DATATYPE))

# Save the layout to a file
gdspy.write_gds("gds/tt_logo.gds")
