# TAG = srli
	.text

	addi x31, x0, 0x120   # r1 = r0 + 0x120
	srli x31, x31, 4   # r31 = r31 >> r1

	# max_cycle 50
	# pout_start
	# 00000120
	# 00000012
	# pout_end
