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
	['Raycast'] = true,
	['DockHelper'] = true,
	['Itsycal'] = true,
	['Instagram'] = true,
	['PastePal'] = true,
	['AppCleaner'] = true,
	['Keka'] = true,
	['Choosy'] = true,
	['Homerow'] = true,
	['Stickies'] = true,
	['Blankie'] = true,
	['Rectangle'] = true,
	['Ice'] = true,
	['Find Any File'] = true,
	['UTM'] = true,
	['Good Task'] = true,
	['Clock'] = true,
};

-- ==============================
-- Functions
-- ==============================
fn = {

	-- FUNCTION: That does nothing.
	doNothing = function()
		return false;
	end,

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

			local mapping = (
				{
					-- ['Voice Memos'] = true,
				}
			)[ win:application():name() ] or true;

			if false == mapping then
				hs.printf( '[Centering Window] App set to not center: ' .. win:application():name() );
				return;
			end

			if fn.window.windowIsMaximized( win ) then
				hs.printf( '[Centering Window] Already maximized: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- The window is already maximized, don't do center.
			end

			if true ~= fn.window.isStandard( win ) then

				hs.printf( '[Centering Window] Not a standard window: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- Only apply to standard windows.
			end

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or alwaysExcludeApps[ win:application():name()] ) then

				hs.printf( '[Centering Window] App excluded: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- The window should not be fucked with.
			end

			hs.printf( '[Centering Window] Centering: ' .. win:application():name() ); -- Easy way to get app name in console.

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

			if true ~= fn.window.isStandard( win ) then

				hs.printf( '[Adjusting Window Size] Not a Standard Window: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- Only apply to standard windows.
			end

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or alwaysExcludeApps[ win:application():name()] ) then

				hs.printf( '[Adjusting Window Size] Excluded App: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- The window should not be fucked with.
			end

			-- Rectangle key combos.
			local slim            = { mods = { 'cmd', 'alt' }, key = '7' };
			local fat             = { mods = { 'cmd', 'alt', 'shift' }, key = '7' };
			local almostMaximized = { mods = { 'cmd', 'alt' }, key = '8' };
			local medium          = { mods = { 'cmd', 'alt' }, key = '9' };
			local max             = { mods = { 'cmd', 'alt', 'shift' }, key = '9' };
			local maximized       = { mods = { 'cmd', 'alt' }, key = '0' };

			-- App mapping.
			local mapping = (
				{
					['Claude'] = fat,
					['Contacts'] = fat,
					['@aubreypwd'] = fat,
					['Books'] = fat,
					['Calendar'] = max,
					['ChatGPT'] = fat,
					['Code'] = max,
					['Facebook'] = fat,
					['Finder'] = almostMaximized,
					['Freedcamp'] = fat,
					['Chrome'] = medium,
					['iTerm2'] = almostMaximized,
					['KanbanFlow'] = max,
					['LinkedIn'] = fat,
					['Mail'] = almostMaximized,
					['Mastodon'] = fat,
					['Messages'] = slim,
					['Music'] = almostMaximized,
					['Instagram'] = slim,
					['News Explorer'] = medium,
					['Notes'] = medium,
					['Passwords'] = fat,
					['Reminders'] = slim,
					['Safari'] = medium,
					['Slack'] = medium,
					['Sublime Text'] = maximized,
					['TablePlus'] = medium,
					['Twitter'] = slim,
					['PageSpeed Insights'] = slim,
					['Voice'] = fat,
					['WhatsApp'] = fat,
					['YouTube'] = max,
					['Voice Memos'] = slim,
				}
			)[ win:application():name() ] or false;

			if false == mapping then
				hs.printf( '[Adjusting Window Size] App not configured: ' .. win:application():name() );
				return;
			end

			-- Focus the window (in case the system has moved away for whatever reason)...
			win:focus();

				-- Trigger rectangle's combo for the app.
			hs.eventtap.keyStroke( mapping.mods, mapping.key, 0 );
			win:focus(); -- Focus again, in case the key combo moved windows.

			hs.printf( '[Adjusting Window Size] Set window size of: ' .. win:application():name() ); -- Easy way to get app name in console.
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

		hs.printf( '[Hammerspoon] Reloaded Config' ); -- Easy way to get app name in console.
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
		hs.printf( win:title() ); -- Display window title.

		-- Apply things to the windows..
		fn.window.centerOnScreen( win );

		if string.find( win:title() or '', 'Quick Command' ) then
			return -- Do not resize the Quick Command iTerm2 window.
		end

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

