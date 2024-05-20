VERSION = "0.0.1"

---- IMPORTS ----
local micro = import("micro")
local mutil = import("micro/util")
local config = import("micro/config")
local buffer = import("micro/buffer")

---- CONFIG ----
local active                -- whether typographer is active on the current bufPane
local autoclose             -- whether autoclose is active on the current bufPane
local autoclosePairs = {"\"\"", "''", "``", "()", "{}", "[]"}
local typographerReplacements = {
    ["\""] = "“”", 
    ["'"] = "‘’",
}

-- stolen from the (official) autoclose plugin
function charAt(str, index)
    return mutil.RuneAt(str, index - 1) -- Lua's indexing is 1 off of Go's
end


function onBufPaneOpen(bp)

    active = bp.Buf.Settings["typographer.active"]
    autoclose = bp.Buf.Settings["autoclose"]

end

function onRune(bp, rn)

    if active == false then return end

    -- check to see if the rune that was entered is one the plugin replaces
    for key, val in pairs(typographerReplacements) do
        if rn == key then
            replaceRune(bp, rn, val)
            break
        end
    end
end

function replaceRune(bp, enteredRune, replacementRune)

    -- temporarily disable autoclose if needed
    if autoclose then
        bp.Buf:SetOption("autoclose", "false")
    end

    -- check to see how many replacement possibilities there are
    if charAt(replacementRune, 3) == "" then       -- two
        local leftChar = charAt(replacementRune, 1)
        local rightChar = charAt(replacementRune, 2)
        
        -- see if we need the left character or the right.  Assumes that left begins a word.
        local curLine = bp.Buf:Line(bp.Cursor.Y)
        local prevChar = charAt(curLine, bp.Cursor.X - 1)
        bp:Backspace()
        if prevChar == " " or prevChar == "" then
            bp.Buf:Insert(-bp.Cursor.Loc, leftChar)
        else
            bp.Buf:Insert(-bp.Cursor.Loc, rightChar)
        end
    elseif charAt(replacementRune, 2) == "" then    -- one
        bp:Backspace()
        bp.Buf:Insert(-bp.Cursor.Loc, replacementRune)
    end

    -- re-enable autoclose if needed
    if autoclose then
        bp.Buf:SetOption("autoclose", "true")
    end

end


function init()
    config.RegisterCommonOption("typographer", "active", true)
    config.RegisterCommonOption("typographer", "avoidautoclose", true)

end
