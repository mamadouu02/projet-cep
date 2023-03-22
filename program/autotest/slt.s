# TAG = slt
	.text

    addi x1, x0, 1
    addi x2, x0, 2
	slt x31, x1, x2
    slt x31, x2, x1

	# max_cycle 50
	# pout_start
    # 00000001
    # 00000000
	# pout_end
