# VOCAL

### Vertical Orthographic Conveyance Automation Language

Vocal is *heavily* influenced by [ROCB](https://esolangs.org/wiki/RubE_On_Conveyor_Belts). 
It does away with the control program, however, and only has the main program.

## Overview

A program in Vocal comprises a two-dimensional grid.

## Examples



```
$*Z

>>.
```

## Links

## Cells

Below is a table of all cells in Vocal. They are listed in order or priority.

| Name | Characters | Description |
| ---- | ---------- | ----------- |
| Arg Input    | `$`, `α` | If there is room beneath this cell, and there are any command-line arguments left, it will pop the first command line argument into a value beneath it. |
| Direct Input | `£`, `Ϟ` | If this is "activated" (there's a dynamic entity in the cell above it), then it will request an input from the user. This input is currently `eval`-ed, and so numbers are interpreted correctly, but strings need to be quoted. | 
| Scanner      | `*`      | If a value occupies the cell beneath this, it will output the value. |
| Discarder    | `Z`, `Ω` | If a value occupies any of the surrounding cells (including diagonally) it is deleted. |
| Adder        | `+`, `∑` | If there is a value below this cell, and another to the left of that, and an empty space to their right, then they are both deleted, and their sum is inserted into the cell below and to the right of this one. |
| Subtracter   | `-`, `∂` | Same as the adder, but with subtraction. |
| Belt         | `>`, `»` | If there is a dynamic entity on top of this cell, and the adjacent cell in the appropriate direction is empty, then the dynamic entity will be conveyed along. |
|              | `<`, `«` |  |
| Ramp         | `/`, `л` | If a dynamic entity lands on a ramp it will be pushed to the side as it falls. |
|              | `\`, `ι` | Also, if a dynamic entity is pushed sideways into the correct side of a ramp, it will be pushed up on top of it. |
| Counter      | `@`, `©` | If a value occupies the cell beneath this, and it's numeric, it will decrement it by one. If it reaches 0, it will be deleted on that tick (so it will never be 0). |

## Future Ideas

