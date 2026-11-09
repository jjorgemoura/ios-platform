# Monorepo: no root Package.swift. Every package under Packages/ is built and tested on its own.
WORKSPACE := $(firstword $(wildcard *.xcworkspace))
PACKAGES  := $(sort $(wildcard Packages/*))
SOURCES   := Packages Apps
PLATFORM  ?= iOS

.DEFAULT_GOAL := lint
.PHONY: format lint lint-xcode analyse test build demo

format:
	swift format --in-place --recursive $(SOURCES)

lint:
	swift format lint --strict --recursive $(SOURCES)
	swiftlint --strict --no-cache $(SOURCES)

lint-xcode:
	@if command -v swiftlint >/dev/null; then \
		swiftlint lint $(SOURCES); \
	else \
		echo "warning: SwiftLint not installed, skipping"; \
	fi

# Analyzer rules need a compiler log from a clean build, so this is slow.
analyse:
	@for p in $(PACKAGES); do \
		rm -rf $$p/.build/analyse; \
		swift build --package-path $$p --scratch-path $$p/.build/analyse -v > $$p/.build/analyse.log 2>&1 \
			|| { tail -20 $$p/.build/analyse.log; exit 1; }; \
		swiftlint analyze --compiler-log-path $$p/.build/analyse.log; \
	done

test:
	@for p in $(PACKAGES); do \
		echo "==> $$p"; \
		swift test --package-path $$p -Xswiftc -warnings-as-errors || exit 1; \
	done

# Build every package for one platform: make build PLATFORM=watchOS
build:
	@for p in $(PACKAGES); do \
		echo "==> $$p ($(PLATFORM))"; \
		xcodebuild build -workspace $(WORKSPACE) -scheme $$(basename $$p) \
			-destination 'generic/platform=$(PLATFORM)' -quiet || exit 1; \
	done

demo:
	open $(WORKSPACE)
