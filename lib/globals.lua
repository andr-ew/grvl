function grvl.start_polls()
    for chan = 1,2 do
        local phase_poll = poll.set('read_phase_'..chan..'_minutes', function(ph)
            local buf = patcher.get_destination_plus_param('buffer_'..chan)

            grvl.buffers[buf].phase_seconds = ph*60

            if (params:get('play_1') > 0) or (params:get('play_2') > 0) then
                crops.dirty.grid = true
                crops.dirty.arc = true
                -- crops.dirty.screen = true --?
            end
        end)

        phase_poll.time = 1/90/2 --2x fps of arc
        phase_poll:start()
    end
end
