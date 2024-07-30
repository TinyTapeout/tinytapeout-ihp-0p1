#!/usr/bin/env python3

import pya
import sys

tech_dir = 'IHP-Open-PDK/ihp-sg13g2/libs.tech/klayout'
results_dir = "results/ihp-sg13g2/tt-chip/base"
input_gds = sys.argv[1] if len(sys.argv) >=2 else f"{results_dir}/6_final.gds"
output_gds = input_gds.replace('.gds', '_seal.gds')

sys.path.append(f'{tech_dir}/python')
import sg13g2_pycell_lib
assert 'SG13_dev' in pya.Library.library_names()

layout = pya.Layout()
if input_gds is not None:
    layout.read(input_gds)
    top = layout.top_cell()

sealring_pcell = layout.create_cell('sealring', 'SG13_dev', {'l': '2150u', 'w': '2150u'})
sealring_pcell_i = sealring_pcell.cell_index()
sealring_static_i = layout.convert_cell_to_static(sealring_pcell_i)
sealring_static = layout.cell(sealring_static_i)
layout.delete_cell(sealring_pcell_i)
layout.rename_cell(sealring_static_i, 'sealring')

if input_gds is not None:
    top.insert(pya.CellInstArray(sealring_static, pya.Trans(0, 0)))

layout.write(output_gds)

