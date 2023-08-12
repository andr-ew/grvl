-- grvl
--
-- dual data pavement
--
-- version 0.1.2-beta @andrew
--
-- recommended: grid 
-- (128, 64, or midigrid)
--
-- documentation:
-- github.com/andr-ew/lib-grvl

--device globals (edit for midigrid if needed)

g = grid.connect()

--system libs

cs = require 'controlspec'
lfos = require 'lfo'

--git submodule libs

include 'lib/crops/core'
Grid = include 'lib/crops/components/grid'
Screen = include 'lib/crops/components/screen'
Arc = include 'lib/crops/components/arc'

pattern_time = include 'lib/pattern_time_extended/pattern_time_extended'

Produce = {}
Produce.grid = include 'lib/produce/grid'

patcher = include 'lib/patcher/patcher'
Patcher = include 'lib/patcher/ui'

--script files

engine.name = 'Grvl'

include 'lib/lib-grvl/globals'
mod_src = include 'lib/modulation-sources'
include 'lib/lib-grvl/params'

--create, connect UI components

local App = {}
App.grid = include 'lib/lib-grvl/ui/grid'

local x, y
do
    local top, bottom = 8, 64-2
    local left, right = 2, 128-2
    local mul = { x = (right - left) / 2, y = (bottom - top) / 2 }
    x = { left, left + mul.x*5/4, [1.5] = 24  }
    y = { top, bottom - 22, bottom, [1.5] = 20, }
end

function App.norns()
    local _text = Screen.text()

    return function()
        _text{ x = x[1], y = y[1], text = 'grvl' }
        _text{ x = x[1], y = y[1] + 11*1, text = 'norns screen forthcoming' }
        _text{ x = x[1], y = y[1] + 11*2, text = 'arc also forthcoming' }
        _text{ x = x[1], y = y[1] + 11*3, text = 'have fun in the params menu' }
        _text{ x = x[1], y = y[1] + 11*4, text = 'and on the grid' }
    end
end

local _app = {
    grid = App.grid(),
    norns = App.norns()
}

crops.connect_grid(_app.grid, g)
crops.connect_screen(_app.norns)

--init/cleanup

function init()
    mod_src.lfos.reset_params()

    -- params:read()
    
    for i = 1,2 do mod_src.lfos[i]:start() end

    params:bang()
end
