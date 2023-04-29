# TAG = srl
	.text

	addi x31, x0, 0x001
	lui x30, 0xfffff
	addi x30, x30, 0x001
	srl x31, x30, x31
	addi x30, x0, 2047
	srl x31, x31, x30

	# max_cycle 50
	# pout_start
	# 00000001
	# 7ffff800
	# 00000000
	# pout_end
