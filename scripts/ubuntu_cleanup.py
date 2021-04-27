#! /usr/bin/env python3

#
# Extract names of the packages that could be potentially be removed without destroying the system.
# Use with care, here be dragons.
#

from apt import cache

# installed packages

installed = {pkg.name:pkg for pkg in cache.Cache()
             if pkg.is_installed}

minstalled = {pkg.name: pkg for pkg in cache.Cache()
             if pkg.is_installed and not pkg.is_auto_installed}

# to be kept

interactive = set([
    'bash',
    'dash',
    'tasksel',
    'openssh-server',
])

dev = set([
    'automake',
])

tobekept = set([
    'apt-file',
    'cloud-init',
    'g++',
    'gcc',
    'i3',
    'linux-generic',
    'linux-image-generic',
    'lubuntu-desktop',
    'python3',
    'ubuntu-advantage-tools',
    'ubuntu-minimal',
    'ubuntu-server',
    'ubuntu-standard',
    'virtualbox-guest-x11',
    'xserver-xorg',
]).union(dev).union(interactive)

tobekeptdeps = set()

while len(tobekept) > 0:
    k = tobekept.pop()
    if k in installed and k not in tobekeptdeps:
        tobekeptdeps.add(k)
        deps = set(dep_pkg.name for dep in installed[k].installed.get_dependencies(
            'PreDepends', 'Depends', 'Recommends') for dep_pkg in dep)
        tobekept = tobekept.union(deps)

#print('\n'.join(pkg for pkg in tobekeptdeps))

print('\n'.join(pkg for (pkg, pkgdata) in minstalled.items() if pkg not in tobekeptdeps))
