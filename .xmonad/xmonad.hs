import XMonad

import qualified Data.Map as M
import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
--import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.Grid
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace

import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Util.Run
import XMonad.Util.EZConfig
import System.IO

myFont = "xft:DejaVu Sans Mono-9"
myModMask = mod4Mask
myTerminal = "urxvtc"

myPromptConfig = defaultXPConfig
  { font = myFont
  , bgColor = "black"
  , fgColor = "white"
  , bgHLight = "black"
  , fgHLight = "yellow"
  , promptBorderWidth = 0
  , position = Bottom
  }

myManageHook = composeAll
  [ isFullscreen --> doFullFloat
--, className =? "Skype" --> doF (W.shift "9")
--, className =? "Conkeror" --> doF (W.shift "2") <+> (ask >>= doF . W.focusWindow)
  ]
  <+> manageDocks

myLayoutHook = smartBorders . mkToggle (single NBFULL) $ avoidStruts (Grid ||| layoutHook defaultConfig)

myKeysP =
  [ ("M-p"                    , shellPrompt myPromptConfig)
  , ("M-f"                    , sendMessage $ Toggle NBFULL)
  , ("M-S-o"                  , spawn "conkeror")
  , ("M-S-l"                  , spawn "lockscreen")
  , ("M-S-p"                  , spawn "pbd")
  , ("<XF86MonBrightnessUp>"  , spawn "sudo blutil blup")
  , ("<XF86MonBrightnessDown>", spawn "sudo blutil bldown")
  , ("<XF86KbdBrightnessUp>"  , spawn "sudo blutil kbup")
  , ("<XF86KbdBrightnessDown>", spawn "sudo blutil kbdown")
  , ("<XF86AudioMute>"        , spawn "avol toggle")
  , ("<XF86AudioRaiseVolume>" , spawn "avol 5%+")
  , ("<XF86AudioLowerVolume>" , spawn "avol 5%-")
  , ("<XF86Eject>"            , spawn "eject /dev/sr0")
  ]

myKeys =
  [ ((myModMask .|. shiftMask, k), (windows $ W.shift i) >> (windows $ W.greedyView i))
    | (i, k) <- zip (XMonad.workspaces defaultConfig) [xK_1 .. xK_9]
  ]
  ++
  [ ((myModMask .|. controlMask, k), (windows $ W.shift i))
    | (i, k) <- zip (XMonad.workspaces defaultConfig) [xK_1 .. xK_9]
  ]

main = do
  xmobar <- spawnPipe "/usr/bin/xmobar"
  xmonad $ withUrgencyHook NoUrgencyHook $ ewmh defaultConfig
    { manageHook = myManageHook
--    , startupHook = setWMName "LG3D"
    , layoutHook = myLayoutHook
    , logHook = do
      setWMName "LG3D"
--      takeTopFocus
      dynamicLogWithPP $ xmobarPP
        { ppOutput = hPutStrLn xmobar
        , ppTitle = xmobarColor "cyan" "" . shorten 100
        , ppSep = xmobarStrip " "
        , ppLayout = xmobarColor "orange" "" . wrap "<" ">" . xmobarColor "white" "" . \x ->
          case x of
            "Mirror Tall" -> "-"
            "Tall"        -> "|"
            "Full"        -> "*"
            "Grid"        -> "+"
            _             -> x
        , ppCurrent = xmobarColor "yellow" "" . wrap "[" "]" . xmobarColor "white" ""
        , ppVisible = xmobarColor "cyan" "" . wrap "(" ")" . xmobarColor "white" ""
        , ppUrgent = xmobarColor "red" "" . wrap "[" "]" . xmobarColor "white" ""
        }
    , modMask = myModMask
    , terminal = myTerminal
    , normalBorderColor = "#555555"
    , focusedBorderColor = "#00ffff"
    } `additionalKeysP` myKeysP `additionalKeys` myKeys
