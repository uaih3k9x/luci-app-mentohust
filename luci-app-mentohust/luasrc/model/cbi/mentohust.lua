local sys = require "luci.sys"

local m, s, o

m = Map("mentohust", translate("MentoHUST"))
m.description = translate("MentoHUST is a program that supports Ruijie authentication on Windows, Linux and Mac OS (with support for Searle authentication).")

m:section(SimpleSection).template = "mentohust/mentohust_status"

s = m:section(TypedSection, "mentohust")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty = false

o = s:option(Value, "username", translate("Username"))
o.datatype = "string"
o.rmempty = true

o = s:option(Value, "password", translate("Password"))
o.datatype = "string"
o.password = true
o.rmempty = true

o = s:option(Value, "interface", translate("Network interface"))
for _, dev in ipairs(sys.net.devices()) do
	if dev ~= "lo"
		and not dev:match("^docker")
		and not dev:match("^dummy")
		and not dev:match("^radio")
		and not dev:match("^sit")
		and not dev:match("^teql")
		and not dev:match("^veth")
		and not dev:match("^ztly")
	then
		o:value(dev)
	end
end
o.rmempty = false

o = s:option(Value, "ipaddr", translate("IP address"))
o.description = translate("Leave blank or set 0.0.0.0 to use local IP (DHCP)")
o.default = "0.0.0.0"
o.datatype = "ip4addr"
o.rmempty = true

o = s:option(Value, "gateway", translate("Gateway"))
o.default = "0.0.0.0"
o.datatype = "ip4addr"
o.rmempty = false

o = s:option(Value, "mask", translate("Subnet Mask"))
o.default = "255.255.255.0"
o.datatype = "ip4addr"
o.rmempty = false

o = s:option(Value, "dns", translate("DNS"))
o.default = "0.0.0.0"
o.datatype = "ip4addr"
o.rmempty = true

o = s:option(Value, "ping", translate("Ping Host"))
o.description = translate("Ping host for drop detection, 0.0.0.0 to turn off this feature.")
o.default = "0.0.0.0"
o.datatype = "ip4addr"
o.rmempty = false

o = s:option(Value, "timeout", translate("Authentication Timeout (Seconds)"))
o.default = "8"
o.datatype = "uinteger"
o.rmempty = false

o = s:option(Value, "interval", translate("Response Interval (Seconds)"))
o.default = "30"
o.datatype = "uinteger"
o.rmempty = false

o = s:option(Value, "wait", translate("Await Failure(Seconds)"))
o.default = "15"
o.datatype = "uinteger"
o.rmempty = false

o = s:option(Value, "fail_number", translate("Allow Failure Count"))
o.description = translate("Default 0, indicating no limit.")
o.default = "0"
o.datatype = "uinteger"
o.rmempty = false

o = s:option(ListValue, "multicast_address", translate("Multicast Address"))
o.default = "1"
o:value("0", translate("Standard"))
o:value("1", translate("Ruijie"))
o:value("2", translate("Searle"))

o = s:option(ListValue, "dhcp_mode", translate("DHCP Mode"))
o.default = "1"
o:value("0", translate("None"))
o:value("1", translate("Two-factor authentication"))
o:value("2", translate("After authentication"))
o:value("3", translate("Before authentication"))

o = s:option(Value, "dhcp_script", translate("DHCP Script"))
o.description = translate("Default udhcpc -i")
o.default = "udhcpc -i"
o.rmempty = true

o = s:option(Value, "version", translate("Client Version Number"))
o.description = translate("Default 0.00, indicating compatibility with xrgsu")
o.default = "0.00"
o.rmempty = false

return m
