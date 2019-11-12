`include "scpu.v"

module testBitSlicer();
  reg clk;
  reg reset;

  // Clock generation
  initial clk=0;
  always #10 clk = !clk;

  // Instantiate fake CPU
  SCPU pokmin(.clk(clk));

  // Filenames for memory images and VCD dump file
  reg [1023:0] mem_text_fn;
  reg [1023:0] mem_data_fn;
  reg [1023:0] dump_fn;
  reg init_data = 1;      // Initializing .data segment is optional

  initial begin

  	$readmemh(mem_text_fn, pokmin.memo.mem, 0);
          if (init_data) begin
  	    $readmemh(mem_data_fn, pokmin.memo.mem, 2048);
          end

  	// Dump waveforms to file
  	// Note: arrays (e.g. memory) are not dumped by default
  	$dumpfile(dump_fn);
  	$dumpvars();

  	// Assert reset pulse

  	// End execution after some time delay - adjust to match your program
  	// or use a smarter approach like looking for an exit syscall or the
  	// PC to be the value of the last instruction in your program.
  	#2000 $finish();
      end

  endmodule
