function init(self)
    msg.post(".", "acquire_input_focus")
    msg.post("#physicsproxy", "load")
end

function on_message(self, message_id, message, sender)
    if message_id == hash("proxy_loaded") then
        msg.post(sender, "init")
        msg.post(sender, "enable")
    end
end