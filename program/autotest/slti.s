# TAG = slti
	.text

	addi x30, x0, 0x111
	slti x31, x30, 0x111
	slti x31, x30, 0x7ff
	slti x31, x30, 0xf

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# pout_end
