#!/usr/bin/env sh
set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
SDK_IMAGE="${SDK_IMAGE:-openwrt/sdk:x86_64-21.02.7}"
OUT_DIR="${OUT_DIR:-$REPO_ROOT/../openwrt-sdk-work/build}"

mkdir -p "$OUT_DIR"

docker run --rm --platform linux/amd64 \
	-v "$REPO_ROOT:/src:ro" \
	-v "$OUT_DIR:/out" \
	"$SDK_IMAGE" \
	sh -lc '
		set -eu
		./scripts/feeds update luci
		./scripts/feeds install -p luci luci-base csstidy
		cp -a /src/luci-app-mentohust /builder/package/luci-app-mentohust
		make defconfig
		make package/luci-app-mentohust/compile V=s
		mkdir -p /out
		find bin/packages -name "luci-app-mentohust_*.ipk" -exec cp -v {} /out/ \;
		find bin/packages -name "luci-i18n-mentohust-*.ipk" -exec cp -v {} /out/ \;
	'
