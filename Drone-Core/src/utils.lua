function run()
    while true do
        computer.beep(100)
        sleep(100)
    end
end
status("TEEEST")
sleep(2000)
register_coroutine(run, {})