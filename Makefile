.PHONY: node_modules

all: node_modules bin/fava icons

node_modules:
	npm update
	cd app && npm update

bin/fava: build/fava
	cd build/fava; git fetch; git reset --hard origin/master
	make -C build/fava
	make -C build/fava pyinstaller
	mkdir -p app/bin
	cp build/fava/dist/fava app/bin/fava

build/fava:
	git clone git@github.com:beancount/fava.git build/fava

clean:
	rm -rf build/fava app/bin dist
	rm -rf node_modules app/node_modules

dist: node_modules icons
	npm run dist

# Requires imagemagick's convert
icons: build/icon.icns build/icon.ico

build/icon.ico: icon.svg
	convert -background none -define icon:auto-resize=256,128,48,32,16 icon.svg build/icon.ico

build/icon.icns: icon.svg
	mkdir -p build/Fava.iconset
	convert -background none -resize 16x16 icon.svg build/Fava.iconset/icon_16x16.png
	convert -background none -resize 32x32 icon.svg build/Fava.iconset/icon_32x32.png
	cp build/Fava.iconset/icon_32x32.png build/Fava.iconset/icon_16x16@2x.png
	convert -background none -resize 64x64 icon.svg build/Fava.iconset/icon_32x32@2x.png
	convert -background none -resize 128x128 icon.svg build/Fava.iconset/icon_128x128.png
	convert -background none -resize 256x256 icon.svg build/Fava.iconset/icon_256x256.png
	cp build/Fava.iconset/icon_256x256.png build/Fava.iconset/icon_128x128@2x.png
	convert -background none -resize 512x512 icon.svg build/Fava.iconset/icon_512x512.png
	cp build/Fava.iconset/icon_512x512.png build/Fava.iconset/icon_256x256@2x.png
	convert -background none -density 1024 -resize 1024x1024 icon.svg build/Fava.iconset/icon_512x512@2x.png
	iconutil --convert icns --output build/icon.icns build/Fava.iconset
	rm -r build/Fava.iconset
