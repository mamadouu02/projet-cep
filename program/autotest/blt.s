# TAG = blt
	.text

	lui x31, 0x11113
	lui x30, 0x11112
	blt x31, x30, lt_1	# Test faux 
	lui x30, 0x1113
	blt x31, x30, lt_2 
	lui x30, 0x21113
	blt x31, x30, lt_3	# Test vrai
lt_1:
	lui x31, 0x12345
lt_2:
	lui x31, 0x67890 
lt_3: 
	lui x31, 0x0

	# max_cycle 50
	# pout_start
	# 11113000
	# 00000000
	# pout_end
