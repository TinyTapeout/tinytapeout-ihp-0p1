#!/usr/bin/env python3

# fill generator inspired by https://github.com/IHP-GmbH/IHP-Open-DesignLib/tree/main/U_Hawaii_EE628_Spring_2024

import pya

results_dir = "results/ihp-sg13g2/tt-chip/base"
input_gds = f"{results_dir}/6_final.gds"
output_gds = f"{results_dir}/6_final_fill.gds"

die_size = (2200, 2200)
die_margin = 36
layer_map = {
    "Activ": (1, 0),
    "GatPoly": (5, 0),
    "NWell": (31, 0),
    "Metal1": (8, 0),
    "Metal2": (10, 0),
    "Metal3": (30, 0),
    "Metal4": (50, 0),
    "Metal5": (67, 0),
}
fill_groups = [
    ("Activ, GatPoly & NWell", "Activ", 6, 8, [("Activ", 4), ("GatPoly", 4), ("NWell", 5)]),
    ("Metal1 (first round)", "Metal1_L", 6, 0.5, [("Metal1", 5)]),
    ("Metal1 (second round)", "Metal1_S", 1.5, 0.125, [("Metal1", 1.25)]),
    ("Metal2 (first round)", "Metal2_L", 6, 0.5, [("Metal2", 5)]),
    ("Metal2 (second round)", "Metal2_S", 1.5, 0.125, [("Metal2", 1.25)]),
    ("Metal3 (first round)", "Metal3_L", 6, 0.5, [("Metal3", 5)]),
    ("Metal3 (second round)", "Metal3_S", 1.5, 0.125, [("Metal3", 1.25)]),
    ("Metal4 (first round)", "Metal4_L", 6, 0.5, [("Metal4", 4)]),
    ("Metal4 (second round)", "Metal4_S", 1.5, 0.125, [("Metal4", 1)]),
    ("Metal5 (first round)", "Metal5_L", 6, 0.5, [("Metal5", 4)]),
    ("Metal5 (second round)", "Metal5_S", 1.5, 0.125, [("Metal5", 1)]),
]
fill_exclude = [
    ('dfpad', (41, 0)),
]

layout = pya.Layout()
layout.read(input_gds)
top = layout.top_cell()
u = round(1/layout.dbu)

fill_box = pya.Box(die_margin*u, die_margin*u, (die_size[0]-die_margin)*u, (die_size[1]-die_margin)*u)

fill_region_init = pya.Region(fill_box)
for layer_name, (layer, datatype) in fill_exclude:
    layer_index = layout.layer(layer, datatype)
    exclude_region = pya.Region(top.begin_shapes_rec(layer_index))
    fill_region_init -= exclude_region

for group_desc, group_name, grid, spacing, layers in fill_groups:
    print(f"Generating fill for {group_desc}...")
    cell_index = layout.add_cell(f"FILL_{group_name}")
    cell_obj = layout.cell(cell_index)
    fill_region = fill_region_init.dup()
    for layer_name, size in layers:
        layer, datatype = layer_map[layer_name]
        layer_index = layout.layer(layer, datatype)
        shape_box = pya.Box((grid-size)*u//2, (grid-size)*u//2, ((grid+size)*u+1)//2, ((grid+size)*u+1)//2)
        cell_obj.shapes(layer_index).insert(shape_box)
        exclude_region = pya.Region(top.begin_shapes_rec(layer_index))
        fill_region -= exclude_region
    cell_box = pya.Box(-spacing*u, -spacing*u, (grid+spacing)*u, (grid+spacing)*u)
    row_step = pya.Vector(grid*u, 0)
    column_step = pya.Vector(0, grid*u)
    origin = pya.Point(-spacing*u, -spacing*u)
    fill_margin = pya.Vector(0, 0)
    top.fill_region(fill_region, cell_index, cell_box, row_step, column_step, origin, fill_region, fill_margin, None)

layout.write(output_gds)

