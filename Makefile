.PHONY: build run test package icon clean

build:      ## Build build/Kilim.app
	@Scripts/build.sh

run: build  ## Build and (re)launch the app
	@-pkill -x Kilim
	@open build/Kilim.app

test:       ## Headless checks (languages, audio, physics)
	@Scripts/test.sh

package:    ## Create dist/Kilim-<version>.zip
	@Scripts/package.sh

icon:       ## Regenerate Resources/AppIcon.icns
	@Scripts/make-icon.sh

clean:
	rm -rf .build build dist
