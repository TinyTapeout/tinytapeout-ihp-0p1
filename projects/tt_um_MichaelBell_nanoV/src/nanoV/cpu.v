/* A RISC-V core designed to use minimal area.

   This core module takes instructions and produces output data
 */

module p19_nanoV_cpu #(parameter NUM_REGS=16) (
    input clk,
    input rstn,

    input spi_data_in,
    output reg spi_select,
    output spi_out,
    output reg spi_clk_enable,

    input [31:0] ext_data_in,
    output [31:0] addr_out,
    output [31:0] data_out,
    output store_data_out,  // When high, data_out is the data value for a store instruction corresponding to the previous address.
    output store_addr_out,  // When high, addr_out is the address of a load/store instruction.
    output data_in_read     // When high, ext_data_in has been read by a load.
);

    reg [4:0] counter;
    wire [5:0] next_counter = {1'b0,counter} + 1;
    always @(posedge clk)
        if (!rstn) begin
            counter <= 0;
        end else begin
            counter <= next_counter[4:0];
        end

    function [2:0] cycles_for_instr(input [31:2] instr);
        if (instr[6:2] == 5'b11000) cycles_for_instr = 4; // Taken branch
        else if (instr[6:5] == 2'b11) cycles_for_instr = 3;  // Jump
        else if (instr[6] == 0 && instr[4:2] == 0 && instr[19:15] != 5'b00100) cycles_for_instr = 5; // Load/store
        else if (instr[6] == 0 && instr[4] == 1 && instr[2] == 0 && ((instr[25] && instr[5]) || instr[13:12] == 2'b01)) cycles_for_instr = 2; // Shift/Mul
        else cycles_for_instr = 1;
    endfunction

    wire is_mem = (instr[6] == 0 && instr[4:2] == 0);
    wire is_normal_mem = is_mem && instr[19:15] != 5'b00100;
    wire is_fast_mem = is_mem && instr[19:15] == 5'b00100;
    wire is_store = is_mem && instr[5];
    wire is_load = is_mem && !instr[5];
    wire is_any_jump = (instr[6:5] == 2'b11);
    wire is_jmp = (is_any_jump && instr[4] == 1'b0 && instr[2] == 1'b1);
    wire is_branch = (instr[6:2] == 5'b11000);
    reg [2:0] cycle;
    reg [2:0] instr_cycles_reg;
    wire [2:0] next_cycle = cycle + {2'b0, next_counter[5]};
    wire [2:0] instr_cycles = (next_cycle == 1 && next_counter[5] && is_branch && !take_branch) ? 1 : instr_cycles_reg;
    wire [2:0] instr_cycles_assume_branch_not_taken = (next_cycle == 1 && next_counter[5] && is_branch) ? 1 : instr_cycles_reg;
    reg [31:0] next_instr;
    reg [31:2] instr;
    always @(posedge clk)
        if (!rstn) begin
            cycle <= 0;
            instr <= 30'b000000000000_00000_000_00000_11011;
            instr_cycles_reg <= 3;
        end else begin
            if (next_cycle == instr_cycles) begin
                cycle <= 0;
                instr <= next_instr[31:2];
                instr_cycles_reg <= cycles_for_instr(next_instr[31:2]);
            end else
                cycle <= next_cycle;
        end

    wire is_fast_addr = next_instr[6] == 0 && next_instr[4:2] == 0 && next_instr[19:15] == 5'b00100 && next_cycle == instr_cycles;
    assign store_data_out = (counter == 31 && is_store && cycle == (is_normal_mem ? 1 : 0));
    assign data_in_read = (counter == 31 && is_load && cycle == (is_normal_mem ? 2 : 0));
    assign store_addr_out = is_fast_addr || (counter == 0 && is_normal_mem && cycle == 1);

    wire [11:0] fast_addr_imm = {next_instr[31:25], next_instr[5] ? next_instr[11:9] : next_instr[24:22], 2'b00};
    wire [31:0] fast_addr = {20'h10000, fast_addr_imm};
    assign addr_out = is_fast_addr ? fast_addr : core_data_out;

    wire [30:0] reversed_data_out;
    genvar i;
    generate
      for (i=0; i<31; i=i+1) assign reversed_data_out[i] = core_data_out[30-i];
    endgenerate
    assign data_out = {core_rs2_out,reversed_data_out[30:0]};

    wire shift_data_out;
    wire take_branch;
    wire read_pc;
    wire data_in;
    wire [31:0] core_data_out;
    wire core_rs2_out;
    reg use_ext_data_in_reg;
    wire use_ext_data_in = use_ext_data_in_reg || (is_fast_mem && !instr[5]);
    reg last_data_in;
    always @(posedge clk)
        last_data_in <= instr[14] ? 1'b0 : data_in;

    p19_nanoV_core #(.REG_ADDR_BITS($clog2(NUM_REGS)), .NUM_REGS(NUM_REGS)) core (
        clk,
        rstn,
        (next_cycle == instr_cycles_assume_branch_not_taken) ? next_instr[30:2] : instr[30:2],
        instr,
        cycle,
        counter,
        pc[0],
        data_in,
        ext_data_in[counter],
        use_ext_data_in,
        shift_data_out,
        read_pc,
        core_data_out,
        core_rs2_out,
        take_branch
    );

    reg start_instr_stream;
    reg starting_instr_stream;
    reg read_instr;
    reg [1:0] first_instr;
    reg [21:0] pc;
    wire starting_send_pc = counter[4:3] != 0 && counter < 30;
    wire starting_read_cmd = counter[2] && !counter[1];
    wire starting_instr_out = starting_send_pc ? (is_any_jump ? core_data_out[29] : pc[21]) : starting_read_cmd;

    wire [21:0] next_pc = (counter == 31 && ((next_cycle == instr_cycles && read_instr && !first_instr[0]) || (is_normal_mem && cycle == 0))) ? pc + 4 : pc;

    wire is_write = instr[5];
    reg start_data_stream;
    reg starting_data_stream;
    reg data_xfer;
    wire starting_send_data_addr = counter < 24;
    wire starting_write_data_cmd = counter[2:0] == 6;
    wire starting_read_data_cmd = counter[2] && counter[1];
    wire starting_data_cmd = is_write ? starting_write_data_cmd : starting_read_data_cmd;
    wire starting_data_out = starting_send_data_addr ? core_data_out[23] : starting_data_cmd;

    always @(posedge clk) begin
        if (!rstn) begin
            start_instr_stream <= 1;
            starting_instr_stream <= 0;
            read_instr <= 0;
            first_instr <= 0;
            start_data_stream <= 0;
            starting_data_stream <= 0;
            data_xfer <= 0;
            use_ext_data_in_reg <= 0;
            spi_select <= 1;
            spi_clk_enable <= 1;
            pc <= 0;
        end else begin
            if (take_branch) begin
                read_instr <= 0;
                start_instr_stream <= 1;
                starting_instr_stream <= 0;
                start_data_stream <= 0;
                starting_data_stream <= 0;
                data_xfer <= 0;
                spi_select <= 1;
            end else begin
                if (counter == 0) begin
                    if (is_normal_mem && cycle == 0) begin
                        read_instr <= 0;
                        first_instr <= 0;
                        start_data_stream <= 1;
                        spi_select <= 1;
                    end
                end else if (counter == 23) begin
                    if (start_data_stream) begin
                        start_data_stream <= 0;
                        starting_data_stream <= 1;
                        spi_select <= 0;
                    end else if (starting_data_stream) begin
                        starting_data_stream <= 0;
                        data_xfer <= 1;
                    end else if (data_xfer) begin
                        data_xfer <= 0;
                        start_instr_stream <= 1;
                        spi_select <= 1;
                    end
                end else if (counter == 31) begin
                    if (data_xfer && instr[13:12] == 0) begin
                        data_xfer <= 0;
                        start_instr_stream <= 1;
                        spi_select <= 1;
                    end else if (starting_data_stream && is_normal_mem && core_data_out[31:24] != 0) begin
                        // Cancel SPI write to high address
                        spi_select <= 1;
                        if (!instr[5]) begin
                            use_ext_data_in_reg <= 1;
                        end
                    end else if (use_ext_data_in_reg && cycle == 2) begin
                        use_ext_data_in_reg <= 0;
                    end
                end else if (counter == 7) begin
                    if (data_xfer && instr[12]) begin
                        data_xfer <= 0;
                        start_instr_stream <= 1;
                        spi_select <= 1;
                    end
                end else if (counter == 29) begin
                    if (start_instr_stream) begin
                        start_instr_stream <= 0;
                        starting_instr_stream <= 1;
                        spi_select <= 0;
                    end else if (starting_instr_stream) begin
                        starting_instr_stream <= 0;
                        read_instr <= 1;
                        first_instr <= 2'b11;
                    end else if (cycle + 1 == instr_cycles || is_branch) begin
                        first_instr <= {1'b0,first_instr[1]};
                        read_instr <= 1;
                        spi_clk_enable <= 1;
                    end else if (!is_normal_mem) begin
                        read_instr <= 0;
                        spi_clk_enable <= 0;
                    end
                end
            end

            if (starting_instr_stream && starting_send_pc && !is_any_jump)
                pc <= {pc[20:0],pc[21]};
            else if (read_pc)
                pc <= {pc[0],pc[21:1]};
            else if (is_any_jump && cycle == 2 && counter > 9)
                pc <= {pc[20:0],core_data_out[31]};
            else
                pc <= next_pc;
        end
    end

    reg last_data_xfer;
    always @(posedge clk)
        last_data_xfer <= data_xfer;

    assign shift_data_out = ((is_jmp || is_normal_mem) && (cycle != 0)) || (is_fast_mem) || (is_branch && cycle[1]);
    assign spi_out = starting_instr_stream ? starting_instr_out :
                     starting_data_stream ?  starting_data_out :
                     is_store ?              core_data_out[23] : 0;

    assign data_in = last_data_xfer ? spi_data_in : last_data_in;

    wire next_instr_new_bit = read_instr ? spi_data_in : next_instr[0];

    always @(posedge clk) begin
        if (!rstn) begin
            next_instr <= 32'b000000000000_00000_000_00000_0010011;
        end else begin
            next_instr <= {next_instr_new_bit, next_instr[31:1]};
        end
    end

endmodule
