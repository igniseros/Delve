extends Node2D

var totalTime = 0 #total time that will count up 
export(float) var threshholdTime = 2 #adding export puts it in the editor
var i = 0 #just a varriable


func _ready(): #this is an example script for you berkley!
	set_process(true) #turns on the _process function
	print(self.get_path()) #prints the path to the consol

func _process(delta): #runs every frame with delta being the time between frames
	totalTime += delta #counts up like a stop watch
	var array = ["Ska(t)","Bam","Pow","Bing"] #just some words
	var label = get_tree().get_root().get_node("Node2D/Label") #gets label node
	if (totalTime >= threshholdTime): #runs inside of total time has passed the threshhold time
		i+= 1 #counts up i
		if (i >= array.size()): 
			i = 0 #resets i if i is above or equal to array length (0 based arrays are used here)
		label.set_text("Boom " + array[i]) #sets text to index i in Array array (this line is not in above if statement)
		totalTime = 0 # resets total time
		
	
	
	#These are for your viewing pleasure
	print(label.get_path())
	print(i)
	print(totalTime)