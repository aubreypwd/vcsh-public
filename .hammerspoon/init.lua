-- ==============================
-- Constants
-- ==============================

SECOND = 1000000;

-- ==============================
-- Functions
-- ==============================

functions = {

	-- ==============================
	-- Windows
	-- ==============================
	window = {

		-- My version of :centerOnScreen.
		centerOnScreen = function( win )

			-- Apps to exclude from doing this...
			local excludeApps = {
				["CleanShot X"] = true,
				["iBar Pro"] = true,
			};

			if excludeApps[ win:application():name() ] then
				return; -- The window should not be fucked with.
			end

			if functions.window.windowIsMaximized( win ) then
				return; -- The window is already maximized, don't do center.
			end

			hs.timer.usleep( SECOND / 2 ); -- This makes it feel less jarring.

			-- Use macOS built in Window > Center via keyboard shortcuts (animated).
			hs.eventtap.keyStroke( { 'ctrl', 'fn' }, 'c' );

		end,

		-- A way to discover if a window is already maximized.
		windowIsMaximized = function( win )

			return math.abs(win:frame().x - win:screen():frame().x) <= 2
				and math.abs(win:frame().y - win:screen():frame().y) <= 2
				and math.abs((win:frame().x + win:frame().w) - (win:screen():frame().x + win:screen():frame().w)) <= 2
				and math.abs((win:frame().y + win:frame().h) - (win:screen():frame().y + win:screen():frame().h)) <= 2
		end,
	},
};

-- ==============================
-- Windows
-- ==============================

hs.window.animationDuration = 0; -- Never animate things.

hs.window.filter.new():subscribe( "windowCreated", functions.window.centerOnScreen ) -- Center all newly created windows.

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
