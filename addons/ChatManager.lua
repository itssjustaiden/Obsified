--[[
As much as i hate comments, i will explain every part of it.
this is MADE FOR OBSIFIED. not sure if you can use it for obsidian but okay.
https://github.com/itssjustaiden/obsified
]]

local cloneref = cloneref or clonereference or function(instance: any)
    return instance
end

local HttpService = cloneref(game:GetService("HttpService"))
local ChatManager = {} do
    ChatManager.Messages = {}
    local SERVER_URL = "https://obsifiedchatmanageraddon.egesdabest.workers.dev/?room=default"
    local BaseGroupbox = getgenv().Library and getgenv().Library.BaseGroupbox or nil
    if not BaseGroupbox then
        warn("ChatManager: No lib BaseGroupbox found—methods may fail. Ensure addon loads after lib.")
    end
    local function fetchMessages() -- fetches messages from the server
        local success, response = pcall(function() -- safe call
            return HttpService:GetAsync(SERVER_URL) -- get the response
        end)
        if success and response then -- if successful
            local data = HttpService:JSONDecode(response) -- decode the json
            if type(data) == "table" then -- if it's a table
                return data -- return the data
            end --- else return empty table
        end -- if failed
        return {} -- return empty table
    end
--==================================================================================================================--
    local function postMessage(msg) -- posts a message to the server
        local success, _ = pcall(function() -- safe call
            local payload = HttpService:JSONEncode(msg) -- encode the message
            HttpService:PostAsync(SERVER_URL, payload, Enum.HttpContentType.ApplicationJson) -- post the message
        end) -- return whether it was successful
        return success --- return success
    end
--==================================================================================================================--
function ChatManager:CreateChat(tab)
    if not tab then
        warn("ChatManager: tab is nil!")
        return
    end
    if BaseGroupbox and not getmetatable(tab) then
        setmetatable(tab, BaseGroupbox)
    end
    local ok1, leftGroupbox = pcall(function() return tab:AddLeftGroupbox("Messages", "chat") end)
    if not ok1 or not leftGroupbox then
        warn("ChatManager: AddLeftGroupbox failed:", leftGroupbox)
        return
    end
    local ok2, rightGroupbox = pcall(function() return tab:AddRightGroupbox("Chat") end)
    if not ok2 or not rightGroupbox then
        warn("ChatManager: AddRightGroupbox failed:", rightGroupbox)
        return
    end
    local ok3, input = pcall(function() return rightGroupbox:AddInput("ChatInput", {Text = ""}) end)
    if not ok3 or not input then
        warn("ChatManager: AddInput failed:", input)
        return
    end
    local ok4, button = pcall(function()
        return rightGroupbox:AddButton("Send", function()
            local message = input.Value
            if message ~= "" then
                local LocalPlayer = cloneref(game.Players.LocalPlayer)
                local username = tostring(LocalPlayer.DisplayName or "User"):sub(1, 5)
                local msgData = {user = username, text = message}
                table.insert(self.Messages, msgData)
                input:SetValue("")
                self:UpdateChatDisplay(leftGroupbox)
                postMessage(msgData)
            end
        end)
    end)
    if not ok4 or not button then
        warn("ChatManager: AddButton failed:", button)
        return
    end
    self.Messages = fetchMessages()
    self:UpdateChatDisplay(leftGroupbox)
    spawn(function()
        while true do
            wait(2)
            local msgs = fetchMessages()
            if #msgs ~= #self.Messages then
                self.Messages = msgs
                self:UpdateChatDisplay(leftGroupbox)
            end
        end
    end)
end
function ChatManager:UpdateChatDisplay(container)
    if not container then
        warn("ChatManager: container is nil in UpdateChatDisplay!")
        return
    end
    pcall(function()
        container:Clear()
        for _, msg in ipairs(self.Messages) do
            container:AddLabel(self:FormatMessage(msg), true)
        end
    end)
end

--==================================================================================================================--
        self.Messages = fetchMessages() -- fetch messages
        self:UpdateChatDisplay(scrollingFrame) -- update display
--==================================================================================================================--
        spawn(function() -- background thread to fetch messages
            while true do -- infinite loop
                wait(2) -- wait 2 seconds
                local msgs = fetchMessages() -- fetch messages
                if #msgs ~= #self.Messages then -- if there's a change
                    self.Messages = msgs -- update messages
                    self:UpdateChatDisplay(scrollingFrame) -- update display
                end
            end
        end)
    end
--==================================================================================================================--
    function ChatManager:FormatMessage(msgData)
        return string.format('<font color="rgba(0, 255, 85, 1)">%s</font> %s', msgData.user, msgData.text)
    end
--==================================================================================================================--
    function ChatManager:UpdateChatDisplay(scrollingFrame) -- updates the chat display
        if not scrollingFrame then 
            warn("ChatManager: scrollingFrame is nil in UpdateChatDisplay!")
            return 
        end
        local ok, err = pcall(function()
            scrollingFrame:Clear() -- clear existing messages
            for _, msg in ipairs(self.Messages) do -- for each message
                scrollingFrame:AddLabel(self:FormatMessage(msg), true) -- add formatted message
            end
            scrollingFrame.CanvasPosition = Vector2.new(0, scrollingFrame.AbsoluteCanvasSize.Y)
            --^^ auto scroll to bottom
        end)
        if not ok then
            warn("ChatManager: UpdateChatDisplay errored:", err)
        end
    end
end
--==================================================================================================================--
print([[

  ____                                                         _                ____  ___   ___  ____    _                    _______     _____
 |  _ \ ___ _ __ ___  _____   _____ _ __ __ _ _ __   ___ ___  (_)___    __ _   / ___|/ _ \ / _ \|  _ \  | |__   ___  _   _   / /___ /   _|___ /
 | |_) / _ \ '__/ __|/ _ \ \ / / _ \ '__/ _` | '_ \ / __/ _ \ | / __|  / _` | | |  _| | | | | | | | | | | '_ \ / _ \| | | | / /  |_ \  (_) |_ \
 |  __/  __/ |  \__ \  __/\ V /  __/ | | (_| | | | | (_|  __/ | \__ \ | (_| | | |_| | |_| | |_| | |_| | | |_) | (_) | |_| | \ \ ___) |  _ ___) |
 |_|   \___|_|  |___/\___| \_/ \___|_|  \__,_|_| |_|\___\___| |_|___/  \__,_|  \____|\___/ \___/|____/  |_.__/ \___/ \__, |  \_\____/  (_)____/
                                                                                                                     |___/

]])

return ChatManager
