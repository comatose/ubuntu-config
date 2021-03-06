-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1600x900 monitors, with the right monitor as primary
Config {
--    font = "xft:Fixed-20",
    font = "-misc-fixed-*-*-*-*-18-*-*-*-*-*-*-*",
    bgColor = "#000000",
    fgColor = "#ffffff",
--    position = Static { xpos = 1600, ypos = 0, width = 1920, height = 20 },
    position = Static { xpos = 1920, ypos = 0, width = 1600, height = 20 },
    -- position = Static { xpos = 0, ypos = 0, width = 900, height = 20 },
    borderColor = "#BFBFBF",
    border = NoBorder,
    lowerOnStart = True,
    hideOnStart = False,
    persistent = True,
    commands = [
        Run Weather "RKSM" ["-t","<station>: <tempC> 'C <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
--        Run MultiCpu ["-t","Cpu: <total0> <total1>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %multicpu%   %memory%   %swap%   %eth0%   <fc=#FFFFCC>%date%</fc>   %RKSM%"
    -- template = "%StdinReader% }{ <fc=#FFFFCC>%date%</fc>"
}
