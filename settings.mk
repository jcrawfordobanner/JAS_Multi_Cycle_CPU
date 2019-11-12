# Project-specific settings

## Assembly settings

# Assembly program (minus .asm extension)
PROGRAM := insert_test/insert_sort
# PROGRAM := basic_op_tests/jaljr_test

# Memory image(s) to create from the assembly program
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex


## Verilog settings

# Top-level module/filename (minus .v/.t.v extension)
TOPLEVEL := scpu

# All circuits included by the toplevel $(TOPLEVEL).t.v
CIRCUITS := $(TOPLEVEL).v IFU.v memory.v LUT.v alu.v regfile.v
