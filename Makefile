.PHONY: run
run:
	python tile_viewer.py

.PHONY: demo
demo:
	qmlscene app/ui/TileViewer.qml

.PHONY: build
build:
	python -m nsist installer.cfg

.PHONY: clean
clean:
	rm -f app/ui/*.qmlc
	rm -rf __pycache__
	rm -rf app/__pycache__
	rm -rf build
