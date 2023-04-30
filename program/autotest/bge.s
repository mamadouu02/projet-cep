# TAG = bge
	.text

	lui x31, 0x11113
	lui x30, 0x11112
	bge x30, x31, ge_1	# Test faux 
	lui x30, 0x1113
	bge x30, x31, ge_2 
	lui x30, 0x11113
	bge x30, x31, ge_3	# Test vrai
ge_1:
	lui x31, 0x12345
ge_2:
	lui x31, 0x67890 
ge_3: 
	lui x31, 0x0

	# max_cycle 50
	# pout_start
	# 11113000
	# 00000000
	# pout_end
