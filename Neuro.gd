extends Object
class_name NeuralNetwork

var layouts = []
var weights = []


func activate(x):
	return 1 / (1 + exp(-x))

func measure(x, y, e):
	return x * y * (1 - y) * e


func activate2(x):
	if x > 1:
		return 1 + 0.01 * (x - 1)
	if x < 0:
		return 0.01 * x
	if 0 <= x && x <= 1:
		return x

func measure2(x, y, e):
	if 0 < x and x < 1:
		return 1 * x * e
	else:
		return 0.01 * x * e

func count_lay(li, lo, w):
	for i in range(len(lo)):
		lo[i][0] = 0
		for j in range(len(li)):
			lo[i][0] += li[j][0] * w[i][j]
		lo[i][0] = activate(lo[i][0])

func find_out_error(lay, val):
	for i in range(len(lay)):
		lay[i][1] = val[i] - lay[i][0]

func find_error(li, lo, w):
	for i in range(len(li)):
		li[i][1] = 0
		for j in range(len(lo)):
			li[i][1] += lo[j][1] * w[j][i]

func correct(li, lo, w, k):
	for i in range(len(w)):
		for j in range(len(w[i])):
			w[i][j] += k * measure(li[j][0], lo[i][0], lo[i][1])


func run(data):
	for i in range(len(layouts[0])):
		layouts[0][i][0] = data[i]
	
	for i in range(len(layouts)-1):
		count_lay(layouts[i], layouts[i+1], weights[i])
	
	var res = []
	for i in layouts[-1]:
		res.append(i[0])
	
	return res


func train(ld, params = {}):
	var iters = 1000
	if "iterations" in params:
		iters = params["iterations"]
	
	var koof = 0.5
	if "learn rate" in params:
		koof = params["learn rate"]
	
	for iter in range(iters):
		for d in ld:
			run(d[0])
			
			find_out_error(layouts[-1], d[1])
			
			for i in range(len(layouts)-1, 1):
				find_error(layouts[i-1], layouts[i], weights[i-1])
			
			for i in range(len(layouts)-1):
				correct(layouts[i], layouts[i+1], weights[i], koof)


func _init(nc):
	if len(nc) < 2:
		print("Lays count must be more 2!")
		return
	
	randomize()
	
	for i in nc:
		var lay = []
		for j in i:
			lay.append([0, 0])
		layouts.append(lay)
	
	for i in range(1, len(nc)):
		var l = []
		for j in range(nc[i]):
			var w = []
			for k in range(nc[i-1]):
				w.append(randf()*2-1)
			l.append(w)
		weights.append(l)
