function run()
    while (true) do
        computer.beep(100)
        sleep(100)
    end
end
register_coroutine(run, {})