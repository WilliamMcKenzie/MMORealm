extends Node

func CompareArrays(arr1, arr2):
	if arr1.size() != arr2.size():
		return false

	for i in range(arr1.size()):
		if typeof(arr1[i]) != typeof(arr2[i]):
			return false

		match typeof(arr1[i]):
			TYPE_NIL:
				if arr1[i] != arr2[i]:
					return false
			TYPE_DICTIONARY:
				if not CompareDictionaries(arr1[i], arr2[i]):
					return false
			_:
				if arr1[i] != arr2[i]:
					return false
	return true

func CompareDictionaries(dict1, dict2):
	if dict1.size() != dict2.size():
		return false

	for key in dict1.keys():
		if not dict2.has(key):
			return false
		if dict1[key] != dict2[key]:
			return false
	return true
