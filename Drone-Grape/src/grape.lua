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

function travel_to_waypoint(index)
    status("Traveling")
    calculate_waypoints()
    local waypoint = WAYPOINTS[index];
    drone.move(waypoint.x, waypoint.y, waypoint.z)
    repeat until is_at(WAYPOINTS[index])
    sleep(1)
end

dock()

while true do
    if (is_at(DOCK)) then
        if (get_total_inventory_space_occupied() <= 0) and (get_charge_percent() >= 95) then
            goto stop_dock
        end
    else
        if (get_total_inventory_space_remaining() == 0) or (get_charge_percent() <= 10) then
            status("oh no")
            goto continue
        end
    end

    ::stop_dock::

    travel_to_waypoint(start_waypoint_index)
    start_waypoint_index = start_waypoint_index + 1

    ::continue::
end
