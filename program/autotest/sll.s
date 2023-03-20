# TAG = sll
	.text

	addi x31, x0, 0x123   # r1 = r0 + 0x123
    addi x1, x0, 5   # r2 = r0 + 5
	sll x31, x31, x1   # r31 = r31 << r1

	# max_cycle 50
	# pout_start
	# 00000123
	# 00002460
	# pout_end
