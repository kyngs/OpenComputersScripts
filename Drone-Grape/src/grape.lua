--function run()
--
--end
--
--register_coroutine(run, {})

local DOCK
local WAYPOINTS = {}
local start_waypoint_index = 1;
local end_waypoint_index = 2;

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
            local str, _ = label:gsub("grape_waypoint_", "");
            temp_rows[tonumber(str)] = converted_pos;
        end

    end

    WAYPOINTS = temp_rows
end

function dock()
    status("-> Dock")
    drone.move(DOCK.x, DOCK.y, DOCK.z)
    while true do
        recalculate_waypoints()
        if docked() then break end
    end
end

function docked()
    return is_in(DOCK)
end

function is_in(location)
    return location.x == 0 and location.y == 0 and location.x == 0
end

function calculate_right_waypoint(location)
    if not (location.y == 0) then return false end
    return (location.x * location.z) == 0
end

function reset_start()
    start_waypoint_index = 1;
    end_waypoint_index = 2;
end

function bump_target()
    if (end_waypoint_index >= #WAYPOINTS) then
        status("RESET")
        reset_start()
    else
        start_waypoint_index = start_waypoint_index + 1;
        end_waypoint_index = end_waypoint_index + 1;
    end
end

recalculate_waypoints()

if not DOCK then
    status("No Dock")
    error("Dock not found, make sure to create a waypoint named grape_dock in 256 range.")
end

dock()

status("Working")

-- Main loop

while true do

    recalculate_waypoints()
    local docked = docked()
    local charge = get_charge_percent();

    if docked then
        if (not (charge >= 95)) or (not (get_total_inventory_space_occupied() == 0)) then
            goto end_dock
        end
    else
        if (charge <= 10) or (get_total_inventory_space_remaining() == 0) then
            dock()
            goto continue
        end
    end

    ::end_dock::

    local start_waypoint = WAYPOINTS[start_waypoint_index]

    drone.move(start_waypoint.x, start_waypoint.y, start_waypoint.z)

    while true do
        recalculate_waypoints()
        start_waypoint = WAYPOINTS[start_waypoint_index]
        if (is_in(start_waypoint)) then break end
    end

    recalculate_waypoints()

    local end_waypoint = WAYPOINTS[end_waypoint_index]

    if not calculate_right_waypoint(end_waypoint) then
        bump_target()
        goto continue;
    end

    drone.move(end_waypoint.x, end_waypoint.y, end_waypoint.z)

    while true do
        recalculate_waypoints()
        end_waypoint = WAYPOINTS[end_waypoint_index]
        if (is_in(end_waypoint)) then break end
    end

    bump_target()

    ::continue::
end
