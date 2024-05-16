VERSION = "0.0.1"

local mutil = import("micro/util")
local config = import("micro/config")
local buffer = import("micro/buffer")


-- all credit to hltrailingws on GitHub for this function
function charAt(str, index)
    return mutil.RuneAt(str, index - 1) -- lua is 1-indexed
end


--[[ -----------------------------------------------------------
    When a rune is inserted, check to see what it is,
    what's around it (i.e. runes on either side),
    and whether it needs to be replaced with anything
    -----------------------------------------------------------
--]] 
function onRune(bp, rn)

    if rn == "'" then
        local curLine = bp.Buf:Line(bp.Cursor.Y)

        -- check "previous" character
        -- have to actually go back 2, since the one we're replacing has been inserted at this point
        local prevChar = charAt(curLine, bp.Cursor.X - 1)

        if prevChar == " " or prevChar == "" then
            bp:Backspace()
            bp.Buf:Insert(-bp.Cursor.Loc, "‘")
        else
            bp:Backspace()
            bp.Buf:Insert(-bp.Cursor.Loc, "’")
        end
    elseif rn == "\"" then
        local curLine = bp.Buf:Line(bp.Cursor.Y)    -- text of the current line, not its index

        local prevChar = charAt(curLine, bp.Cursor.X - 1)

        if prevChar == " " or prevChar == "" then
            bp:Backspace()
            bp.Buf:Insert(-bp.Cursor.Loc, "“")
        else
            bp:Backspace()
            bp.Buf:Insert(-bp.Cursor.Loc, "”")
        end
    end
end