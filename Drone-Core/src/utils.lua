function run()
    status("TEST")
    sleep(2)
    while (true) do
        computer.beep(100)
        sleep(1)
    end
end
status("TEST")
sleep(2)
register_coroutine(run, {})