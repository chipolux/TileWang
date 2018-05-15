# TileWang
A tileset viewer to make figuring out indexes, offsets, and row/column info
nice and easy.


## Running
* `pip install -r requirements.txt`
* `make`


## Building A Release
* `pip install -r requirements.txt`
* Install the latest version of pynsist. This will be unecessary once pynsist
  bumps to version 2.2.
    * `pip install flit`
    * `git clone https://github.com/takluyver/pynsist.git`
    * `cd pynsist && flit install`
* `make installer`
* Your release is in the `build` folder!
