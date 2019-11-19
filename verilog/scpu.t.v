`include "scpu.v"

//------------------------------------------------------------------------
// All out CPU test bench
//------------------------------------------------------------------------

module cpu_test ();

   reg clk;
   reg reset;

   // Clock generation
   initial clk=0;
   always #10 clk = !clk;

   // Instantiate fake CPU
   SCPU cpu(.clk(clk), .reset(reset));

   // Filenames for memory images and VCD dump file
   reg [1023:0] mem_text_fn;
   reg [1023:0] mem_data_fn;
   reg [1023:0] dump_fn;
   reg 					init_data = 0;      // Initializing .data segment is optional

   // Test sequence
   initial begin

			// Get command line arguments for memory image(s) and VCD dump file
			//   http://iverilog.wikia.com/wiki/Simulation
			//   http://www.project-veripage.com/plusarg.php
			if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
				 $display("ERROR: provide +mem_text_fn=[path to .text memory image] argument");
				 $finish();
      end
			if (! $value$plusargs("mem_data_fn=%s", mem_data_fn)) begin
				 $display("INFO: +mem_data_fn=[path to .data memory image] argument not provided; data memory segment uninitialized");
				 init_data = 0;
      end

			if (! $value$plusargs("dump_fn=%s", dump_fn)) begin
				 $display("ERROR: provide +dump_fn=[path for VCD dump] argument");
				 $finish();
      end


      // Load CPU memory from (assembly) dump files
      // Assumes compact memory map, _word_ addressed memory implementation
      //   -> .text segment starts at word address 0
      //   -> .data segment starts at word address 2048 (byte address 0x2000)
			$readmemh(mem_text_fn, cpu.memo.mem, 0);
      if (init_data) begin
				 $readmemh(mem_data_fn, cpu.memo.mem, 2048);
      end

			// Dump waveforms to file
			// Note: arrays (e.g. memory) are not dumped by default
			$dumpfile("dumpfile.vcd");
			$dumpvars();

			// Assert reset pulse
			reset = 0; #20;
			reset = 1; #20;
			reset = 0;

			// Display a few cycles just for quick checking
			// Note: I'm just dumping instruction bits, but you can do some
			// self-checking test cases based on your CPU and program and
			// automatically fake_cpufake_cpureport the results.
			$display("Time | PC       | Instruction | data_addr");
			repeat(20) begin
         $display("%4t | %h | %h    | %h", $time, cpu.pcout, cpu.irout, cpu.memo.data_addr); #10 ;
      end
			$display("... more execution (see waveform)");

			// End execution after some time delay - adjust to match your program
			// or use a smarter approach like looking for an exit syscall or the
			// PC to be the value of the last instruction in your program.
			#20000;
			$display("%4t | %h | %h | %h", $time, cpu.pcout, cpu.irout, cpu.regf.gen1[2].greg.q); #20 ;
 $finish();
   end

endmodule
