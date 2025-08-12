-- ==============================
-- Functions
-- ==============================

functions = {

	-- My version of :centerOnScreen that takes into account the menubar (like rectangle).
	centerOnScreen = function( win )

		-- Apps to exclude from doing this...
		local excludeApps = {
			["CleanShot X"] = true,
			["iBar Pro"] = true,
		};

		if excludeApps[win:application():name()] then
			return; -- The window should not be fucked with.
		end

		win:centerOnScreen( nil, false, 0 ); -- Always center the window on screen, totally fine no matter what.

		if math.abs( win:frame().y + win:frame().h ) == math.abs( win:screen():frame().y + win:screen():frame().h ) then
			return; -- Don't adjust it for the top menubar if the window is already at the bottom of the screen (will nudge below screen).
		end

		win:setFrame(
			{
				x = win:frame().x,
				y = win:frame().y + 22,
				w = win:frame().w,
				h = win:frame().h,
			}
		);
	end,
};

-- ==============================
-- Windows
-- ==============================

hs.window.animationDuration = 0; -- Never animate things.

hs.window.filter.new():subscribe( "windowCreated", functions.centerOnScreen ) -- Center all newly created windows.

-- ==============================
-- HazeOver Hacks
-- ==============================

-- When a window shows, poke HazeOver so it re-applies the overlay (sometimes it doesn't).
hs.window.filter.new():subscribe(
	{ "windowFocused", "windowVisible", "windowUnminimized", "windowCreated", "windowDestroyed" },
	function()
		-- Need to find a new poke method that works :(.
	end
)

-- When there is no window for an app, disable the HazeOver overlay (beacuse it sticks around normally).
hs.window.filter.new():subscribe(
	"hasNoWindows",
	function()
		-- Need to find a new poke method that works :(.
	end
)
