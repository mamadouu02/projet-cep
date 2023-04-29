# TAG = and
	.text

	addi x1, x0, 0x001   # r1 = r0 + 0x001
    addi x2, x0, 0x101   # r2 = r0 + 0x101
	and x31, x0, x1   # r31 = r0 and r1
	and x31, x1, x2   # r31 = r1 and r2

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# pout_end
