extends Control

func ChangeExp(max_exp, exp_value):
	get_node("Exp").max_value = max_exp
	get_node("Exp").value = exp_value
	
	if max_exp > 3500:
		var orange_stylebox = StyleBoxFlat.new()
		orange_stylebox.bg_color = Color(255.0/255, 136.0/255, 40.0/255, 1)
		$Exp.add_stylebox_override("fg", orange_stylebox)
		$Exp.add_stylebox_override("bg", orange_stylebox)
	else:
		var blue_stylebox = StyleBoxFlat.new()
		var transparent_stylebox = StyleBoxFlat.new()
		blue_stylebox.bg_color = Color(40.0/255, 118.0/255, 255.0/255, 1)
		transparent_stylebox.bg_color = Color(0.0/255, 0.0/255, 0.0/255, 80.0/255)
		$Exp.add_stylebox_override("fg", blue_stylebox)
		$Exp.add_stylebox_override("bg", transparent_stylebox)
		
