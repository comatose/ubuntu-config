-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

import           Data.List
import qualified Data.Map                    as M
import           System.Exit
import           System.IO
import           XMonad
import           XMonad.Actions.CycleWS
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ToggleLayouts
import           XMonad.Layout.WorkspaceDir
import           XMonad.Prompt
import           XMonad.Prompt.RunOrRaise
import qualified XMonad.StackSet             as W
import           XMonad.Util.EZConfig        (additionalKeys)
import           XMonad.Util.Run             (spawnPipe)


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "lxterminal -e 'byobu new'"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:term","2:web","3:emacs","4:home","5:docs"] ++ map show [6..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Conkeror"       --> doShift "2:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Galculator"     --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Google-chrome"  --> doShift "2:web"
    , className =? "Firefox"        --> doShift "2:web"
    , className =? "Evince"         --> doShift "5:docs"
    -- , resource  =? "gpicview"       --> doFloat
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "MPlayer"        --> doFloat
    , resource  =? "skype"          --> doFloat
    -- , className =? "VirtualBox"     --> doShift "4:home"
    -- , className =? "Xchat"          --> doShift "5:vm"
    , className =? "Nabi"           --> doShift "9"
    , className =? "Nautilus"       --> doShift "4:home"
    -- , className =? "Unity-2d-panel"    --> doIgnore
    -- , className =? "Unity-2d-launcher" --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout =
  workspaceDir "~" $ toggleLayouts
  (noBorders (fullscreenFull Full))
--  Full
  (avoidStruts (
--    Tall 1 (3/100) (1/2)
    Mirror (ResizableTall 3 (3/100) (1/2) [])
    ||| ResizableTall 0 (3/100) (1/2) []
--    ||| Mirror (Tall 1 (3/100) (1/2))
--    ||| spiral (5/7)
    ||| tabbed shrinkText tabConfig)
    )

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 2

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
--  [ ((modMask .|. shiftMask, xK_Return),
  [ ((modMask, xK_t),
     spawn $ XMonad.terminal conf)

  , ((modMask .|. shiftMask, xK_t),
     spawn "lxterminal -e byobu")

  , ((modMask, xK_a),
     sendMessage MirrorExpand)

  , ((modMask, xK_z),
     sendMessage MirrorShrink)

   -- Toggle Full Screen
  , ((modMask, xK_f),
     sendMessage (Toggle "Full"))

   -- Toggle Work Space
  , ((modMask, xK_b),
     toggleWS)

  -- Lock the screen using xscreensaver.
  , ((modMask .|. controlMask, xK_l),
     spawn "xscreensaver-command -lock")

  -- Launch dmenu via yeganesh.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_r),
     -- spawn "exe=`dmenu_path | yeganesh` && eval \"exec $exe\"")
     -- spawn "dmenu_run -b -i -nb black -nf blue -fn '10x20'")
    -- runOrRaisePrompt promptConfig)
    spawn "gmrun")

  , ((modMask .|. shiftMask, xK_r),
     changeDir promptConfig)

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  , ((modMask .|. shiftMask, xK_Print),
     spawn "scrot -b -e 'eog $f' -m")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  , ((modMask, xK_Print),
     spawn "scrot -b -e 'eog $f' -u")

  -- -- Mute volume.
  -- , ((0, 0x1008FF12),
  --    spawn "amixer -q set Front toggle")

  -- -- Decrease volume.
  -- , ((0, 0x1008FF11),
  --    spawn "amixer -q set Front 10%-")
  -- , ((modMask, xK_F6),
  --    lowerVolume 4 >>= alert)

  -- -- Increase volume.
  -- , ((0, 0x1008FF13),
  --    spawn "amixer -q set Front 10%+")
  -- , ((modMask, xK_F7),
  --    raiseVolume 4 >>= alert)

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_n),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_p),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_n),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_p),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  -- , ((modMask, xK_t),
  --    withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask .|. controlMask, xK_q),
     io exitSuccess)

  -- Restart xmonad.
  , ((modMask .|. shiftMask, xK_q),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_5] ++ [xK_8, xK_9, xK_0, xK_minus])
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_k, xK_j] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     \w -> focus w >> mouseMoveWindow w)

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       \w -> focus w >> windows W.swapMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       \w -> focus w >> mouseResizeWindow w)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xbar <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  -- xbar2 <- spawnPipe "xmobar ~/.xmonad/xmobar2.hs"
  xscreensaver <- spawnPipe "xscreensaver -nosplash"
  -- nautilus <- spawnPipe "nautilus"
  unclutter <- spawnPipe "unclutter -idle 5"
  -- gs <- spawnPipe "gnome-settings-daemon"
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xbar
            -- ppOutput = \s -> hPutStrLn xbar s >> hPutStrLn xbar2 s
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppLayout = const ""
          , ppSep = "   "}
      , manageHook = manageDocks <+> myManageHook
      , startupHook = setWMName "LG3D"
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}

promptConfig = defaultXPConfig
             { font = "xft:Consolas:12"
             -- { font = "xft:NanumGothicCoding:12"
             , bgColor = "black"
--             , fgColor = solbase1
--             , bgHLight = solyellow
--             , fgHLight = solbase02
             , promptBorderWidth = 0
             , height = 28
             , historyFilter = nub
             , showCompletionOnTab = False
             }
