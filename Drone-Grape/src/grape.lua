local DOCK
local WAYPOINTS = {}
local start_waypoint_index = 1;
local end_waypoint_index = 2;

function calculate_waypoints()
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
            local str, _ = label:gsub("grape_waypoint_", "");
            temp_rows[tonumber(str)] = converted_pos;
        end

    end

    WAYPOINTS = temp_rows
end

function is_at(location)
    calculate_waypoints()
    return (location.x == 0) and (location.y == 0) and (location.z == 0)
end

function dock()
    status("Docking")
    calculate_waypoints()
    drone.move(DOCK.x, DOCK.y, DOCK.z)
    repeat until is_at(DOCK)
    sleep(1)
    status("Docked")
end

dock()
