# TAG = slli
	.text

	addi x31, x0, 0x123   # r1 = r0 + 0x123
	slli x31, x31, 4   # r31 = r31 << r1

	# max_cycle 50
	# pout_start
	# 00000123
	# 00001230
	# pout_end
