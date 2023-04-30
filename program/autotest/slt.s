# TAG = slt
	.text

	lui x31, 0x11111
	lui x30, 0x11110
	slt x31, x31, x30
	lui x30, 0x10000
	slt x31, x31, x30
	lui x31, 0xf0000
	slt x31, x31, x30   # Donne 1 pour slt et 0 pour sltu

	# max_cycle 50
	# pout_start
	# 11111000
	# 00000000
	# 00000001
	# f0000000
	# 00000001
	# pout_end
