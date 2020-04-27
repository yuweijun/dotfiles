local hyper = {'ctrl', 'alt', 'cmd'}
local hyperShift = {'ctrl', 'alt', 'cmd', 'shift'}

--------------------------------------------------------------------------------
---------------------------- Hotkey app management -----------------------------
--------------------------------------------------------------------------------

hs.hotkey.bind({'ctrl'}, "/", function() hs.application.launchOrFocus('finder') end)
hs.hotkey.bind({'ctrl'}, ".", function() hs.application.launchOrFocus('iTerm') end)
hs.hotkey.bind({'ctrl'}, ",", function() hs.application.launchOrFocus('Google Chrome') end)
hs.hotkey.bind({'ctrl'}, ";", function() hs.application.launchOrFocus('Intellij IDEA CE') end)
hs.hotkey.bind({'ctrl'}, "'", function() hs.application.launchOrFocus('Evernote') end)
hs.hotkey.bind({'ctrl'}, "[", function() hs.execute('~/.hammerspoon/bin/google', true) end)
hs.hotkey.bind({'ctrl'}, "]", function() hs.execute('~/.hammerspoon/bin/translate', true) end)

--------------------------------------------------------------------------------
------------------------------ Window management -------------------------------
-- https://spinscale.de/posts/2016-11-08-creating-a-productive-osx-environment-hammerspoon.html
--------------------------------------------------------------------------------
function baseMove(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        -- add max.x so it stays on the same screen, works with my second screen
        f.x = max.w * x + max.x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

-------- Key bindings : feature spectacle/another window sizing apps
hs.hotkey.bind(hyper, 'Left', baseMove(0, 0, 0.5, 1))
hs.hotkey.bind(hyper, 'Right', baseMove(0.5, 0, 0.5, 1))
hs.hotkey.bind(hyper, 'Down', baseMove(0, 0.5, 1, 0.5))
hs.hotkey.bind(hyper, 'Up', baseMove(0, 0, 1, 0.5))
hs.hotkey.bind(hyper, '1', baseMove(0, 0, 0.5, 0.5))
hs.hotkey.bind(hyper, '2', baseMove(0.5, 0, 0.5, 0.5))
hs.hotkey.bind(hyper, '3', baseMove(0, 0.5, 0.5, 0.5))
hs.hotkey.bind(hyper, '4', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind(hyper, '5', hs.grid.maximizeWindow)

-- lock screen shortcut
hs.hotkey.bind(hyper, 'L', function()
    hs.caffeinate.startScreensaver()
end)
hs.hotkey.bind(hyper, "R", function()
    hs.reload()
    hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
end)
hs.hotkey.bind(hyper, "C", function()
    hs.application.get("Hammerspoon"):selectMenuItem("Console...")
    hs.application.launchOrFocus("Hammerspoon")
end)

--------------------------------------------------------------------------------
-------------------- remapping control+hjkl to arrow keys ----------------------
--------- https://github.com/kkamdooong/hammerspoon-control-hjkl-to-arrow ------
--------------------------------------------------------------------------------

local function pressFn(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end

    return function() hs.eventtap.keyStroke(mods, key, 800) end
end

local function remap(mods, key, pressFn)
    hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

remap({'ctrl'}, 'h', pressFn('left'))
remap({'ctrl'}, 'j', pressFn('down'))
remap({'ctrl'}, 'k', pressFn('up'))
remap({'ctrl'}, 'l', pressFn('right'))

remap({'ctrl', 'shift'}, 'h', pressFn({'shift'}, 'left'))
remap({'ctrl', 'shift'}, 'j', pressFn({'shift'}, 'down'))
remap({'ctrl', 'shift'}, 'k', pressFn({'shift'}, 'up'))
remap({'ctrl', 'shift'}, 'l', pressFn({'shift'}, 'right'))

remap({'ctrl', 'cmd'}, 'h', pressFn({'cmd'}, 'left'))
remap({'ctrl', 'cmd'}, 'j', pressFn({'cmd'}, 'down'))
remap({'ctrl', 'cmd'}, 'k', pressFn({'cmd'}, 'up'))
remap({'ctrl', 'cmd'}, 'l', pressFn({'cmd'}, 'right'))

remap({'ctrl', 'alt'}, 'h', pressFn({'alt'}, 'left'))
remap({'ctrl', 'alt'}, 'j', pressFn({'alt'}, 'down'))
remap({'ctrl', 'alt'}, 'k', pressFn({'alt'}, 'up'))
remap({'ctrl', 'alt'}, 'l', pressFn({'alt'}, 'right'))

remap({'ctrl', 'shift', 'cmd'}, 'h', pressFn({'shift', 'cmd'}, 'left'))
remap({'ctrl', 'shift', 'cmd'}, 'j', pressFn({'shift', 'cmd'}, 'down'))
remap({'ctrl', 'shift', 'cmd'}, 'k', pressFn({'shift', 'cmd'}, 'up'))
remap({'ctrl', 'shift', 'cmd'}, 'l', pressFn({'shift', 'cmd'}, 'right'))

remap({'ctrl', 'shift', 'alt'}, 'h', pressFn({'shift', 'alt'}, 'left'))
remap({'ctrl', 'shift', 'alt'}, 'j', pressFn({'shift', 'alt'}, 'down'))
remap({'ctrl', 'shift', 'alt'}, 'k', pressFn({'shift', 'alt'}, 'up'))
remap({'ctrl', 'shift', 'alt'}, 'l', pressFn({'shift', 'alt'}, 'right'))

remap({'ctrl', 'cmd', 'alt'}, 'h', pressFn({'cmd', 'alt'}, 'left'))
remap({'ctrl', 'cmd', 'alt'}, 'j', pressFn({'cmd', 'alt'}, 'down'))
remap({'ctrl', 'cmd', 'alt'}, 'k', pressFn({'cmd', 'alt'}, 'up'))
remap({'ctrl', 'cmd', 'alt'}, 'l', pressFn({'cmd', 'alt'}, 'right'))

remap({'ctrl', 'cmd', 'alt', 'shift'}, 'h', pressFn({'cmd', 'alt', 'shift'}, 'left'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'j', pressFn({'cmd', 'alt', 'shift'}, 'down'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'k', pressFn({'cmd', 'alt', 'shift'}, 'up'))
remap({'ctrl', 'cmd', 'alt', 'shift'}, 'l', pressFn({'cmd', 'alt', 'shift'}, 'right'))

--------------------------------------------------------------------------------
---------------------------- TextClipboardHistory ------------------------------
--------- https://www.hammerspoon.org/Spoons/TextClipboardHistory.html ---------
--------------------------------------------------------------------------------

---------------------------- conflict with ipaste ------------------------------
-- hs.loadSpoon('TextClipboardHistory')
-- spoon.TextClipboardHistory.show_in_menubar = false
-- spoon.TextClipboardHistory.paste_on_select = true
-- spoon.TextClipboardHistory.honor_ignoredidentifiers = true
-- spoon.TextClipboardHistory:start()

-- hs.hotkey.bind(hyper, "V", function()
    -- spoon.TextClipboardHistory:toggleClipboard()
    -- mode:exit()
-- end)

--------------------------------------------------------------------------------
--------------------------------- SpeedMenu ------------------------------------
--------------------------------------------------------------------------------

-- hs.loadSpoon('SpeedMenu')
-- spoon.SpeedMenu:start()
