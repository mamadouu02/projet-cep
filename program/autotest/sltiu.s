# TAG = sltiu
	.text

	addi x30, x0, 0x111
	sltiu x31, x30, 0x111
	sltiu x31, x30, 0x7ff
	sltiu x31, x30, 0xf
	lui x30, 0x11111
	sltiu x31, x30, 0x5ff

	# max_cycle 50
	# pout_start
	# 00000000
	# 00000001
	# 00000000
	# 00000000
	# pout_end
