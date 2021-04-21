for k, v in pairs(navigation.findWaypoints(256)) do
    if k[3] == "grape_dock" then
        status(k[1][2])
    end
end