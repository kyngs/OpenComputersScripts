local DOCK
local WAYPOINTS = {}
local target_waypoint_index = 1;

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

function flying_at(location)
    calculate_waypoints()
    return (location.x == 0) and (location.z == 0)
end

function dock()
    drone.move(0, 3, 0)
    sleep(1)
    calculate_waypoints()
    drone.move(DOCK.x, 0, DOCK.z)
    repeat until flying_at(DOCK)
    drone.move(0, -3, 0)
    repeat until is_at(DOCK) do sleep(0.1) end
end

function travel_to_waypoint(index)
    calculate_waypoints()
    local waypoint = WAYPOINTS[index];
    drone.move(waypoint.x, waypoint.y, waypoint.z)
    repeat until is_at(WAYPOINTS[index])
end

function bump_index()
    if (target_waypoint_index >= #WAYPOINTS) then
        target_waypoint_index = 1
    else
        target_waypoint_index = target_waypoint_index + 1
    end
end

dock()

status("Working")

while true do
    calculate_waypoints()
    if is_at(DOCK) then
        if (get_total_inventory_space_occupied() <= 0) and (get_charge_percent() >= 95) then
            status("Working")
            goto stop_dock
        end
        status("Docked")
        goto continue
    else
        if (get_total_inventory_space_remaining() == 0) or (get_charge_percent() <= 10) then
            dock()
            goto continue
        end
    end

    ::stop_dock::

    travel_to_waypoint(target_waypoint_index)
    bump_index()

    ::continue::
end
