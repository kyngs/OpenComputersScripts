function part(name)
    return component.proxy(component.list(name)())
end

drone = part("drone")

function sleep(timeout)
    local deadline = computer.uptime() + (timeout or 0)
    repeat
        computer.pullSignal(deadline - computer.uptime())
    until computer.uptime() >= deadline
end

function status(status)
    drone.setStatusText(" ")
    drone.setStatusText(status)
    computer.beep(200)
end

status("Loading")

local repo = "https://raw.githubusercontent.com/kyngs/OpenComputersScripts/Drone-Core/src/"
internet = part("internet")

local coroutines = {}

function register_coroutine(func, events)
    table.insert(coroutines,{coroutine = coroutine.create(func), events = events})
end

status("Loaded")

function net_get(url)

    local request = internet.request(url)
    request.finishConnect()

    local response = ""

    while true do
        local chonk request.read();
        if chonk then
            string.gsub(chonk, "\r\n", "\n")
            response = response .. chonk
        else
            break
        end
    end

    return response;

end

function load_script(url)
    load(net_get(url) or "")
end

status("Downloading")

load_script(repo .. "utils.lua") -- DO NOT REMOVE

-- Insert files in here using loadScript("address")

status("Downloaded")

-- Main loop

status("Running")

while true do
    local event = {computer.pullSignal(0.001)}

    for index, coroutine in pairs(coroutines) do
        local thread = coroutine["thread"]
        local status = coroutine.status(thread)
        if (status == "dead") then
            table.remove(coroutines, index)
            status("Coro " .. index .. " crash")
        end
        if (coroutine["event"]) then
            if event then
                coroutine.resume(thread, table.unpack(event))
            end
        else
            coroutine.resume(thread)
        end
    end
end

status("Exiting")

