# TAG = sub
	.text

	addi x1, x0, 0x123   # r1 = r0 + 0x123
    addi x2, x0, 0x456   # r2 = r0 + 0x456
	sub x31, x1, x0   # r31 = r1 - r0
	sub x31, x2, x1   # r31 = r2 - r1
    lui x0, 0

	# max_cycle 50
	# pout_start
	# 00000123
	# 00000333
	# pout_end
