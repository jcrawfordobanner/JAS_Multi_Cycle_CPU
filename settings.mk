# Project-specific settings

## Assembly settings

# Assembly program (minus .asm extension)
# PROGRAM := insert_test/insert_sort
PROGRAM := basic_op_tests/addi_test

# Memory image(s) to create from the assembly program
TEXTMEMDUMP := $(PROGRAM).text.hex
DATAMEMDUMP := $(PROGRAM).data.hex


## Verilog settings

# Top-level module/filename (minus .v/.t.v extension)
TOPLEVEL := mcpu

# All circuits included by the toplevel $(TOPLEVEL).t.v
CIRCUITS := $(TOPLEVEL).v IFU.v memory.v alu.v regfile.v register.v LUT_biggie.v mux4.v concat.v
