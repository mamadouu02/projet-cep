# TAG = add
	.text

	addi x1, x0, 0x123   # r1 = r0 + 0x12345
    addi x2, x0, 0x456   # r2 = r0 + 0x56789
	add x31, x0, x1   # r31 = r0 + r1
	add x31, x1, x2   # r31 = r1 + r2

	# max_cycle 50
	# pout_start
	# 00000123
	# 00000579
	# pout_end
