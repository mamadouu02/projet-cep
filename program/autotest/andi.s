# TAG = andi
	.text

	lui x30, 0x5090
	andi x31, x30, 555	# x31 = x30 andi 555
	addi x30, x0, 123
	andi x31, x30, 555	# x31 = x30 andi 555
	addi x30, x0, 2047
	andi x31, x30, 2047 # x31 = x30 andi 2047
	lui x0, 0

	# max_cycle 50
	# pout_start
	# 00000000
	# 0000002B
	# 000007ff
	# pout_end
