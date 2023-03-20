# TAG = ori
	.text

	addi x1, x0, 0x001   # r1 = r0 + 0x12345
	ori x31, x0, 0x123   # r31 = r0 or r1
	ori x31, x1, 0x0   # r31 = r1 or r2

	# max_cycle 50
	# pout_start
	# 00000123
	# 00000001
	# pout_end