hs.window.filter.new():subscribe(
	"windowCreated",
	function(win)
		win:centerOnScreen(nil, false, 0)
	end
)
