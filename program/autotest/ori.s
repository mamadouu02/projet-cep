# TAG = ori
	.text

	lui x30, 0x5090
	ori x31, x30, 555	# x31 = x30 ori 555
	lui x30, 0x12345
	ori x31, x30, 0     # x31 = x30 ori 0x0
	addi x30, x0, 667
	ori x31, x30, 1788  # x31 = x30 ori 1788
	lui x0, 0

	# max_cycle 50
	# pout_start
	# 0509022B
	# 12345000
	# 000006ff
	# pout_end
