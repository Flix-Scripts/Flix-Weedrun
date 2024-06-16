Config = {}

Config.Language = {
    ['notifytitle'] = 'Weedrun',
    ['deliverdropoff'] = 'Deliver cannabis to dropoff',
    ['deliverdropoff2'] = 'I will send you new location in a moment',
    ['notenoughcannabis'] = 'You dont have enough cannabis',
    ['buyerlabel'] = 'Sell cannabis',
    ['stoprun'] = 'Stop weedrun',
    ['startrun'] = 'Start weedrun',
    ['startdesc'] = 'I will soon send you the location where you take the cannabis',
    ['logs'] = 'Player **%s** sold **%s** cannabis for **%s**$ date:** %s**.'
}

Config.Blip = {
    ['sprite'] = 469,
    ['colour'] = 2
}

Config.Cannabis = {
    ['amountneeded'] = 9,      -- Amount that you need to sell, you must have one more than here
    ['mincannabis'] = 8,        -- Min amount per one sell
    ['maxcannabis'] = 12,       -- Max amount per one sell
    ['minprice'] = 45,
    ['maxprice'] = 105
}

Config.Psdispatch = false        -- Set this to true if you use ps-dispatch. You can set you own dispatch script in cl_main.lua at line 32

Config.Dropoffpoints = {
    {coords = vec4(-1484.68, -604.82, 29.88, 249.27)},
    {coords = vec4(-1060.86, -520.79, 35.09, 13.39)},
    {coords = vec4(-739.62, 188.03, 72.86, 117.7)},
    {coords = vec4(-1046.91, 500.32, 83.16, 232.91)},
}

Config.StartLocation = vec4(-1440.62, -544.68, 34.74, 169.35)