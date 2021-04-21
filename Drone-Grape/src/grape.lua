function run()
    for k, v in pairs(navigation.findWaypoints(256)) do
        if not v then
            goto continue
        end
        if v["label"] == "grape_dock" then
            status(v["position"][2])
        end
        ::continue::
    end
end

register_coroutine(run, {})