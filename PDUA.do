onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pdua_tb/DUT/clk
add wave -noupdate /pdua_tb/DUT/reset
add wave -noupdate /pdua_tb/DUT/U_I
add wave -noupdate /pdua_tb/DUT/shamt
add wave -noupdate /pdua_tb/DUT/selop
add wave -noupdate /pdua_tb/DUT/ir_en
add wave -noupdate /pdua_tb/DUT/mar_en
add wave -noupdate /pdua_tb/DUT/bank_wr_en
add wave -noupdate /pdua_tb/DUT/BusC_addr
add wave -noupdate /pdua_tb/DUT/BusB_addr
add wave -noupdate /pdua_tb/DUT/mdr_alu_n
add wave -noupdate /pdua_tb/DUT/mdr_en
add wave -noupdate /pdua_tb/DUT/wr_rdn
add wave -noupdate /pdua_tb/DUT/enaf
add wave -noupdate /pdua_tb/DUT/ADDRESS_BUS
add wave -noupdate /pdua_tb/DUT/BUSA
add wave -noupdate /pdua_tb/DUT/BUSB
add wave -noupdate /pdua_tb/DUT/BUSC
add wave -noupdate /pdua_tb/DUT/BUS_DATA_IN
add wave -noupdate /pdua_tb/DUT/BUS_DATA_OUT
add wave -noupdate /pdua_tb/DUT/register_bank_component/acc_addr
add wave -noupdate /pdua_tb/DUT/register_bank_component/array_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 286
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {603850 ps}
