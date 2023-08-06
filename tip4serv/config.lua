Config = {}

Config.request_interval_in_minutes = 1 -- Check every x minutes if a purchase has been made on Tip4Serv

Config.time_between_each_command = 0 -- Wait x seconds between each command executed

Config.check_cmd_name = "checkdonate" -- You can edit chat command name. Default: checkdonate

Config.enable_custom_command = false -- Set to true if you are using QBCore framework or want to use custom commands: /server/commands.lua

Config.order_waiting_text = "[Tip4serv] Your order will be delivered within 30 seconds..." -- Shown to the player when he types checkdonate command

Config.order_received_text = "[Tip4serv] You have received your order. Thank you !" -- Shown to the player when they receive their order
