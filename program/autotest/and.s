# TAG = and
	.text

	lui x31, 0x4500
	lui x30, 0x5090
	and x31, x31, x30   # x31 = x31 and x30
	lui x30, 0x12345
	lui x31, 0x67890
	and x31, x31, x30   # x31 = x31 and x30
	and x31, x31, x0	# x31 = x31 and x0
	lui x0, 0

	# max_cycle 50
	# pout_start
	# 04500000
	# 04000000
	# 67890000
	# 02000000
	# 00000000
	# pout_end
