--function run()
--    local waypoints = navigation.findWaypoints(256)
--    for i = 1, waypoints.n do
--        local waypoint = waypoints[i]
--        if waypoint.label == "grape_dock" then
--            local pos = waypoint.position
--            status("-> Base")
--            drone.move(pos[1], pos[2], pos[3])
--            status("LOOOL")
--        end
--    end
--end
--
--register_coroutine(run, {})
local waypoints = navigation.findWaypoints(256)
for i = 1, waypoints.n do
    local waypoint = waypoints[i]
    if waypoint.label == "grape_dock" then
        local pos = waypoint.position
        status("-> Base")
        drone.move(pos[1], pos[2], pos[3])
        status("LOOOL")
    end
end