extends Node
class_name Scaling

func scale_enemy_hp(wave_number: int, hp: int):
	if wave_number > 3:
		return  hp + (hp/10.0)**wave_number
	return hp

func scale_shop(wave_number: int, price: int):
	return ((wave_number + 1) * (5.0 / price)) + price + wave_number

# Return the amount of gold dropped by 1 enemy
func scale_gold_gained(gold: float, wave_number: int) -> float:
	if wave_number > 4:
		return (4.0 / wave_number) * gold
	return gold

func scale_reroll_price(wave_number: int, amount_of_rerolls: int):
	return (1 if wave_number == 0 else 2 + wave_number) + (amount_of_rerolls**1.5)
