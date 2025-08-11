
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

	-- ==============================
	-- HazeOver Hacks
	-- ==============================

	-- When a window shows, poke HazeOver so it re-applies the overlay (sometimes it doesn't).
	hs.window.filter.new():subscribe(
		{ "windowFocused", "windowVisible", "windowUnminimized", "windowCreated", "windowDestroyed" },
		function()
			hs.osascript.applescript( [[ tell application "HazeOver" to set enabled to true ]] )
		end
	)

	-- When there is no window for an app, disable the HazeOver overlay (beacuse it sticks around normally).
	hs.window.filter.new():subscribe(
		"hasNoWindows",
		function()
			hs.osascript.applescript( [[ tell application "HazeOver" to set enabled to false ]] )
		end
	)
