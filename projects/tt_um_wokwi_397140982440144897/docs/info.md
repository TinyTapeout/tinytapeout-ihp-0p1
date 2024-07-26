## How it works

The logic to light the characters appears in the bottom half of the simulation window. The top half of the simulation window implements a modulo-12 counter. In other words, the counter increments up to 11 then resets. This counter is used to determine which character we should output to the 7-segment display. The truth table for the design can be found in the [Design Spreadsheet](https://docs.google.com/spreadsheets/d/1-h9pBYtuxv6su2EC8qBc6nX_JqHXks6Gx5nmHFQh_30/edit).

## How to test

Turn all pins OFF, keep the clock running and watch the rolling text on the 7-segment display. Or turn pin 3 ON and manually select a letter using pins 4 to 7.

## External hardware

None
