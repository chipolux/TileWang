.PHONY: run
run: resources
	python tile_viewer.py

.PHONY: demo
demo:
	qmlscene TileViewer.qml

.PHONY: build
build: resources
	python -m nsist installer.cfg

.PHONY: resources
resources:
	pyrcc5 resources.qrc -o resources.py

.PHONY: clean
clean:
	rm -f resources.py
	rm -f *.qmlc
	rm -rf __pycache__
