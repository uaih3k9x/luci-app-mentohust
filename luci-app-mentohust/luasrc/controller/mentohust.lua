module("luci.controller.mentohust", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/mentohust") then
		return
	end

	local page

	page = entry({"admin", "services", "mentohust"}, alias("admin", "services", "mentohust", "settings"), _("MentoHUST"), 60)
	page.dependent = true
	page.acl_depends = { "luci-app-mentohust" }

	entry({"admin", "services", "mentohust", "settings"}, cbi("mentohust"), _("Settings"), 10).leaf = true
	entry({"admin", "services", "mentohust", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep -f /usr/sbin/mentohust >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
