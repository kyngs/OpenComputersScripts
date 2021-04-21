navigation = part("navigation")
nav = navigation
computer_api = require("computer")

function starts_with(text, prefix)
    return string.sub(text, string.len(prefix)) == prefix
end