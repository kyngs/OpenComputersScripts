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

status(#WAYPOINTS)

