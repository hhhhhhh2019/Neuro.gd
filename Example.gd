extends Node

var ld = [
	[[0, 0, 0], [1]],
	[[1, 1, 1], [0]]
]

var n = NeuralNetwork.new([3, 2, 1])

func _ready():
	print(n.run([0, 0, 0]))
	print(n.run([1, 1, 1]))
	n.train(ld, {
		"iterations": 10000,
		"learning rate": 0.1
	})
	print(n.run([0, 0, 0]))
	print(n.run([1, 1, 1]))
