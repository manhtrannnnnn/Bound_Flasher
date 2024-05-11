module bound_flasher (
    input wire flick, clk, rst,
    output reg [15:0] LED
);

// States
parameter
    INIT = 0,
    turn_on_0_15 = 1,
    turn_off_15_5 = 2,
    turn_on_5_10 = 3,
    turn_off_10_0 = 4,
    turn_on_0_5 = 5,
    turn_off_5_0 = 6;

// operation mode
parameter
  	IDLE = 0,
    UP = 1,
    DOWN = 2,
    KICKBACK = 3;

integer state = INIT, nextState = INIT;
integer operation = IDLE;
integer count = -1;
integer i;
// MUX1 block
always @(posedge clk or negedge rst) begin
    if(rst == 0) begin
        state <= INIT;
    end
    else begin
        state <= nextState;
    end
end

//operation on count
always @(posedge clk or negedge rst) begin
    if(rst == 0) count <= -1;
    else if(operation == UP) count <= count + 1;
    else if (operation == DOWN) count <= count - 1;
end


// Change State Block
always @(state or operation)begin
    case(state)
        INIT: begin
            if(operation == UP) nextState = turn_on_0_15;
            else nextState = state;
        end

        turn_on_0_15: begin
            if(operation == DOWN) nextState = turn_off_15_5;
            else nextState = state;
        end

        turn_off_15_5: begin
            if(operation == DOWN) nextState = state;
            else if(operation == KICKBACK) nextState = turn_on_0_15;
            else nextState = turn_on_5_10;
        end

        turn_on_5_10: begin
            if(operation == UP) nextState = state;
            else nextState = turn_off_10_0;
        end

        turn_off_10_0: begin
            if(operation == DOWN) nextState = state;
            else if(flick == 1) nextState = turn_on_5_10;
            else nextState = turn_on_0_5;
        end

        turn_on_0_5: begin
            if(operation == UP) nextState = state;
            else nextState = INIT;
        end

        default: nextState = INIT;
    endcase
end

// MUX2 block
always @(state or flick or count) begin  
  	operation = IDLE;
    case(state)
        INIT: begin
            if(count > 0) operation <= DOWN;
            else if(flick == 1) operation <= UP;
            else operation <= IDLE;
        end

        turn_on_0_15: begin
            if(count < 15) operation <= UP;
          else operation <= DOWN;
        end

        turn_off_15_5: begin
            if(count > 5) operation <= DOWN;
            else if (flick == 1) operation <= KICKBACK;
            else operation <= UP;
        end

        turn_on_5_10: begin
            if(count < 10) operation <= UP;
            else operation <= DOWN;
        end

        turn_off_10_0: begin
            if(count > 0) operation <= DOWN;
            else if (flick == 1) operation <= KICKBACK;
        end

        turn_on_0_5: begin
            if(count < 5) operation <= UP;
            else operation <= DOWN;
        end

        default: operation = IDLE;
    endcase
end




// OUTPUT
always @(count) begin
    if(count == -1) begin
      for(i = 0; i <= 15; i = i + 1) LED[i] <= 1'b0;
    end
  else begin 
        for(i = 0; i <= 15; i = i + 1) begin
            if(i <= count) LED[i] <= 1'b1;
            else LED[i] <= 1'b0;
        end
    end
end

endmodule