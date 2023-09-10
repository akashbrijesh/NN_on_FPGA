timescale 1ns / 1ps

`include "include.v"

module Weight_Memory #(parameter numWeight = 3, neuronNo=5,layerNo=1,addressWidth=10,dataWidth=16,weightFile="w_1_15.mif") 
    ( 
    input clk,
    input wen,
    input ren,
    input [addressWidth-1:0] wadd,
    input [addressWidth-1:0] radd,
    input [dataWidth-1:0] win,
    output reg [dataWidth-1:0] wout);
    
    // This is the memory. We have defined the width of the memory using dataWidth and depth of the memory is dependent on the number
    // of weights, which in turn depends on the number of inputs to our neuron. 
    reg [dataWidth-1:0] mem [numWeight-1:0];    


    // This part decides if this acts as a RAM or a ROM
    `ifdef pretrained   //pretrained stored in include file
        // if pretrained acts a ROM else RAM
        initial
		begin
	        $readmemb(weightFile, mem);
	    end
	`else
		always @(posedge clk)
		begin
			if (wen)
			begin
				mem[wadd] <= win;
			end
		end 
    `endif
    
    always @(posedge clk)
    begin
        if (ren)
        begin
            wout <= mem[radd];
        end
    end 
endmodule