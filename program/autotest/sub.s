# TAG = sub
	.text

	lui x30, 1028       # Chargement d'une valeur quelconque dans x30
	addi x31, x30, 88   # x31 = x31 + 88
	sub x31, x31, x30	# x31 = x31 - x30
	lui x30, 0xfffff
	sub x31, x31, x30	# x31 = x31 - x30

	# max_cycle 50
	# pout_start
	# 00404058
	# 00000058
	# 00001058
	# pout_end
