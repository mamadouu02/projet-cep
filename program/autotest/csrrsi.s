# TAG = csrrsi
    .text

	lui x31, 0x01010
    csrrw x30, mie, x31
	lui x31, 0x10101
    csrrsi x31, mie, 0x1
    csrrw x31, mie, x30
    lui zero, 0
    # max_cycle 50
    # pout_start
	# 01010000
	# 10101000
	# 01010000
	# 01010001
    # pout_end
