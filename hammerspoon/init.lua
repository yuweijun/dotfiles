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
---------------------------- TextClipboardHistory ------------------------------
--------- https://www.hammerspoon.org/Spoons/TextClipboardHistory.html ---------
--------------------------------------------------------------------------------

hs.loadSpoon('TextClipboardHistory')
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory.paste_on_select = true
spoon.TextClipboardHistory.honor_ignoredidentifiers = true
spoon.TextClipboardHistory:start()

hs.hotkey.bind({'cmd', 'shift'}, "V", function()
    spoon.TextClipboardHistory:toggleClipboard()
    mode:exit()
end)

