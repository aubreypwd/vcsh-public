-- ==============================
-- Constants
-- ==============================

ONE_SECOND = 1000000;

-- ==============================
-- Functions
-- ==============================

fn = {

	-- Easy sleep function.
	sleep = function( seconds )
		hs.timer.usleep( ONE_SECOND * seconds )
	end,

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

			if fn.window.windowIsMaximized( win ) then
				return; -- The window is already maximized, don't do center.
			end

			if true ~= win:isStandard() then
				return; -- Only apply to standard windows.
			end

			fn.sleep( 1 / 4 );

			-- Use macOS built in Window > Center via keyboard shortcuts (animated).
			hs.eventtap.keyStroke( { 'ctrl', 'fn' }, 'c' );

		end,

		-- A way to discover if a window is already maximized.
		windowIsMaximized = function( win )
			return
				math.abs(win:frame().x - win:screen():frame().x) <= 2
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

hs.window.filter.new():subscribe( "windowCreated", fn.window.centerOnScreen ); -- Center all newly created windows.
