-- ===============================================
-- Hammerspoon Config
-- https://www.hammerspoon.org/docs/
-- ===============================================

-- ==============================
-- Global Vars
-- ==============================

millisecond = 1000;
one_second = millisecond * 1000;
keyboard_launcher_modal = hs.hotkey.modal.new( { 'alt' }, 'g' );

-- Exclude these apps from being messed with.
always_excluded_apps = {
	['CleanShot X'] = true,
	['iBar Pro'] = true,
	['Hammerspoon'] = true,
	['superwhisper'] = true,
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
	-- Keyboard Launcher
	--
	-- The chord alt(hold)+l - <key> will launch the app you bind to it.
	-- e.g. fn.keyboardLauncher.bind( 'f', 'Finder' ); will launch Finder.
	-- ==============================
	keyboardLauncher = {

		-- Bind a key to the launcher.
		bind = function( key, app )

			-- Then listen for another alt + key to launch the assigned app.
			keyboard_launcher_modal:bind(
				{ 'alt' }, key,
				nil,
				function()

					if hs.application.launchOrFocus( app ) then
						keyboard_launcher_modal:exit();
					else
						hs.alert.show( string.format( 'Unable to launch %s', app ) );
					end
				end
			);
		end
	},

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

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or always_excluded_apps[ win:application():name()] ) then
				return; -- The window should not be fucked with.
			end

			if fn.window.windowIsMaximized( win ) then
				return; -- The window is already maximized, don't do center.
			end

			if true ~= fn.window.isStandard( win ) then
				return; -- Only apply to standard windows.
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

			-- Apps to exclude from doing this...
			local excludeApps = {
				-- ["CleanShot X"] = true,
			};

			if ( excludeApps[ win:application():name() ] or always_excluded_apps[ win:application():name()] ) then
				return; -- The window should not be fucked with.
			end

			local mapping = ( {
				['Finder']        = { mods = { 'cmd', 'alt' }, key = '8' },
				['TablePlus']     = { mods = { 'cmd', 'alt' }, key = '9' },
				['iTerm2']        = { mods = { 'cmd', 'alt' }, key = '8' },
				['Notes']         = { mods = { 'cmd', 'alt' }, key = '9' },
				['Code']          = { mods = { 'cmd', 'alt' }, key = '9' },
				['Google Chrome'] = { mods = { 'cmd', 'alt' }, key = '9' },
				['Reminders']     = { mods = { 'cmd', 'alt' }, key = '7' },
				['Calendar']      = { mods = { 'cmd', 'alt' }, key = '9' },
				['News Explorer'] = { mods = { 'cmd', 'alt' }, key = '9' },
				['Twitter']       = { mods = { 'cmd', 'alt' }, key = '7' },
				['Mastodon']      = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
				['Voice']         = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
				['Slack']         = { mods = { 'cmd', 'alt' }, key = '9' },
				['Messages']      = { mods = { 'cmd', 'alt' }, key = '7' },
				['WhatsApp']      = { mods = { 'cmd', 'alt' }, key = '7' },
				['LinkedIn']      = { mods = { 'cmd', 'alt', 'shift' }, key = '7' },
			} )[ win:application():name() ]
				or { mods = { 'cmd', 'alt' }, key = '8' }; -- Default app size.

			-- Trigger rectangle's combo for the app.
			hs.eventtap.keyStroke( mapping.mods, mapping.key, 0 );
		end,

		-- FUNCTION: A way to discover if a window is already maximized.
		windowIsMaximized = function( win )

			return math.abs( win:frame().x - win:screen():frame().x ) <= 2
				 and math.abs( win:frame().y - win:screen():frame().y ) <= 2
				 	and math.abs( ( win:frame().x + win:frame().w ) - ( win:screen():frame().x + win:screen():frame().w) ) <= 2
					 and math.abs( ( win:frame().y + win:frame().h ) - ( win:screen():frame().y + win:screen():frame().h) ) <= 2;
		end,
	},
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
hs.hotkey.bind(
	{ 'ctrl', 'alt', 'cmd' }, '\\',
	function()
		hs.console.clearConsole();
		hs.openConsole();
		hs.reload();
	end
);

-- Open the Hammerspoon console easily.
hs.hotkey.bind( { 'ctrl', 'alt', 'cmd', 'shift' }, '\\', hs.openConsole );

-- App launchers.
fn.keyboardLauncher.bind( ',', 'System Settings' );
fn.keyboardLauncher.bind( 'c', 'Calendar' );
fn.keyboardLauncher.bind( 'e', 'Sublime Text' ); -- (e)ditor.
fn.keyboardLauncher.bind( 'f', 'Finder' );
fn.keyboardLauncher.bind( 'g', 'ChatGPT' );
fn.keyboardLauncher.bind( 'h', 'Google Chrome' );
fn.keyboardLauncher.bind( 'm', 'Music' );
fn.keyboardLauncher.bind( 'n', 'Notes' );
fn.keyboardLauncher.bind( 'r', 'Reminders' );
fn.keyboardLauncher.bind( 'i', 'Messages' );
fn.keyboardLauncher.bind( 't', 'iTerm' );
fn.keyboardLauncher.bind( 'w', 'Safari' );
fn.keyboardLauncher.bind( 'y', 'YouTube' ); -- Fuck why did I add this?
