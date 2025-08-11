
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

-- When a window shows, poke HazeOver so it re-applies the overlay (sometimes it doesn't).
hs.window.filter.new():subscribe(
	{ "windowFocused", "windowVisible", "windowUnminimized", "windowCreated", "windowDestroyed" },
	function()

		local hazeOverIntensity = 88;

		hs.osascript.applescript( string.format( [[tell application "HazeOver" to set intensity to %d]], hazeOverIntensity - 1 ) )
		hs.osascript.applescript( string.format( [[tell application "HazeOver" to set intensity to %d]], hazeOverIntensity ) )
	end
)

-- When there is no window for an app, disable the HazeOver overlay (beacuse it sticks around normally).
hs.window.filter.new():subscribe(
	"hasNoWindows",
	function()
		hs.osascript.applescript( string.format( [[tell application "HazeOver" to set intensity to %d]], 0 ) )
	end
)
