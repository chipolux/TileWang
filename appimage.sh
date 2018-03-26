mkdir -p TileViewer-x86_64.AppImage/TileViewer.AppDir
cd TileViewer-x86_64.AppImage/
wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

cd TileViewer.AppDir
HERE=$(dirname $(readlink -f "${0}"))

bash ../Miniconda3-latest-Linux-x86_64.sh -b -p ./conda
rm ../Miniconda3-latest-Linux-x86_64.sh
PATH="${HERE}"/conda/bin:$PATH
# TODO: learn what these conda things do
# conda config --add channels conda-forge
# conda config --add channels freecad
# conda create -n freecad freecad python=3.5 -y

cd ..

# TODO: bring in our own icon
# cp ${HERE}/conda/envs/freecad/data/freecad-icon-64.png .

# TODO: figure out what the source thing is doing
cat > ./AppRun <<\EOF
#!/bin/sh
HERE=$(dirname $(readlink -f "${0}"))
export PATH="${HERE}"/miniconda3/bin:$PATH
source activate freecad
FreeCAD
EOF

chmod a+x ./AppRun


# TODO: learn what these desktop shortcut file options do
cat > ./TileViewer.desktop <<\EOF
[Desktop Entry]
Name=TileViewer
Icon=freecad-icon-64
Exec=FreeCAD %u
Categories=CAD;
StartupNotify=true
EOF
