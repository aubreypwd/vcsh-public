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

			if fn.window.windowIsFull( win ) then
				hs.printf( '[Centering Window] Already full: ' .. win:application():name() ); -- Easy way to get app name in console.
				return; -- The window is already full, don't do center.
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
			local chubby          = { mods = { 'cmd', 'alt' }, key = '8' };
			local big             = { mods = { 'cmd', 'alt', 'shift' }, key = '8' };
			local medium          = { mods = { 'cmd', 'alt' }, key = '9' };
			local max             = { mods = { 'cmd', 'alt', 'shift' }, key = '9' };
			local full            = { mods = { 'cmd', 'alt' }, key = '0' };

			-- App mapping.
			local mapping = (
				{
					-- Finder
					['Finder'] = chubby,

					-- AI
					['ChatGPT Atlas'] = slim,
					['ChatGPT'] = slim,
					['Perplexity'] = slim,

					-- Coding
					['Code'] = full,
					['Sublime Text'] = medium,

					-- Browsers
					['Safari'] = big,
					['Google Chrome'] = big,
					['Chromium'] = big,

					-- Misc
					-- ['Claude'] = fat,
					-- ['Contacts'] = fat,
					-- ['@aubreypwd'] = fat,
					-- ['Books'] = fat,
					-- ['Calendar'] = max,
					-- ['Facebook'] = fat,
					-- ['Freedcamp'] = fat,
					-- ['iTerm2'] = chubby,
					-- ['KanbanFlow'] = max,
					-- ['LinkedIn'] = fat,
					-- ['Mail'] = chubby,
					-- ['Mastodon'] = fat,
					-- ['Messages'] = slim,
					-- ['Music'] = chubby,
					-- ['Instagram'] = slim,
					-- ['News Explorer'] = medium,
					-- ['Notes'] = medium,
					-- ['Passwords'] = fat,
					-- ['Reminders'] = slim,
					-- ['Slack'] = medium,
					-- ['TablePlus'] = medium,
					-- ['Twitter'] = slim,
					-- ['PageSpeed Insights'] = slim,
					-- ['Voice'] = fat,
					-- ['WhatsApp'] = fat,
					-- ['YouTube'] = max,
					-- ['Voice Memos'] = slim,
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

		-- FUNCTION: A way to discover if a window is already full.
		windowIsFull = function( win )

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
		-- fn.window.centerOnScreen( win );

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


----
--- Enables current-Space behavior for Google Chrome PWA Dock clicks.
---
--- Chrome PWAs normally switch to an existing window on another macOS Space
--- when their Dock icon is clicked. This intercepts that Dock click and:
---
--- 1. Focuses the PWA window if one exists on the current Space.
--- 2. Opens a new PWA window if one does not exist on the current Space.
--- 3. Leaves excluded PWAs and all non-PWA apps completely untouched.
---
--- @since August 21, 2026
----
local function fixChromePWADockBehavior()

	-- PWAs listed here keep their normal macOS/Chrome Dock behavior.
	local excludedChromePWAs = {
		[ "YouTube" ] = true,
		[ "Google Drive" ] = true,
		[ "Google Meet" ] = true,
	}

	-- Tracks whether we swallowed mouse-down so we can also swallow the corresponding mouse-up event.
	local swallowing = false

	-- Listen for Dock mouse clicks.
	_G.chromePWADockBlocker = hs.eventtap.new(
		{ hs.eventtap.event.types.leftMouseDown, hs.eventtap.event.types.leftMouseUp, },

		-- Run this function when it happens.
		function( event )

			-- If we intercepted mouse-down, intercept mouse-up too so the Dock never receives a partial click.
			if hs.eventtap.event.types.leftMouseUp == event:getType() then
				if true == swallowing then

					swallowing = false
					return true
				end

				return false
			end

			-- Determine which accessibility element was clicked.
			local element = hs.axuielement.systemElementAtPosition( event:location() )
			if nil == element then
				return false
			end

			-- Ignore anything that was not clicked inside the macOS Dock.
			local dock = hs.application.get( "Dock" )
			if nil == dock or element:pid() ~= dock:pid() then
				return false
			end

			-- Walk up the accessibility hierarchy until we find the actual application Dock item.
			local dockItem
			for _, item in ipairs( element:path() ) do
				if "AXApplicationDockItem" == item:attributeValue( "AXSubrole" ) then
					dockItem = item
					break
				end
			end

			if nil == dockItem then
				return false
			end

			-- Get the application name shown in the Dock.
			local appName = dockItem:attributeValue( "AXTitle" )
			if nil == appName then
				return false
			end

			-- Excluded apps should behave exactly as they normally would.
			if true == excludedChromePWAs[ appName ] then
				return false
			end

			-- Find the running application associated with this Dock item. If it is not running yet, let the Dock launch it normally.
			local app = hs.application.get( appName )
			if nil == app then
				return false
			end

			-- Find the application's actual .app bundle.
			local appPath = app:path()
			if nil == appPath then
				return false
			end

			local info = hs.application.infoForBundlePath( appPath )
			if nil == info then
				return false
			end

			-- Chrome PWAs contain these app-shim metadata values. Anything else should retain its normal Dock behavior.
			if "com.google.Chrome" ~= info.CrBundleIdentifier
				or nil == info.CrAppModeShortcutID
				or nil == info.CrAppModeShortcutURL then
					return false
			end

			-- From this point onward we are handling the Dock click ourselves, so prevent the Dock from receiving both parts of the click.
			swallowing = true

			-- Hammerspoon's visibleWindows() only gives us visible windows available on the current Mission Control Space.
			local windows = app:visibleWindows()

			-- If this PWA already has a window on the current Space, focus that window instead of allowing Chrome to switch Spaces.
			if nil ~= windows[ 1 ] then

				windows[ 1 ]:focus()
				return true
			end

			----
			-- There is no PWA window on this Space.
			--
			-- Opening the PWA's own launch URL through its .app bundle creates
			-- a new PWA window on the current Space instead of switching to an
			-- existing window somewhere else.
			---
			local task = hs.task.new( "/usr/bin/open", nil, { "-a", appPath, info.CrAppModeShortcutURL } )
			if nil ~= task then
				task:start()
			end

			return true
		end
	)

	-- Keep the event tap running.
	_G.chromePWADockBlocker:start()
end
fixChromePWADockBehavior()