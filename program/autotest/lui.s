# TAG = lui
	.text

	lui x31, 0x1        # Chargement de la valeur 1
	lui x31, 0x5089     # Chargement d'une valeur quelconque
	lui x31, 0xfffff    # Chargement de la valeur maximale permise

	# max_cycle 50
	# pout_start
	# 00001000
	# 05089000
	# fffff000
	# pout_end
