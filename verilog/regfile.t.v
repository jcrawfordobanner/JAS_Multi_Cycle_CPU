//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion 
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
	 integer 		i = 0;
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Example Test Case 1:
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Example Test Case 1 Failed");
  end

  // Example Test Case 2:
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Exmaple Test Case 2 Failed");
  end

	// Test Case 1:
  // Test if the enable signal is working
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 0;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Test Case 1 Failed");
  end

	// Test Case 2:
  // Test if the decoder is working
  WriteRegister = 5'd3;
  WriteData = 32'd25;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 === 25) || (ReadData2 === 25)) begin
     dutpassed = 0;
     $display("Test Case 2 Failed: Decoder writing to everything");
  end else if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
     dutpassed = 0;
     $display("Test Case 2 Failed: General failure.");
  end

	// Test Case 3:
  // Test if the zero register is working well
  WriteRegister = 5'd0;
  WriteData = 32'd25;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
     dutpassed = 0;
     $display("Test Case 3 Failed: Zero register actually taking in some input");
  end

	// Test Case 4:
  // Test if all the other registers are okay
		 for (i=1;i<32;i=i+1) begin
				WriteRegister = i;
				WriteData = 32'd25;
				RegWrite = 1;
				ReadRegister1 = i;
				ReadRegister2 = i;
				#5 Clk=1; #5 Clk=0;

				if((ReadData1 !== 25) || (ReadData2 !== 25)) begin
					 dutpassed = 0;
					 $display("Test Case 4 Failed: Register failing to recognize input");
					 $display("Register number: %b", i);
				end

				WriteRegister = i;
				WriteData = 32'd323;
				RegWrite = 1;
				ReadRegister1 = i;
				ReadRegister2 = i;
				#5 Clk=1; #5 Clk=0;

				if((ReadData1 !== 323) || (ReadData2 !== 323)) begin
					 dutpassed = 0;
					 $display("Test Case 4 Failed: Register failing to recognize changed input");
					 $display("Register number: %b", i);
				end
 		 end // for (i=1; i<32; i=i+1)

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
