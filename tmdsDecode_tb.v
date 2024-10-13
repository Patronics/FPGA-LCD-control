`timescale 1ns / 1ps

module tmdsDecode_tb;

  // Inputs
  reg [9:0] inBits;

  // Outputs
  wire [7:0] color;
  wire isControlSignal;
  wire [1:0] controlType;

  // Instantiate the Unit Under Test (UUT)
  tmdsDecode uut (
    .inBits(inBits), 
    .color(color), 
    .isControlSignal(isControlSignal), 
    .controlType(controlType)
  );

  // Test initialization and stimulus
  initial begin
    // Open dumpfile for waveform viewing
    $dumpfile("tmdsDecode_tb.vcd");
    $dumpvars(0, tmdsDecode_tb);

    // Initialize inputs
    inBits = 10'b0000000000; // Default reset state

    // Wait 100 ns for global reset to finish
    #100;

    // Apply test cases
    // Test case 1: Regular pixel data (Example value)
    inBits = 10'b0110101011; // Example input representing pixel data
    #50; // Wait for the output to settle

    // Test case 2: Control signal (Example control signal input)
    inBits = 10'b1101010101; // Example input representing a control signal
    #50;

    // Test case 3: Another pixel value for verification
    inBits = 10'b1010101010; // Another example pixel data input
    #50;

    // Test case 4: Control signal (Edge case)
    inBits = 10'b1111111111; // Edge case control signal
    #50;

    // Finish simulation after some time
    #100;
    $finish;
  end

endmodule