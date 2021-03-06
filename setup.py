#!/usr/bin/env python

from __future__ import print_function, division
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
from subprocess import call
from distutils.core import setup
from distutils.extension import Extension
from distutils.command.clean import clean
from Cython.Distutils import build_ext
from Cython.Build import cythonize

def tryremove(filename):
    if not os.path.isfile(filename):
        return
    try: os.remove(filename)
    except OSError as e:
        print(e)

class Clean(clean):
    side_effects = [
        "mpv.c",
    ]
    def run(self):
        for f in self.side_effects:
            tryremove(f)
        clean.run(self)
setup(
    cmdclass = {
        "build_ext": build_ext,
        "clean": Clean,
    },
    ext_modules = cythonize([Extension("mpv", ["mpv.pyx"], libraries=['mpv'])],compiler_directives={
        "embedsignature":True,
        # "always_allow_kwords":True,
        "cdivision_warnings":True,
        "cdivision":True,
        "infer_types":True,
        "boundscheck":False,
        "overflowcheck":False,
        "wraparound":False})
)
