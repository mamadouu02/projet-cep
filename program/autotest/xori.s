# TAG = xori
	.text

	addi x1, x0, 0x001   # r1 = r0 + 0x001
	xori x31, x0, 0x123   # r31 = r0 xori 0x123
	xori x31, x1, 0x0   # r31 = r1 xori 0x0

	# max_cycle 50
	# pout_start
	# 00000123
	# 00000001
	# pout_end
