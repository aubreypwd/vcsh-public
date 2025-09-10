-- ===============================================
-- Hammerspoon Config
-- https://www.hammerspoon.org/docs/
-- ===============================================

-- ==============================
-- Global Vars
-- ==============================

millisecond = 1000;
oneSecond = millisecond * 1000;

-- Exclude these apps from being messed with.
alwaysExcludeApps = {
	['CleanShot X'] = true,
	['iBar Pro'] = true,
	['Hammerspoon'] = true,
	['superwhisper'] = true,
	['System Settings'] = true,
	['DockHelper'] = true,
	['Itsycal'] = true,
};

-- ==============================
-- Functions
-- ==============================
fn = {

	-- FUNCTION: Easy sleep function (so I don't have to remember the other one).
	sleep = function( microseconds )
		hs.timer.usleep( microseconds )
	end,

	-- ==============================
	-- Windows
	-- ==============================
	window = {

		-- FUNCTION: My version of win:isStandard() that takes into account Safari PWA's.
		isStandard = function( win )

			return win:isStandard()

				-- Safari PWA's won't pass win:isStandard(), but we can manually say they are.
				or win:application():bundleID():find( 'Safari.WebApp' );
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

			if fn.window.windowIsMaximized( win ) then
				return; -- The window is already maximized, don't do center.
			end

			if true ~= fn.window.isStandard( win ) then
				return; -- Only apply to standard windows.
			end

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or alwaysExcludeApps[ win:application():name()] ) then
				return; -- The window should not be fucked with.
			end

			fn.window.beforeCenter( win );
				hs.eventtap.keyStroke( { 'cmd', 'alt' }, 'space' ); -- Center by issuing the key combo for Rectangle Pro.
					fn.window.afterCenter( win );
		end,

			-- HOOK: Before we center any window.
			beforeCenter = function( win )
				-- Nothing now.
			end,

			-- HOOK: After we center any window.
			afterCenter = function( win )
				-- Nothing now.
			end,

		-- FUNCTION: Set the window's size based on application.
		setApplicationWindowSize = function( win )

			if fn.window.windowIsMaximized( win ) then
				return; -- The window is already maximized, don't do center.
			end

			if true ~= fn.window.isStandard( win ) then
				return; -- Only apply to standard windows.
			end

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or alwaysExcludeApps[ win:application():name()] ) then
				return; -- The window should not be fucked with.
			end

			local mapping = (
				{
					-- ['@aubreypwd']    = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['Calendar']      = { mods = { 'cmd', 'alt' }, key = '9' },
					['ChatGPT']       = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['Code']          = { mods = { 'cmd', 'alt' }, key = '9' },
					['Facebook']      = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['Finder']        = { mods = { 'cmd', 'alt' }, key = '8' },
					['Google Chrome'] = { mods = { 'cmd', 'alt' }, key = '9' },
					['iTerm2']        = { mods = { 'cmd', 'alt' }, key = '8' },
					['LinkedIn']      = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['Mail']          = { mods = { 'cmd', 'alt' }, key = '8' },
					['Mastodon']      = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['Messages']      = { mods = { 'cmd', 'alt' }, key = '7' },
					['Music']         = { mods = { 'cmd', 'alt' }, key = '8' },
					['News Explorer'] = { mods = { 'cmd', 'alt' }, key = '9' },
					['Notes']         = { mods = { 'cmd', 'alt' }, key = '9' },
					['Reminders']     = { mods = { 'cmd', 'alt' }, key = '7' },
					['Slack']         = { mods = { 'cmd', 'alt' }, key = '9' },
					['TablePlus']     = { mods = { 'cmd', 'alt' }, key = '9' },
					['Twitter']       = { mods = { 'cmd', 'alt' }, key = '7' },
					['Voice']         = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
					['YouTube']       = { mods = { 'cmd', 'alt' }, key = '9' },
				}
			)[ win:application():name() ] or { mods = { 'cmd', 'alt' }, key = '8' };

			hs.printf( hs.inspect( win:application():name() ) );

			-- Focus the window (in case the system has moved away for whatever reason)...
			win:focus();

				-- Trigger rectangle's combo for the app.
				hs.eventtap.keyStroke( mapping.mods, mapping.key, 0 );
			win:focus(); -- Focus again, in case the key combo moved windows.
		end,

		-- FUNCTION: A way to discover if a window is already maximized.
		windowIsMaximized = function( win )

			return math.abs( win:frame().x - win:screen():frame().x ) <= 2
				 and math.abs( win:frame().y - win:screen():frame().y ) <= 2
				 	and math.abs( ( win:frame().x + win:frame().w ) - ( win:screen():frame().x + win:screen():frame().w) ) <= 2
					 and math.abs( ( win:frame().y + win:frame().h ) - ( win:screen():frame().y + win:screen():frame().h) ) <= 2;
		end,
	},

	-- FUNCTION: Reload hammerspoon.
	reload = function( args )

		hs.console.clearConsole();
		hs.openConsole();
		hs.reload();
	end
};

-- ==============================
-- Windows
-- ==============================

hs.window.animationDuration = 0; -- Never animate things by default.

hs.window.filter.new():subscribe(
	"windowCreated",
	function( win )

		hs.printf( win:application():name() ); -- Easy way to get app name in console.

		-- Apply things to the windows.
		fn.window.centerOnScreen( win );
		fn.window.setApplicationWindowSize( win );
	end
); -- Center all newly created windows.

-- ==============================
-- Keyboard Shortcuts
-- ==============================

-- Reload Hammerspoon with ctrl+alt+cmd+\.
hs.hotkey.bind( { 'ctrl', 'alt', 'cmd' }, '\\', fn.reload );

-- Open the Hammerspoon console easily.
hs.hotkey.bind( { 'ctrl', 'alt', 'cmd', 'shift' }, '\\', hs.openConsole );