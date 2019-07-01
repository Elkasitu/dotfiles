-- Conky configuration
conky.config = {
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

-- Glyph dir
xbmDir = '$HOME/.xbm/'

-- Glyphs
cpu = '^i(' .. xbmDir .. 'cpu.xbm)${cpu}% '
mem = '^i(' .. xbmDir .. 'mem.xbm)${memperc}% '
netDownWlan = '^i(' .. xbmDir .. 'down.xbm)${downspeedf wlp4s0}KiB '
netUpWlan = '^i(' .. xbmDir .. 'up.xbm)${upspeedf wlp4s0}KiB '
bat = '^i(' .. xbmDir .. 'power-bat.xbm)${battery_percent}% (${battery_time})'
date = '${time %a %b %d} '
time = '${time %H:%M:%S} '
root = '/: ${fs_free /} '
home = '/home: ${fs_free /home} '
temp = '^i(' .. xbmDir .. 'temp.xbm)${acpitemp} '

-- Output
conky.text = temp .. cpu .. mem .. root .. home .. netDownWlan .. netUpWlan .. bat
conky.text = conky.text .. ' | ' .. date .. '| ' .. time
