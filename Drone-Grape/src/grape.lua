for k, v in pairs(navigation.findWaypoints(256)) do
    if v[3] == "grape_dock" then
        status(v[1][2])
    end
end