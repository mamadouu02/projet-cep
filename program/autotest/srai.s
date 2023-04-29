# TAG = srai
	.text

	lui x30, 0xfffff
    srai x31, x30, 0x001
    srai x31, x31, 0x10

	# max_cycle 50
	# pout_start
    # fffff800
    # ffffffff
	# pout_end
