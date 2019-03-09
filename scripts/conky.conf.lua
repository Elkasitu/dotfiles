-- Conky configuration
conky.config = {
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

-- Glyph dir
xbmDir = '$HOME/.xbm/'

-- Glyphs
cpu = '^i(' .. xbmDir .. 'cpu.xbm) ${cpu}% '
mem = '^i(' .. xbmDir .. 'mem.xbm) ${memperc}% '
netDownWlan = '^i(' .. xbmDir .. 'down.xbm) ${downspeedf wlp4s0}KiB '
netUpWlan = '^i(' .. xbmDir .. 'up.xbm) ${upspeedf wlp4s0}KiB '
bat = '^i(' .. xbmDir .. 'power-bat.xbm) ${battery_percent}% (${battery_time})'
date = '${time %a %b %d} '
time = '${time %H:%M:%S} '

-- Output
conky.text = cpu .. mem .. netDownWlan .. netUpWlan .. bat .. '| ' .. date .. '| ' .. time
