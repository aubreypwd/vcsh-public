-- ===============================================
-- Hammerspoon Config
-- https://www.hammerspoon.org/docs/
-- ===============================================

-- ==============================
-- Constants
-- ==============================

MILLISECOND = 1000;
ONE_SECOND = MILLISECOND * 1000;
KEYBOARD_LAUNCHER_MODAL = hs.hotkey.modal.new( { 'alt' }, 'g' );

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
			KEYBOARD_LAUNCHER_MODAL:bind(
				{ 'alt' }, key,
				nil,
				function()

					if hs.application.launchOrFocus( app ) then
						KEYBOARD_LAUNCHER_MODAL:exit();
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

			fn.window.beforeCenter( win );
			hs.eventtap.keyStroke( { 'ctrl', 'fn' }, 'c' ); -- Use macOS built in Window > Center via keyboard shortcuts (animated).
			fn.window.afterCenter( win );
		end,

			-- HOOK: Before we center any window.
			beforeCenter = function( win )
				if 'Finder' == win:application():name() then fn.window.setFrame( win, 0, 91, 101, 1013, 1620 ); end -- Always set the window size to this.
				if 'PLIST Editor' == win:application():name() then fn.window.setFrame( win, 0, 91, 101, 1013, 1620 ); end -- pList can make super tiny annoying windows.
			end,

			-- HOOK: After we center any window.
			afterCenter = function( win )

				fn.sleep( ONE_SECOND / 2 ); -- Always give MacOS time to finish the animation of centering.

				if 'iTerm2' == win:application():name() then fn.window.setFrame( win, 0.2, win:frame().y - 22, nill, nill, nill ); end -- iTerm needs to be bumped up after centering because the bottom line gets hidden by my hands.
			end,

		-- FUNCTION: A way to discover if a window is already maximized.
		windowIsMaximized = function( win )
			return math.abs( win:frame().x - win:screen():frame().x ) <= 2
				 and math.abs( win:frame().y - win:screen():frame().y ) <= 2
				 and math.abs( ( win:frame().x + win:frame().w ) - ( win:screen():frame().x + win:screen():frame().w) ) <= 2
				 and math.abs( ( win:frame().y + win:frame().h ) - ( win:screen():frame().y + win:screen():frame().h) ) <= 2
		end,
	},
};

-- ==============================
-- Windows
-- ==============================

hs.window.animationDuration = 0; -- Never animate things by default.
hs.window.filter.new():subscribe( "windowCreated", fn.window.centerOnScreen ); -- Center all newly created windows.

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

-- Open new ChatGPT window with cmd+`.
hs.hotkey.bind(
	{ 'alt' }, '`',
	function()
		hs.application.launchOrFocus( hs.fs.pathToAbsolute( "~/Applications/ChatGPT.app" ) );
		hs.eventtap.keyStroke( { 'cmd' }, 'n' ); -- Open new window.
	end
);

-- App launchers.
fn.keyboardLauncher.bind( ',', 'System Settings' );
fn.keyboardLauncher.bind( 'c', 'Calendar' );
fn.keyboardLauncher.bind( 'e', 'Sublime Text' ); -- (e)ditor.
fn.keyboardLauncher.bind( 'f', 'Finder' );
fn.keyboardLauncher.bind( 'g', hs.fs.pathToAbsolute( "~/Applications/ChatGPT.app" ) );
fn.keyboardLauncher.bind( 'h', 'Google Chrome' );
fn.keyboardLauncher.bind( 'm', 'Music' );
fn.keyboardLauncher.bind( 'n', 'Notes' );
fn.keyboardLauncher.bind( 'r', 'Reminders' );
fn.keyboardLauncher.bind( 't', 'iTerm' );
fn.keyboardLauncher.bind( 'w', 'Safari' );
fn.keyboardLauncher.bind( 'y', 'YouTube' ); -- Fuck why did I add this?
