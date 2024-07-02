extends Control

func ChangeExp(max_exp, exp_value):
	get_node("Exp").max_value = max_exp
	get_node("Exp").value = exp_value
	
	if max_exp > 3600:
		var orange_stylebox = StyleBoxFlat.new()
		orange_stylebox.bg_color = Color(255.0/255, 136.0/255, 40.0/255, 1)
		$Exp.add_stylebox_override("fg", orange_stylebox)
		$Exp.add_stylebox_override("bg", orange_stylebox)
		
