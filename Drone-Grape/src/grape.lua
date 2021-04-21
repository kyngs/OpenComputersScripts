for k, v in pairs(navigation.findWaypoints(256)) do
    if k["label"] == "grape_dock" then
        status(k["position"][2])
    end
end