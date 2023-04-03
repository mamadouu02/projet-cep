# TAG = jalr
	.text

	lui x31, 1
    jalr x1, 12(x31)
    lui x31, 2
    lui x31, 3

	# max_cycle 50
	# pout_start
	# 00001000
	# 00003000
	# pout_end