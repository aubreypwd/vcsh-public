
-- ==============================
-- Windows
-- ==============================

hs.window.animationDuration = 0 -- Never animate things.

-- Center all newly created windows.
hs.window.filter.new():subscribe(
	"windowCreated",
	function(win)
		win:centerOnScreen(nil, false, 0)
	end
)

-- When a window shows, poke HazeOver so it applies the overlay.
hs.window.filter.new():subscribe(
	{ "windowFocused", "windowVisible", "windowUnminimized", "windowCreated", "windowDestroyed" },
	function()

		local hazeOverIntensity = 88;

		hs.osascript.applescript(string.format([[tell application "HazeOver" to set intensity to %d]]), hazeOverIntensity - 1 )
		hs.osascript.applescript(string.format([[tell application "HazeOver" to set intensity to %d]]), hazeOverIntensity )
	end
)
