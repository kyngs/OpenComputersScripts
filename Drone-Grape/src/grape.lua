function run()
    for k, v in pairs(navigation.findWaypoints(256)) do
        if not v then
            goto continue
        end
        if v["label"] == "grape_dock" then
            local pos = v["position"]
            status("-> Base")
            drone.move(pos[1], pos[2], pos[3])
            break
        end
        ::continue::
    end
end

register_coroutine(run, {})