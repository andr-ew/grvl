local x, y, w, h
do
    local mar = { top = 0, bottom = 0, left = 3, right = 3 }
    local top, bottom = mar.top, 64 - mar.bottom
    local left, right = mar.left, 128-mar.right
    w = 128 - mar.left - mar.right
    h = 64 - mar.top - mar.bottom
    x = { left, left + w*(1/4), 64, left + w*(3/4)  }
    y = { top, }
end
local text_mul_y = 9

local function Destination(args)
    local id = args.id
    local p = params:lookup_param(id)
    local spec = p.controlspec
    local name = p.name

    local _label = Screen.text()
    local _value = Screen.text()
    local _enc = Enc.control() --TODO: select component by param type (p.t)

    return function(props)
        _label{
            x = x[props.map_x],
            -- x = x[props.map_x] + w/8 - 2,
            y = y[1] + text_mul_y*props.map_y,
            text = string.upper(name),
            level = props.levels_label[props.focused and 2 or 1],
            font_face = 2,
            -- flow = 'center',
        }
        if props.focused then
            _value{
                x = x[props.map_x],
                y = y[1] + text_mul_y*5 + 1,
                -- text = util.round(params:get(id), 0.01),
                text = string.format('%.2f %s', params:get(id), spec.units),
                level = props.levels[2],
                font_face = 2,
            }
            _enc{
                n = (props.map_x - 1)%2 + 2,
                controlspec = spec,
                state = crops.of_param(id),
            }
        end
    end
end

local function App(args)
    local map = args.map

    local _focus = Enc.integer()

    local _map = {}
    for y = 1,4 do
        _map[y] = {}
        for x = 1,4 do
            if map[y][x] then
                local prefix = map[y][x]
                local chan = (x <3) and 1 or 2
                _map[y][x] = Patcher.enc.destination(Destination{ id = prefix..chan })
            end
        end
    end

    return function()
        _focus{
            n = 1, max = 8, sensitivity = 1/4,
            state = crops.of_variable(grvl.norns_focus, function(v) 
                grvl.norns_focus = v
                crops.dirty.screen = true 
            end)
        }

        local f_y = (grvl.norns_focus - 1)%4 + 1
        local f_x = (grvl.norns_focus - 1)//4 + 1

        if crops.mode == 'redraw' then 
            screen.level(1)
            -- if arc_connected then
            --     for iy = 1,4 do for ix = 1,4 do
            --         if grvl.arc_focus[iy][ix] > 0 then
            --             if grvl.arc_vertical then
            --                 screen.line_width(2)
            --                 screen.move(
            --                     x[1] + (ix - 1 + 0.25)*(w / 4) - 1,
            --                     y[1] + text_mul_y*(iy - 1) - 1
            --                 )
            --                 screen.line_rel(0, text_mul_y + 3)
            --                 screen.stroke()
            --             else
            --                 screen.line_width(2)
            --                 screen.move(
            --                     x[ix] - 3,
            --                     y[1] + text_mul_y*(iy - 1 + 0.5) + 2
            --                 )
            --                 screen.line_rel(w/4 + 2, 0)
            --                 screen.stroke()
            --             end
            --         end
            --     end end
            -- end

            screen.level(15)
            for i = 1,2 do
                screen.rect(
                    x[i + (f_x - 1)*2] - 1,
                    y[1] + text_mul_y*(f_y - 1) + 2,
                    w/4 - 2,
                    8 
                )
                screen.fill()
            end 

        end

        for y = 1,4 do for x = 1,4 do
            local chan = (x <3) and 1 or 2

            _map[y][x](map[y][x]..chan, grvl.active_src, {
                focused = (y == f_y and chan == f_x),
                map_x = x,
                map_y = y,
                levels = { 4, 15 },
                levels_label = (
                    arc_connected and grvl.arc_focus[y][x] > 0
                ) and { 10, 0 } or { 4, 0 },
            })
        end end
    end
end

return App
