# TAG = bltu
	.text

	lui x31, 0x11113
	lui x30, 0x11112
	bltu x31, x30, lt_1	# Test faux 
	lui x30, 0x11114
	bltu x31, x30, lt_2 
lt_1:
	lui x31, 0x12345
lt_2:
	lui x31, 0x67890

	# max_cycle 50
	# pout_start
	# 11113000
	# 67890000
	# pout_end
