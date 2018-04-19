.PHONY: run
run:
	python tilewang.py

.PHONY: demo
demo:
	qmlscene app/ui/TileWang.qml

.PHONY: installer
installer: clean
	python -m nsist installer.cfg

.PHONY: clean
clean:
	rm -f app/ui/*.qmlc
	rm -rf __pycache__
	rm -rf app/__pycache__
	rm -rf build
