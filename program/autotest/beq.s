# TAG = beq
	.text

	lui x31, 0x5f78e
	lui x30, 0xfffff
	beq x31, x30, eq_1	# Test d'égalité faux
	lui x31, 0xfffff
	beq x31, x30, eq_2	# Test d'égalité vrai
eq_1:
	lui x31, 0x12345
eq_2: 
	lui x31, 0x67890

	# max_cycle 50
	# pout_start
	# 5f78e000
	# fffff000
	# 67890000
	# pout_end
