# Import file "powerSearch"
powerSearch = Framer.Importer.load("imported/powerSearch@1x")


# Define some layers and attributes
leftArrow = powerSearch.TabBar
searchInput = powerSearch.tabBarSearchInput
searchResults = powerSearch.Background2

# First Step, tap and hold left arrow
bounceLayer = (leftArrow) ->
  leftArrow.animate
    properties:
      scale: 1.2
    time: .1
  Utils.delay .1, ()->
    leftArrow.animate
      properties:
        scale: 1
      time: .1
      
isHeld = false

leftArrow.on Events.TouchStart, () ->
	isHeld = true
	Utils.delay 3, () ->
    	if isHeld then triggerLongHold()

leftArrow.on Events.TouchEnd, () ->
  # this is a regular tap
  if isHeld
    bounceLayer @
    isHeld = false
  # this is the "long hold" release
  else
    @.scale = 1

triggerLongHold = () ->
 	# this is the long hold trigger
 	powerSearch.Search.states.switch "onscreen"
 	isHeld = false
  	

# Second Step, search for depeche mode, search results will appear as you type

powerSearch.Search.states.add
	"onscreen":
		x: 0
		z: 1

powerSearch.Search.states.animationOptions =
	curve: "spring(400,40,0)"
	
	
searchResults = powerSearch.SearchResults

searchResults.x = 0
searchResults.y = 1350
searchResults.z = 0

searchResults.states.add
	"onscreen":
		x: 0
		y:120
		z: 2
	
searchResults.states.animationOptions =
	curve: "spring(400,40,0)"
	
startSearchResult = Utils.debounce 1.2, ->
	searchResults.states.switch "onscreen"
	
	
textBox = new Layer width: 400, height: 40, backgroundColor: '#fff',x: 853,y:48
textBox.style =
  color: '#000'
  padding:'5px'
  fontFamily: "Futura, sans-serif"
  fontWeight: '100'
  fontSize: "24px"
  z:1
  scale: 0
  opacity: 0
 

 
textBox = new Layer width: 450, height: 40, backgroundColor: '#fff',x: 110, y: 60

textBox.style =
  color: '#000'
  padding:'10px'
  fontFamily: "Futura, sans-serif"
  fontWeight: '100'
  fontSize: "24px"
  opacity: "0"
  scale: "0"
  
startType = ->
		
	textBox.html = ""
	
	text = "depeche"
	
	text = text.split('')
	
	totalDelay = .5
	typeLetter = (letter, delay) ->
	  totalDelay += Utils.randomNumber 0.05,.25
	  Utils.delay totalDelay, -> textBox.html += letter
	
	for letter,i in text
		typeLetter letter, i
		startSearchResult()	
	    
textBox.states.add
	"onscreen":
		x: 110
		y: 58
		z: 2
		scale:1
		opacity: 100


searchInput.onClick ->
	textBox.states.switch "onscreen"
	startType()
	


# Last Step, depeche mode artist screen shows up after selecting it

depecheMode = powerSearch.DepecheMode
depecheMode.x = 800
depecheMode.y = 0
depecheMode.z = 1

depecheMode.states.add
	"onscreen":
			x: 0
			y: 0
			z: 3
			
depecheMode.states.animationOptions =
	curve: "spring(400,40,0)"


powerSearch.select.onClick ->
	textBox.opacity = 0
	depecheMode.states.switch "onscreen"

	
## the end