# TAG = andi
	.text

	addi x1, x0, 0x001   # r1 = r0 + 0x001
	andi x31, x0, 0x123   # r31 = r0 andi 0x123
	andi x31, x1, 0x0   # r31 = r1 andi 0x0

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000000
	# pout_end
