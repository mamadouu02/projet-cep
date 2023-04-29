# TAG = jal
	.text

	jal x0, saut

	test :
		addi x31, x31, 0
	saut :
		lui x31, 0x1

	# max_cycle 50
	# pout_start
	# 00001000
	# pout_end
