-- ===============================================
-- Hammerspoon Config
-- https://www.hammerspoon.org/docs/
-- ===============================================

-- ==============================
-- Constants
-- ==============================

ONE_SECOND = 1000000;

-- ==============================
-- Functions
-- ==============================
fn = {

	-- FUNCTION: Easy sleep function.
	sleep = function( seconds )
		hs.timer.usleep( ONE_SECOND * seconds )
	end,

	-- ==============================
	-- Windows
	-- ==============================
	window = {

		-- HOOK: Before we modify any window.
		before = function( win )

			-- Finder: Always set the window size to this.
			if 'Finder' == win:application():name() then
				fn.window.setFrame( win, 0, 91, 101, 1013, 1620 );
			end
		end,

		-- HOOK: After we modify any window.
		after = function( win )

			-- iTerm2: Move up a bit because by default my hands are in the way.
			if 'iTerm2' == win:application():name() then

				fn.sleep( 1 / 2 );

				fn.window.setFrame( win, 0.4, win:frame().y - 22, nill, nill, nill );
			end
		end,

		-- FUNCTION: My version of :setFrame.
		setFrame = function( win, animation, y, x, h, w )
			win:setFrame(
				{
					y = y or win:frame().y,
					x = x or win:frame().x,
					h = h or win:frame().h,
					w = w or win:frame().w,
				},
				animation
			);
		end,

		-- FUNCTION: My version of :centerOnScreen.
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

			fn.window.before( win );

			fn.sleep( 1 / 4 ); -- Makes feel less janky.

			hs.eventtap.keyStroke( { 'ctrl', 'fn' }, 'c' ); -- Use macOS built in Window > Center via keyboard shortcuts (animated).

			fn.window.after( win );
		end,

		-- FUNCTION: A way to discover if a window is already maximized.
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

hs.window.animationDuration = 0; -- Never animate things by default.
hs.window.filter.new():subscribe( "windowCreated", fn.window.centerOnScreen ); -- Center all newly created windows.
