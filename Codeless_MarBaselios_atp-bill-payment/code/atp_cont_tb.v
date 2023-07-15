module atp_cont_tb;

  // Inputs
  reg clk;
  reg reset;
  reg confirm,invalid;
  reg [2:0] cashmethod;
  reg [1:0] payment_method;
  reg [15:0] bill_amount;
  reg [15:0] direct_amount;
  
  
  

  // Outputs
  wire [15:0] prepaid_amount;
  wire [15:0] input_amount;
  wire [15:0] updated_amount;
  wire bill_receipt;

  // Instantiate the module under test
  atp_cont uut (
    .clk(clk),
    .reset(reset),
	 .invalid(invalid),
    .confirm(confirm),
    .cashmethod(cashmethod),
    .payment_method(payment_method),
    .bill_amount(bill_amount),
    .prepaid_amount(prepaid_amount),
    .input_amount(input_amount),
    .bill_receipt(bill_receipt),
	 .updated_amount(updated_amount),
	 .direct_amount(direct_amount)
  );

  // Clock generation
  always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    reset = 1;
    confirm = 0;
    cashmethod = 3'b000; 
    payment_method = 2'b00;//cash
    bill_amount = 16'd100; //bill 100rs

    // Wait for a few clock cycles
    #10;

    // Deassert reset
    reset = 0;
	 cashmethod = 3'b010; //50rs
	 invalid = 1'b0; 

    // Wait for a few clock cycles
    #10;
	 
	 cashmethod = 3'b010; //50rs
	 invalid = 1'b0;
	 
	 #10;
	 
	 cashmethod = 3'b100; //200rs
	 invalid = 1'b1; //invalid note
	 
	 #10;
	 
	 cashmethod = 3'b011; //100rs
	 invalid = 1'b0;
	 
	 #10;
	 
	 confirm = 1'b1;//completed input
	 

    #10;
	 reset =1;
	 confirm = 1'b0;
	 
	 #10
	 reset = 0;
	 bill_amount = 16'd120; //120rs bill
	 payment_method = 2'b01; //cheque
	 direct_amount = 16'd40; //cheque amount value
	 invalid = 1'b0; //valid
	 
	 
	 
	 #10
	 
	 
	 confirm = 1'b1;
	 
	 #10;
	 reset =1;
	 confirm = 1'b0;
	 
	 #10;
	 
	 #10
	 reset = 0;
	 bill_amount = 16'd300; //300rs bill
	 payment_method = 2'b01; //dd
	 direct_amount = 16'd40; //dd amount value
	 invalid = 1'b0; //valid
	 
	 
	 
	 #10
	 
	 
	 confirm = 1'b1;
	 
	 #10;
	 reset =1;
	 confirm = 1'b0;
	 
	 #10;
	 

    // End simulation
    $finish;
  end

endmodule