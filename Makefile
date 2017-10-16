.PHONY: build

all:

bootstrap:
	carthage bootstrap --platform macOS

build:
	xcodebuild \
		-workspace Bedim.xcworkspace \
		-scheme Bedim \
		-configuration Release \
		SYMROOT="$(shell pwd)/build/" \
		clean build
	open $(shell pwd)/build/

release:
	rm -rf .tmp build
	mkdir .tmp
	xcodebuild \
		-workspace Bedim.xcworkspace \
		-scheme Bedim \
		-configuration "Release" archive \
		-archivePath "$(shell pwd)/.tmp/Bedim.xcarchive"

	xcodebuild \
		-exportArchive \
		-archivePath "$(shell pwd)/.tmp/Bedim.xcarchive" \
		-exportPath "$(shell pwd)/.tmp/Bedim" \
		-exportOptionsPlist "$(shell pwd)/utils/export.plist"

	mv "$(shell pwd)/.tmp/Bedim/Bedim.app" "$(shell pwd)/.tmp/Bedim.app"
	cd "$(shell pwd)/.tmp" && \
		rm -rfv Bedim Bedim.xcarchive

	spctl -a -vvv "$(shell pwd)/.tmp/Bedim.app"

	mkdir -p build

	utils/create-dmg \
		--volname "Bedim" \
		--window-pos 200 120 \
		--window-size 800 400 \
		--icon-size 100 \
		--icon Bedim.app 200 190 \
		--hide-extension Bedim.app \
		--app-drop-link 600 185 \
		build/Bedim.dmg \
		"$(shell pwd)/.tmp/"

	rm -rf .tmp
	@echo ""
	@echo ""
	@echo "Built Bedim.dmg @ ./build"
	@printf "DMG SHA256 is "
	@shasum -ba 256 ./build/Bedim.dmg | awk '{ print $$1 }'
