--[[
As much as i hate comments, i will explain every part of it.
this is MADE FOR OBSIFIED. not sure if you can use it for obsidian but okay.
https://github.com/itssjustaiden/obsified
]]

local ChatManager = {} do
    ChatManager.Messages = {}
    local SERVER_URL = "https://obsifiedchatmanageraddon.egesdabest.workers.dev/?room=default"
    local BaseGroupbox = getgenv().Library and getgenv().Library.BaseGroupbox or nil
    local function fetchMessages()
        local success, response = pcall(function()
            return game:GetService("HttpService"):GetAsync(SERVER_URL)
        end)
        if success and response then
            local data = game:GetService("HttpService"):JSONDecode(response)
            if type(data) == "table" then return data end
        end
        return {}
    end
    local function postMessage(msg)
        local success, _ = pcall(function()
            local payload = game:GetService("HttpService"):JSONEncode(msg)
            game:GetService("HttpService"):PostAsync(SERVER_URL, payload, Enum.HttpContentType.ApplicationJson)
        end)
        return success
    end
    function ChatManager:FormatMessage(msgData)
        return string.format('<font color="rgba(0, 255, 85, 1)">%s</font> %s', msgData.user, msgData.text)
    end
    function ChatManager:UpdateChatDisplay(container)
        if not container then warn("ChatManager: container is nil!") return end
        pcall(function()
            container:Clear()
            for _, msg in ipairs(self.Messages) do
                container:AddLabel(self:FormatMessage(msg), true)
            end
        end)
    end
    function ChatManager:CreateChat(tab)
        if not tab then warn("ChatManager: tab is nil!") return end
        if BaseGroupbox and not getmetatable(tab) then setmetatable(tab, BaseGroupbox) end
        local ok1, leftGroupbox = pcall(function() return tab:AddLeftGroupbox("Messages", "chat") end)
        if not ok1 or not leftGroupbox then warn("ChatManager: AddLeftGroupbox failed:", leftGroupbox) return end
        local ok2, rightGroupbox = pcall(function() return tab:AddRightGroupbox("Chat") end)
        if not ok2 or not rightGroupbox then warn("ChatManager: AddRightGroupbox failed:", rightGroupbox) return end
        local ok3, input = pcall(function() return rightGroupbox:AddInput("ChatInput", {Text = ""}) end)
        if not ok3 or not input then warn("ChatManager: AddInput failed:", input) return end
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
        if not ok4 or not button then warn("ChatManager: AddButton failed:", button) return end
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