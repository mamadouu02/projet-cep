# TAG = xori
	.text

	lui x30, 0x5090
	xori x31, x30, 555  # x31 = x30 xori 555
	addi x30, x30, 123
	xori x31, x30, 667  # x31 = x30 xori 667
	xori x31, x0, 789   # x31 = x0 xori 789
	lui x0, 0

	# max_cycle 50
	# pout_start
	# 0509022B
	# 050902E0
	# 00000315
	# pout_end
