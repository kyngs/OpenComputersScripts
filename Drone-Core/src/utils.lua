navigation = part("navigation")
nav = navigation

function starts_with(text, prefix)
    return string.sub(text, string.len(prefix)) == prefix
end