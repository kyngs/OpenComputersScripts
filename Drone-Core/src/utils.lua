function run()
    while (true) do
        computer.beep(100)
        sleep(0.100)
    end
end
register_coroutine(run, {})