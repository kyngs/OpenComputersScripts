for k, v in pairs(navigation.findWaypoints(256)) do
    if v["label"] == "grape_dock" then
        status(v["position"][2])
    end
end