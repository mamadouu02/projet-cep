# TAG = sll
	.text

	addi x31, x0, 0x001
	lui x30, 0xfffff
	addi x30, x30, 0x001
	sll x31, x30, x31
	addi x31, x0, 0x004
	sll x31, x30, x31
	lui x30, 0xfffff
	addi x30, x30, 0x7ff
	sll x31, x31, x30

	# max_cycle 50
	# pout_start
	# 00000001
	# ffffe002
	# 00000004
	# ffff0010
	# 00000000
	# pout_end