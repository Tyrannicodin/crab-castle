extends Node
class_name Scaling

func scale_enemy_hp(wave_number, hp):
	return hp

func scale_shop(wave_number, price):
	return ((wave_number + 1) * (10.0 / price)) + price

# Return the amount of gold dropped by 1 enemy
func scale_gold_gained():
	return 2

func scale_reroll_price(wave_number, amount_of_rerolls):
	return 5
