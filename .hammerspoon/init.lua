-- ===============================================
-- Hammerspoon Config
-- https://www.hammerspoon.org/docs/
-- ===============================================

----
--- Configures personal Hammerspoon window management and keyboard shortcuts.
---
--- @since Unknown
--- @since August 21, 2026 Updated to be containing function.
----
local function manageWindowsAndSizes()

	-- ==============================
	-- Configuration
	-- ==============================

	local millisecond = 1000
	local oneSecond = millisecond * 1000

	-- Exclude these apps from being messed with.
	local alwaysExcludeApps = {
		[ "CleanShot X" ] = true,
		[ "iBar Pro" ] = true,
		[ "Hammerspoon" ] = true,
		[ "superwhisper" ] = true,
		[ "System Settings" ] = true,
		[ "Raycast" ] = true,
		[ "DockHelper" ] = true,
		[ "Itsycal" ] = true,
		[ "Instagram" ] = true,
		[ "PastePal" ] = true,
		[ "AppCleaner" ] = true,
		[ "Keka" ] = true,
		[ "Choosy" ] = true,
		[ "Homerow" ] = true,
		[ "Stickies" ] = true,
		[ "Blankie" ] = true,
		[ "Rectangle" ] = true,
		[ "Ice" ] = true,
		[ "Find Any File" ] = true,
		[ "UTM" ] = true,
		[ "Good Task" ] = true,
		[ "Clock" ] = true,
	}

	-- ==============================
	-- General Functions
	-- ==============================

	----
	--- Does nothing.
	---
	--- @since August 21, 2026
	---
	--- @return boolean Always false.
	----
	local function doNothing()
		return false
	end

	----
	--- Sleeps for the specified number of microseconds.
	---
	--- @since August 21, 2026
	---
	--- @param number microseconds Number of microseconds to sleep.
	----
	local function sleep( microseconds )
		hs.timer.usleep( microseconds )
	end

	-- ==============================
	-- Window Functions
	-- ==============================

	----
	--- Determines whether a window should be treated as a standard window.
	---
	--- Safari PWAs do not always pass Hammerspoon's native isStandard()
	--- check, so they are explicitly considered standard windows here.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	--- @return boolean Whether the window is considered standard.
	----
	local function isStandardWindow( win )

		local bundleID = win:application():bundleID() or ""

		return win:isStandard()
			or nil ~= bundleID:find( "Safari.WebApp", 1, true )
	end

	----
	--- Sets selected portions of a window frame while preserving unspecified values.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	--- @param number animation Animation duration.
	--- @param number|nil y Window Y position.
	--- @param number|nil x Window X position.
	--- @param number|nil h Window height.
	--- @param number|nil w Window width.
	----
	local function setWindowFrame( win, animation, y, x, h, w )

		local frame = win:frame()

		win:setFrame(
			{
				y = y or frame.y,
				x = x or frame.x,
				h = h or frame.h,
				w = w or frame.w,
			},
			animation
		)
	end

	----
	--- Determines whether a window fills the usable area of its current screen.
	---
	--- Allows a two-pixel tolerance for macOS window positioning differences.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	--- @return boolean Whether the window fills the screen.
	----
	local function windowIsFull( win )

		local windowFrame = win:frame()
		local screenFrame = win:screen():frame()

		return math.abs( windowFrame.x - screenFrame.x ) <= 2
			and math.abs( windowFrame.y - screenFrame.y ) <= 2
			and math.abs(
				( windowFrame.x + windowFrame.w )
				- ( screenFrame.x + screenFrame.w )
			) <= 2
			and math.abs(
				( windowFrame.y + windowFrame.h )
				- ( screenFrame.y + screenFrame.h )
			) <= 2
	end

	----
	--- Runs immediately before centering a window.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	----
	local function beforeCenter( win )
		-- Nothing now.
	end

	----
	--- Runs immediately after centering a window.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	----
	local function afterCenter( win )
		-- Nothing now.
	end

	----
	--- Centers a window using the configured Rectangle Pro shortcut.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	----
	local function centerWindowOnScreen( win )

		local appName = win:application():name()

		-- Apps listed here should not be centered.
		local excludeApps = {
			-- [ "Voice Memos" ] = true,
		}

		if true == windowIsFull( win ) then
			hs.printf( "[Centering Window] Already full: %s", appName )
			return
		end

		if true ~= isStandardWindow( win ) then
			hs.printf( "[Centering Window] Not a standard window: %s", appName )
			return
		end

		if true == excludeApps[ appName ] or true == alwaysExcludeApps[ appName ] then
			hs.printf( "[Centering Window] App excluded: %s", appName )
			return
		end

		hs.printf( "[Centering Window] Centering: %s", appName )

		beforeCenter( win )

		-- Center using Rectangle Pro.
		hs.eventtap.keyStroke( { "cmd", "alt" }, "space" )

		afterCenter( win )
	end

	----
	--- Sets a newly-created window's size based on its application.
	---
	--- Window sizes are applied using configured Rectangle Pro shortcuts.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Hammerspoon window.
	----
	local function setApplicationWindowSize( win )

		local appName = win:application():name()

		if true ~= isStandardWindow( win ) then
			hs.printf( "[Adjusting Window Size] Not a Standard Window: %s", appName )
			return
		end

		-- Apps listed here should not have their window size changed.
		local excludeApps = {
			-- [ "CleanShot X" ] = true,
		}

		if true == excludeApps[ appName ] or true == alwaysExcludeApps[ appName ] then
			hs.printf( "[Adjusting Window Size] Excluded App: %s", appName )
			return
		end

		-- Rectangle Pro key combinations.
		local slim = {
			mods = { "cmd", "alt" },
			key = "7",
		}

		local fat = {
			mods = { "cmd", "alt", "shift" },
			key = "7",
		}

		local chubby = {
			mods = { "cmd", "alt" },
			key = "8",
		}

		local big = {
			mods = { "cmd", "alt", "shift" },
			key = "8",
		}

		local medium = {
			mods = { "cmd", "alt" },
			key = "9",
		}

		local max = {
			mods = { "cmd", "alt", "shift" },
			key = "9",
		}

		local full = {
			mods = { "cmd", "alt" },
			key = "0",
		}

		-- Map applications to their Rectangle Pro window size.
		local mapping = {
			-- Finder
			[ "Finder" ] = chubby,

			-- AI
			[ "ChatGPT Atlas" ] = slim,
			[ "ChatGPT" ] = slim,
			[ "Perplexity" ] = slim,

			-- Coding
			[ "Code" ] = full,
			[ "Sublime Text" ] = medium,

			-- Browsers
			[ "Safari" ] = big,
			[ "Google Chrome" ] = big,
			[ "Chromium" ] = big,

			-- Misc
			-- [ "Claude" ] = fat,
			-- [ "Contacts" ] = fat,
			-- [ "@aubreypwd" ] = fat,
			-- [ "Books" ] = fat,
			-- [ "Calendar" ] = max,
			-- [ "Facebook" ] = fat,
			-- [ "Freedcamp" ] = fat,
			-- [ "iTerm2" ] = chubby,
			-- [ "KanbanFlow" ] = max,
			-- [ "LinkedIn" ] = fat,
			-- [ "Mail" ] = chubby,
			-- [ "Mastodon" ] = fat,
			-- [ "Messages" ] = slim,
			-- [ "Music" ] = chubby,
			-- [ "Instagram" ] = slim,
			-- [ "News Explorer" ] = medium,
			-- [ "Notes" ] = medium,
			-- [ "Passwords" ] = fat,
			-- [ "Reminders" ] = slim,
			-- [ "Slack" ] = medium,
			-- [ "TablePlus" ] = medium,
			-- [ "Twitter" ] = slim,
			-- [ "PageSpeed Insights" ] = slim,
			-- [ "Voice" ] = fat,
			-- [ "WhatsApp" ] = fat,
			-- [ "YouTube" ] = max,
			-- [ "Voice Memos" ] = slim,
		}

		local windowSize = mapping[ appName ]

		if nil == windowSize then
			hs.printf( "[Adjusting Window Size] App not configured: %s", appName )
			return
		end

		-- Focus the window in case macOS has moved focus elsewhere.
		win:focus()

		-- Trigger Rectangle Pro's configured shortcut.
		hs.eventtap.keyStroke( windowSize.mods, windowSize.key, 0 )

		-- Focus again in case resizing caused macOS to move focus.
		win:focus()

		hs.printf( "[Adjusting Window Size] Set window size of: %s", appName )
	end

	-- ==============================
	-- Hammerspoon Functions
	-- ==============================

	----
	--- Reloads the Hammerspoon configuration.
	---
	--- @since August 21, 2026
	----
	local function reloadHammerspoon()

		hs.console.clearConsole()
		hs.openConsole()
		hs.reload()

		hs.printf( "[Hammerspoon] Reloaded Config" )
	end

	----
	--- Handles newly-created windows.
	---
	--- @since August 21, 2026
	---
	--- @param userdata win Newly-created Hammerspoon window.
	----
	local function handleWindowCreated( win )

		local title = win:title() or ""

		hs.printf( "%s", win:application():name() )
		hs.printf( "%s", title )

		-- Center newly-created windows when desired.
		-- centerWindowOnScreen( win )

		-- Do not resize the iTerm2 Quick Command window.
		if nil ~= string.find( title, "Quick Command", 1, true ) then
			return
		end

		setApplicationWindowSize( win )
	end

	-- ==============================
	-- Windows
	-- ==============================

	-- Never animate Hammerspoon window changes by default.
	hs.window.animationDuration = 0

	-- Keep references to long-lived Hammerspoon objects so they remain active
	-- after this configuration function finishes.
	local runtime = {}

	runtime.windowFilter = hs.window.filter.new()

	runtime.windowFilter:subscribe(
		"windowCreated",
		handleWindowCreated
	)

	-- ==============================
	-- Keyboard Shortcuts
	-- ==============================

	-- Reload Hammerspoon with ctrl+alt+cmd+\.
	runtime.reloadHotkey = hs.hotkey.bind(
		{ "ctrl", "alt", "cmd" },
		"\\",
		reloadHammerspoon
	)

	-- Open the Hammerspoon console with ctrl+alt+cmd+shift+\.
	runtime.consoleHotkey = hs.hotkey.bind(
		{ "ctrl", "alt", "cmd", "shift" },
		"\\",
		hs.openConsole
	)

	-- Store the runtime references globally so Hammerspoon does not
	-- garbage-collect the filter or hotkeys after this function returns.
	_G.personalHammerspoonConfig = runtime
