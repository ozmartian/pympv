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

import pathlib
from subprocess import call
from distutils.core import setup
from distutils.extension import Extension
from distutils.command.clean import clean
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import re
def tryremove(filename):
    pth = pathlib.Path(filename).absolute()
    if not pth.exists() or not pth.is_file():
        return
    try:
        pth.unlink()
    except Exception as e:
        print(e)

class Clean(clean):
    side_effects = [
        "mpv.cpp","mpv.c"
    ]
    def run(self):
        for f in self.side_effects:
            tryremove(f)
        clean.run(self)
from Cython.Compiler.AutoDocTransforms import EmbedSignature

old_embed_signature = EmbedSignature._embed_signature
def new_embed_signature(self, sig, doc):

    # Strip any `self` parameters from the front.
    sig = re.sub(r'\(self(,\s+)?', '(', sig)

    # If they both start with the same signature; skip it.
    if sig and doc:
        new_name = sig.split('(')[0].strip()
        old_name = doc.split('(')[0].strip()
        if new_name == old_name:
            return doc
        if new_name.endswith('.' + old_name):
            return doc

    return old_embed_signature(self, sig, doc)

EmbedSignature._embed_signature = new_embed_signature
setup(
    name="mpv",
    version='0.0.1',
    description='cython wrapper around libmpv',
    url = "https://github.com/gdkar/pympv.git",
    cmdclass = {
        "build_ext": build_ext,
        "clean": Clean,
    },
    ext_modules = cythonize([Extension("mpv", ["mpv.pyx"], libraries=['mpv'],language="c++")],compiler_directives={
        "embedsignature":True,
        "always_allow_keywords":False,
        "cdivision_warnings":False,
        "cdivision":True,
        "linetrace":True,
        "infer_types":True,
        "boundscheck":True,
        "overflowcheck":False,
        "wraparound":True,
        "language_level":3
        },
        ),
#        zip_safe = False
)
