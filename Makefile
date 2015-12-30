test:
	xcodebuild test -workspace SmartPark.xcworkspace/ -scheme SmartPark -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6' | xcpretty --test --color
build:
	xcodebuild build -workspace SmartPark.xcworkspace/ -scheme SmartPark
