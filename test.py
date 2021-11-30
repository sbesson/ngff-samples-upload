#! /usr/bin/env python
# Minimal test of the sanity of a zipped Zarr dataset

import zarr
import sys
store = zarr.ZipStore(sys.argv[1])
g = zarr.group(store=store)
if not g.groups():
    sys.exit(1)
for x in list(g.groups()):
    print(x)