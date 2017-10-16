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
	cd "$(shell pwd)/build/release" && \
	zip -r -X Bedim.zip Bedim.app
	@echo ""
	@echo "SHA256 of Bedim.zip:"
	@cd "$(shell pwd)/build/release" && \
		shasum -a 256 "$(shell pwd)/build/release/Bedim.zip"
