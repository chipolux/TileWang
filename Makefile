.PHONY: run
run: resources
	python tile_viewer.py

.PHONY: demo
demo:
	qmlscene app/ui/TileViewer.qml

.PHONY: build
build: resources
	python -m nsist installer.cfg

.PHONY: resources
resources:
	pyrcc5 app/ui/resources.qrc -o app/resources.py

.PHONY: clean
clean:
	rm -f app/resources.py
	rm -f app/ui/*.qmlc
	rm -rf __pycache__
	rm -rf app/__pycache__
	rm -rf build
