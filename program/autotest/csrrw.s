# TAG = csrrw
	.text

	lui x31, 0x01010
    csrrw x30, mie, x31
    csrrw x31, mie, x30
    lui zero, 0
	# max_cycle 50
	# pout_start
	# 01010000
	# 01010000
	# pout_end
