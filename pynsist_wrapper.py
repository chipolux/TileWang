# from pkg_resources import parse_version
import os
import sys
import zipfile

from nsist import (
    configreader, get_installer_builder_args, InstallerBuilder, InputError
)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Provide config file!')
        sys.exit(1)

    # load config file, parse into arguments, and setup InstallerBuilder
    config = configreader.read_and_validate(sys.argv[1])
    args = get_installer_builder_args(config)
    builder = InstallerBuilder(**args)

    print('Setting up build directory...')
    try:
        builder.run(makensis=False)
    except InputError as e:
        print("Error in config values:")
        print(str(e))
        sys.exit(1)

    print('Building installer...')
    if builder.run_nsis() == 0:
        print('Installer created: {}'.format(builder.installer_name))

    print('Creating auto-updater bundle...')
    bundle_name = builder.installer_name.replace('exe', 'zip')
    bundle_path = os.path.join(builder.build_dir, bundle_name)
    pkg_path = os.path.join(builder.build_dir, 'pkgs')

    stored = 0
    with zipfile.ZipFile(bundle_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        # store install files (launch script, icons, etc.)
        for filename, _ in builder.install_files:
            filepath = os.path.join(builder.build_dir, filename)
            zf.write(filepath, arcname=filename)
            stored += 1
            print('Stored {} files...'.format(stored), end='\r')
        # store package files
        for root, dirs, filenames, in os.walk(pkg_path):
            for filename in filenames:
                filepath = os.path.join(root, filename)
                arcname = filepath.replace(
                    builder.build_dir, ''
                ).lstrip(os.path.sep)
                zf.write(filepath, arcname=arcname)
                stored += 1
                print('Stored {} files...'.format(stored), end='\r')
