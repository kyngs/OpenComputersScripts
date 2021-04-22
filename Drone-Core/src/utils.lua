navigation = part("navigation")
nav = navigation

function starts_with(text, prefix)
    return string.sub(text, string.len(prefix)) == prefix
end

function get_charge_percent()
    return (computer.energy() / computer.maxEnergy()) * 100
end

function get_total_inventory_space_remaining()
    local total_space = 0;
    for i = 0, 7 do
        total_space = total_space + drone.space(i)
    end
    return total_space;
end

function get_total_inventory_space_occupied()
    local total_space = 0;
    for i = 0, 7 do
        total_space = total_space + drone.count(i)
    end
    return total_space;
end