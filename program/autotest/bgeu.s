# TAG = bgeu
	.text

	bgeu x31, x0, label
    addi x31, x31, -1

label:
    addi x31, x31, 1

	# max_cycle 50
	# pout_start
	# 00000001
	# pout_end
