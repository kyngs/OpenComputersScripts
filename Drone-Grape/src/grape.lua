--function run()
--end
--
--register_coroutine(run, {})

local DOCK
local ROWS = {}

function recalculate_waypoints()
    local waypoints = navigation.findWaypoints(256)
    local temp_rows = {}

    for i = 1, waypoints.n do
        local waypoint = waypoints[i]

        local pos = waypoint.position
        local converted_pos = {};
        local label = waypoint.label

        converted_pos.x = pos[1]
        converted_pos.y = pos[2]
        converted_pos.z = pos[3]

        if label == "grape_dock" then
            DOCK = converted_pos;
        end

        if starts_with(label,"grape_waypoint_") then
            table.insert(temp_rows, string.gsub(label, "grape_waypoint_", ""), converted_pos)
        end

        ROWS = temp_rows

    end
end

function dock()
    status("-> Dock")
    drone.move(DOCK.x, DOCK.y, DOCK.z)
    while true do
        recalculate_waypoints()
        if DOCK.x == 0 and DOCK.y == 0 and DOCK.z == 0 then
            break
        end
    end
end

recalculate_waypoints()

if not DOCK then
    status("No Dock")
    error("Dock not found, make sure to create a waypoint named grape_dock in 256 range.")
end

dock()
