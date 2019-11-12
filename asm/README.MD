# Basic Operations Tests
These are a set of tests that will test each of the required instructions, in successions. They are meant to act as 'unit tests'. Because some of these tests require other instructions, they are to be run in a specific order:
 - `ADDI` test: `$a0` will be set to 1.
 - `ADD` test: `$a2` will be set to 3.
 - `SUB` test: `$a2` will be set to -1.
 - `J` test: `$a2` will be set to 1.
 - `BEQ` test: `$a2` will be set to 2.
 - `BNE` test: `$a2` will be set to 1.
 - `SLT` test: `$a2` will be set to 1.
 - `SW` test: Stores 1 at the memory index 0x2000.
 - `LW` test: `$a0` will be set to 1.
 - `XORI` test: `$a2` will be set to 0. `$a3` will be non zero.
 - `JR`/`JAL` test: `$a2` will be set to 4.

# Greatest Common Denominator in Assembly

This test calculates the greatest common divisor of the two values stored at `$a0` and `a1` and stores it in `$v0`.

A definition of greatest common divisor [from Wikipedia](https://en.wikipedia.org/wiki/Greatest_common_divisor):
> In mathematics, the greatest common divisor (gcd) of two or more integers, which are not all zero, is the largest positive integer that divides each of the integers.:  

Additionally, **`$a0`and $a1 should be any integer**.

## Example Expected Results:
| `$a0` | `$a1` | `$v0` |
|-------|-------|-------|
| `d20` | `d34` | `d2`  |
| `d10` | `d12` | `d2`  |
| `d20` | `d15` | `d5`  |
| `d24` | `d16` | `d8`  |
| `d36` | `d12` | `d12` |
## Instructions Used
No additional instructions beyond the lab requirements need to be implemented. Specifically, the following instructions are used by this test case:

- `sub`
- `add`
- `addi`
- `j`
- `beq`
- `blt`


# Recursive Insertion Sort In Place in Assembly

This test instantiates an array of length 6 in the memory, and then uses a recursive insertion sort algorithm to sort the array in place in ascending order. 

The logic for the recusive sort algorithm can be seen [here](https://www.geeksforgeeks.org/recursive-insertion-sort/).

## Input Array:
| Memory Index | 0x2000 | 0x2004 | 0x2008 | 0x200c | 0x2010 |0x2014 |
|-------|-------|-------|-------|-------|-------|-------|
| Array Value | 20 | 16 | 12 | 8 | 4 | 0 |

## Output:
The test automatically checks if the sorting worked as desired. It will traverse the array in order, and check if each value is smaller than the next one. If the test passes, the `$t4` register is set to 0. If it failed, `$t4` is non zero.

### Array state:
| Memory Index | 0x2000 | 0x2004 | 0x2008 | 0x200c | 0x2010 |0x2014 |
|-------|-------|-------|-------|-------|-------|-------|
| Array Value | 0 | 4 | 8 | 12 | 16 | 20 |

## Instructions Used
This test uses all of the lab's required istructions - additional instructions beyond the lab requirements need to be implemented. Specifically, the following instructions are used:
 - `SLT`
 - `SUB`
 - `ADD`
 - `ADDI`
 - `XORI`
 - `BNE`
 - `BEQ`
 - `JAL`
 - `JR`
 - `J`
 - `SW`
 - `LW`
