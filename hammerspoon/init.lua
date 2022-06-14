local hyper = {'ctrl', 'alt', 'cmd'}

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
---------------------------- Hotkey app management -----------------------------
--------------------------------------------------------------------------------

hs.hotkey.bind({'alt'}, "a", function() hs.application.launchOrFocus('Launchpad') end)
hs.hotkey.bind({'alt'}, "w", function() hs.application.launchOrFocus('Mission Control') end)

--------------------------------------------------------------------------------
------------------------------ Window management -------------------------------
--------------------------------------------------------------------------------
local function baseMove(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.w * x + max.x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

hs.hotkey.bind(hyper, 'Left', baseMove(0, 0, 0.5, 1))
hs.hotkey.bind(hyper, 'Right', baseMove(0.5, 0, 0.5, 1))
hs.hotkey.bind(hyper, 'Down', baseMove(0, 0.5, 1, 0.5))
hs.hotkey.bind(hyper, 'Up', baseMove(0, 0, 1, 0.5))
hs.hotkey.bind(hyper, '1', baseMove(0, 0, 0.5, 0.5))
hs.hotkey.bind(hyper, '2', baseMove(0.5, 0, 0.5, 0.5))
hs.hotkey.bind(hyper, '3', baseMove(0, 0.5, 0.5, 0.5))
hs.hotkey.bind(hyper, '4', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind(hyper, '5', hs.grid.maximizeWindow)

--------------------------------------------------------------------------------
-------------------------- remapping alt+j to escape ---------------------------
--------------------------------------------------------------------------------

local function pressFn(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end

    return function() hs.eventtap.keyStroke(mods, key, 80) end
end

local function remap(mods, key, pressFn)
    hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

remap({'alt'}, 'h', pressFn('escape'))
remap({'alt'}, 'j', pressFn('down'))
remap({'alt'}, 'k', pressFn('up'))

--------------------------------------------------------------------------------
---------------------------- TextClipboardHistory ------------------------------
--------------------------------------------------------------------------------

---------------------------- conflict with ipaste ------------------------------
hs.loadSpoon('TextClipboardHistory')
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory.paste_on_select = true
spoon.TextClipboardHistory.honor_ignoredidentifiers = true
spoon.TextClipboardHistory:start()

hs.hotkey.bind({'shift', 'cmd'}, "V", function()
    spoon.TextClipboardHistory:toggleClipboard()
    mode:exit()
end)

--------------------------------------------------------------------------------
--------------------------------- SpeedMenu ------------------------------------
--------------------------------------------------------------------------------

hs.loadSpoon('SpeedMenu')
spoon.SpeedMenu:start()
