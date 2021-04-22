--function run()
--
--end
--
--register_coroutine(run, {})

local DOCK
local WAYPOINTS = {}

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
            table.insert(temp_rows, tonumber(string.gsub(label, "grape_waypoint_", "")), converted_pos)
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

recalculate_waypoints()

if not DOCK then
    status("No Dock")
    error("Dock not found, make sure to create a waypoint named grape_dock in 256 range.")
end

dock()

-- Main loop

local start_waypoint_index = 1;
local end_waypoint_index = 2;

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

    status("-> Start")

    drone.move(start_waypoint.x, start_waypoint.y, start_waypoint.z)

    while true do
        recalculate_waypoints()
        start_waypoint = WAYPOINTS[start_waypoint_index]
        if (is_in(start_waypoint)) then break end
    end

    ::continue::
end