end; manageWindowsAndSizes()

----
--- Enables current-Space behavior for Google Chrome PWA Dock clicks.
---
--- Chrome PWAs normally switch to an existing window on another macOS Space
--- when their Dock icon is clicked. This intercepts that Dock click and:
---
--- 1. Leaves PWAs assigned to a Desktop with their normal Dock behavior.
--- 2. Focuses the PWA window if one exists on the current Space.
--- 3. Opens a new PWA window if one does not exist on the current Space.
--- 4. Leaves excluded PWAs and all non-PWA apps completely untouched.
--- 5. Preserves normal Dock icon dragging.
---
--- @since August 21, 2026
----
local function fixChromePWADockBehavior()

	-- PWAs listed here keep their normal macOS/Chrome Dock behavior regardless of their Desktop assignment.
	local excludedChromePWAs = {
		-- [ "Google Drive" ] = true,
		[ "Google Meet" ] = true,
		[ "Local" ] = true, -- Not sure why it's picking this up as a PWA, maybe because it's electron?
	}

	----
	--- Checks whether an application has been explicitly assigned to a macOS Desktop.
	---
	--- This includes "This Desktop" and "All Desktops". macOS may use an
	--- empty string for the primary Desktop, so any existing binding counts.
	---
	--- @since August 21, 2026
	---
	--- @param string bundleID Application bundle identifier.
	--- @return boolean Whether the application has a Desktop assignment.
	----
	local function isAppAssignedToDesktop( bundleID )

		-- Export the current Spaces preferences so we read the active macOS configuration.
		local output, status = hs.execute( "/usr/bin/defaults export com.apple.spaces -" )

		if true ~= status or "" == output then
			return false
		end

		local spaces = hs.plist.readString( output )

		if nil == spaces or nil == spaces[ "app-bindings" ] then
			return false
		end

		-- macOS stores application bindings using lowercase bundle identifiers.
		local bindings = spaces[ "app-bindings" ]
		local normalizedBundleID = bundleID:lower()

		return nil ~= bindings[ normalizedBundleID ]
	end

	-- Stores information about a PWA click while we wait to see if it becomes a drag.
	local pendingChromePWA = nil

	-- Stores the original mouse-down event so it can be replayed if the gesture becomes a drag.
	local pendingMouseDown = nil

	-- Tracks whether the current PWA mouse gesture became a drag.
	local dragging = false

	-- Listen for Dock mouse clicks and drags.
	_G.chromePWADockBlocker = hs.eventtap.new(
		{
			hs.eventtap.event.types.leftMouseDown,
			hs.eventtap.event.types.leftMouseDragged,
			hs.eventtap.event.types.leftMouseUp,
		},

		-- Run this function when it happens.
		function( event )

			local eventType = event:getType()

			----
			-- Dragging
			--
			-- We originally swallowed mouse-down so Chrome could not perform
			-- its normal Dock activation. Once we know this gesture is actually
			-- a drag, replay that original mouse-down to the Dock and allow the
			-- real drag events to continue normally.
			----
			if hs.eventtap.event.types.leftMouseDragged == eventType then

				if nil == pendingChromePWA or nil == pendingMouseDown then
					return false
				end

				if true ~= dragging then

					dragging = true

					-- Temporarily stop this event tap so it does not intercept
					-- the mouse-down event we are about to replay.
					_G.chromePWADockBlocker:stop()

					pendingMouseDown:post()

					_G.chromePWADockBlocker:start()

					-- We only need to replay mouse-down once.
					pendingMouseDown = nil
				end

				-- Let the Dock receive the real drag event.
				return false
			end

			----
			-- Mouse Up
			--
			-- At this point we know whether the gesture was a click or a drag.
			----
			if hs.eventtap.event.types.leftMouseUp == eventType then

				if nil == pendingChromePWA then
					return false
				end

				-- If this became a drag, the Dock already received our replayed
				-- mouse-down and the real drag events. Let it receive mouse-up too.
				if true == dragging then

					pendingChromePWA = nil
					pendingMouseDown = nil
					dragging = false

					return false
				end

				-- This was a normal click, so handle the Chrome PWA ourselves.
				local chromePWA = pendingChromePWA

				pendingChromePWA = nil
				pendingMouseDown = nil
				dragging = false

				-- Hammerspoon's visibleWindows() gives us the PWA windows available on the current Mission Control Space.
				local windows = chromePWA.app:visibleWindows()

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
				----
				local task = hs.task.new(
					"/usr/bin/open",
					nil,
					{
						"-a",
						chromePWA.appPath,
						chromePWA.info.CrAppModeShortcutURL,
					}
				)

				if nil ~= task then
					task:start()
				end

				-- Swallow mouse-up because the Dock never received mouse-down
				-- and should not perform its normal Chrome PWA activation.
				return true
			end

			-- A new mouse-down starts a new gesture.
			pendingChromePWA = nil
			pendingMouseDown = nil
			dragging = false

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

			-- Excluded PWAs should behave exactly as they normally would.
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
				or nil == info.CrAppModeShortcutURL
				or nil == info.CFBundleIdentifier then
					return false
			end

			-- Apps explicitly assigned to a Desktop should retain normal macOS Dock behavior.
			if true == isAppAssignedToDesktop( info.CFBundleIdentifier ) then
				return false
			end

			----
			-- This is a Chrome PWA we want to manage.
			--
			-- Save everything we need, then swallow mouse-down. If this later
			-- becomes a drag, the original mouse-down will be replayed to Dock.
			----
			pendingChromePWA = {
				app = app,
				appPath = appPath,
				info = info,
			}

			pendingMouseDown = event:copy()

			-- Prevent Chrome from receiving the normal Dock activation.
			return true
		end
	)

	-- Keep the event tap running.
	_G.chromePWADockBlocker:start()
end; fixChromePWADockBehavior()