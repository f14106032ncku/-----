module branch_prediction(
    input clk,               // Clock signal
    input rst,               // Reset signal
    input update,            // Branch control signal to enable/disable prediction from controller
    input taken,          // ALU zero flag (branch condition) from EX/MEM
    output branch_predict    // Branch prediction result
);
    // State definitions
    parameter StronglyNotTaken = 2'b00, 
              WeaklyNotTaken = 2'b01, 
              WeaklyTaken = 2'b10, 
              StronglyTaken = 2'b11;
    
    reg [1:0] cs, ns;  // Current state & next state

    // next state logic
    always @(posedge clk or posedge rst) begin
        if (rst) 
            cs <= StronglyNotTaken;  // Reset state
        else if (update)
            cs <= ns;  // Update state if branch prediction is enabled
		else	
		    cs <= cs;  // Retain the current state if branch is disabled
    end
	
    // Next state logic
    always @(*) begin
        case (cs)
            StronglyNotTaken: ns = (taken) ? WeaklyNotTaken : StronglyNotTaken;
            WeaklyNotTaken: ns = (taken) ? WeaklyTaken : WeaklyNotTaken;
            WeaklyTaken: ns = (taken) ? StronglyTaken : WeaklyNotTaken;
            StronglyTaken: ns = (taken) ? StronglyTaken : WeaklyTaken;
            default: ns = StronglyNotTaken; 
        endcase
    end
    
    // Prediction result
    assign branch_predict = cs[1];

endmodule

/*
branch_prediction branch_prediction (
    .clk(clk),            
    .rst(rst),             
    .update(update),        
    .taken(taken),    
    .branch_predict(branch_predict),   
);
*/