#!/usr/bin/env python3

# simple fill generator inspired by https://github.com/IHP-GmbH/IHP-Open-DesignLib/tree/main/U_Hawaii_EE628_Spring_2024

import pya

results_dir = "results/ihp-sg13g2/tt-chip/base"
input_gds = f"{results_dir}/6_final.gds"
output_gds = f"{results_dir}/6_final_fill.gds"

die_size = (2200, 2200)
die_margin = 36
fill_grid = 6
fill_spacing = 6
fill_groups = [
    [("Activ", (1, 0), 4),
    ("GatPoly", (5, 0), 4),
    ("NWell", (31, 0), 5)],
    [("Metal1", (8, 0), 4)],
    [("Metal2", (10, 0), 4)],
    [("Metal3", (30, 0), 4)],
    [("Metal4", (50, 0), 4)],
    [("Metal5", (67, 0), 4)],
]

layout = pya.Layout()
layout.read(input_gds)
top = layout.top_cell()
u = round(1/layout.dbu)

fill_box = pya.Box(die_margin*u, die_margin*u, (die_size[0]-die_margin)*u, (die_size[1]-die_margin)*u)
shift_box = pya.Box(-fill_grid*u//2, -fill_grid*u//2, (fill_grid*u+1)//2, (fill_grid*u+1)//2)
fill_margin = pya.Vector(fill_spacing*u, fill_spacing*u)
fill_origin = pya.Point(0, 0)

for fill_layers in fill_groups:
    layer_list = [layer_name for layer_name, *_ in fill_layers]
    print(f"Generating fill for {' & '.join(layer_list)}...")
    cell_index = layout.add_cell(f"FILL_{layer_list[0]}")
    cell_obj = layout.cell(cell_index)
    fill_region = pya.Region(fill_box)
    for layer_name, (layer, datatype), size in fill_layers:
        layer_index = layout.layer(layer, datatype)
        cell_obj.shapes(layer_index).insert(pya.Box(-size*u//2, -size*u//2, (size*u+1)//2, (size*u+1)//2))
        exclude_region = pya.Region(top.begin_shapes_rec(layer_index))
        fill_region -= exclude_region
    top.fill_region(fill_region, cell_index, shift_box, fill_origin, fill_region, fill_margin, None)

layout.write(output_gds)

