# Formal Verification of the basic mux

Run
    
    sby -f config.sby

To make a proof that the ins, outs and bidirectionals are all connected correctly.

## Setup

* config.sby lists all the files needed for the verification.
* tt_top_formal.v instantiates tt_top.v and loops back the outputs and inputs
* tt_um_formal.v is a user project that asserts that when its enabled, the inputs are driven by the outputs
* p_wrapper.v is a replacement for p00, p01, p02, p03_wrapper.v that just instantiates tt_um_formal for each design

## Limitations

As the proof is made from the outside of the chip, we don't know the state of the bidirectional enables 
(without changing the RTL). To work around this, the user modules always set the bottom 4 bidir pins as output.
