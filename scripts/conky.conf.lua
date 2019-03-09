-- Conky configuration
conky.config = {
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

conky.text = [[\
    Cpu: ${cpu}% Mem: ${memperc}% Net: ${downspeedf wlp4s0} / ${upspeedf wlp4s0}\
    ${time %a %b %d %H:%M:%S} 
]]
