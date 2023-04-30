# TAG = bne
	.text

	lui x31, 0xfffff
	lui x30, 0xfffff
	bne x31, x30, eq_1	# Test faux
	lui x31, 0x5f78e
	bne x31, x30, eq_2	# Test vrai
eq_1:
	lui x31, 0x12345
eq_2: 
	lui x31, 0x67890

	# max_cycle 50
	# pout_start
	# fffff000
	# 5f78e000
	# 67890000
	# pout_end
