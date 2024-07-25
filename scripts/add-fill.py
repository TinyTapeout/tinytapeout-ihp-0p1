#!/usr/bin/env python3

# simple fill generator inspired by https://github.com/IHP-GmbH/IHP-Open-DesignLib/tree/main/U_Hawaii_EE628_Spring_2024

import pya

results_dir = "results/ihp-sg13g2/tt-chip/base"
input_gds = f"{results_dir}/6_final.gds"
output_gds = f"{results_dir}/6_final_fill.gds"

die_size = (2200, 2200)
die_margin = 36
fill_grid = 6
fill_groups = [
    ([("Activ", (1, 0), 4),
      ("GatPoly", (5, 0), 4),
      ("NWell", (31, 0), 5)], 8),
    ([("Metal1", (8, 0), 5)], 2),
    ([("Metal2", (10, 0), 5)], 2),
    ([("Metal3", (30, 0), 5)], 2),
    ([("Metal4", (50, 0), 5)], 2),
    ([("Metal5", (67, 0), 5)], 2),
]
fill_exclude = [
    ('dfpad', (41, 0)),
]

layout = pya.Layout()
layout.read(input_gds)
top = layout.top_cell()
u = round(1/layout.dbu)

fill_box = pya.Box(die_margin*u, die_margin*u, (die_size[0]-die_margin)*u, (die_size[1]-die_margin)*u)
row_step = pya.Vector(fill_grid*u, 0)
column_step = pya.Vector(0, fill_grid*u)
fill_margin = pya.Vector(0, 0)
fill_origin = pya.Point(0, 0)

fill_region_init = pya.Region(fill_box)
for layer_name, (layer, datatype) in fill_exclude:
    layer_index = layout.layer(layer, datatype)
    exclude_region = pya.Region(top.begin_shapes_rec(layer_index))
    fill_region_init -= exclude_region

for fill_layers, fill_spacing in fill_groups:
    layer_list = [layer_name for layer_name, *_ in fill_layers]
    print(f"Generating fill for {' & '.join(layer_list)}...")
    cell_index = layout.add_cell(f"FILL_{layer_list[0]}")
    cell_obj = layout.cell(cell_index)
    cell_box = pya.Box(-fill_grid*u//2-fill_spacing*u, -fill_grid*u//2-fill_spacing*u,
                       (fill_grid*u+1)//2+fill_spacing*u, (fill_grid*u+1)//2+fill_spacing*u)
    fill_region = fill_region_init.dup()
    for layer_name, (layer, datatype), size in fill_layers:
        layer_index = layout.layer(layer, datatype)
        cell_obj.shapes(layer_index).insert(pya.Box(-size*u//2, -size*u//2, (size*u+1)//2, (size*u+1)//2))
        exclude_region = pya.Region(top.begin_shapes_rec(layer_index))
        fill_region -= exclude_region
    top.fill_region(fill_region, cell_index, cell_box, row_step, column_step, fill_origin, fill_region, fill_margin, None)

layout.write(output_gds)

