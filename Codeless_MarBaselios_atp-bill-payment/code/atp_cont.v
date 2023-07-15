module atp_cont(
input wire clk,
input wire reset,
input wire confirm,
input wire [15:0] direct_amount, //input from dd,cheque
input wire [2:0] cashmethod, // notes inserted
input wire [1:0] payment_method, //cash,cheque,dd
input wire [15:0] bill_amount,
input wire invalid, //checks for validity of inputs
output reg [15:0] prepaid_amount, //next cycle adjustment
output reg [15:0] input_amount, //total input amount
output reg [15:0] updated_amount, //new bill amount if not completely paid
output reg bill_receipt //receipt generation
);


initial
begin
	prepaid_amount<=16'd000;
	input_amount <= 16'd000;
	updated_amount <= 16'd000;
	bill_receipt <= 1'b0;
end


always @(negedge clk or posedge reset)
begin
	if(reset)
	begin
		input_amount <= 16'd000;
		bill_receipt <= 1'b0;
	end
	else if(confirm) //
	begin
		if((input_amount +prepaid_amount) >= bill_amount) //full amount paid
		begin
			prepaid_amount <= input_amount + prepaid_amount - bill_amount +16'd0;//adjustment in next cycle
			updated_amount <= 16'd0;
		end
		else //bill not completely paid
		begin
			updated_amount <= bill_amount - input_amount - prepaid_amount + 16'd0;//new bill
			prepaid_amount <= 16'd0;
		end
		bill_receipt <= 1'b1; //receipt generated
	end
	else
	begin
		
			if(payment_method == 2'b00 & !invalid)//cash + torn or invalid note check
			begin 
		
					if (cashmethod == 3'b000) //10 rs
					begin
						input_amount <= input_amount + 16'd10;
					end
					if (cashmethod == 3'b001) //20 rs
					begin
						input_amount <= input_amount + 16'd20;
					end
					if (cashmethod == 3'b010) //50 rs
					begin
						input_amount <= input_amount + 16'd50;
					end
					if (cashmethod == 3'b011) //100 rs
					begin
						input_amount <= input_amount + 16'd100;
					end
					if (cashmethod == 3'b100) //200 rs
					begin
						input_amount <= input_amount + 16'd200;
					end
					if (cashmethod == 3'b101) //500 rs
					begin
						input_amount <= input_amount + 16'd500;
					end
			end
			else if(payment_method == 2'b01) //cheque
			begin 
				input_amount <= direct_amount + 16'd0;
				if(invalid)
					input_amount <= 16'd0;
			end
			else if(payment_method == 2'b10) //dd
			begin 
				input_amount <= direct_amount + 16'd0;
				if(invalid)
					input_amount <= 16'd0;
			end
			else if(payment_method == 2'b11) //do nothing
			begin 
			end
	end
end
endmodule
