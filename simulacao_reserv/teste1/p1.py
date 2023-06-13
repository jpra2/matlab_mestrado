import datashader as ds, bokeh, holoviews as hv  # noqa
from packaging.version import Version

min_versions = dict(ds='0.14.0', bokeh='2.4.3', hv='1.15.0')

for lib, ver in min_versions.items():
    v = globals()[lib].__version__
    if Version(v) < Version(ver):
        print("Error: expected {}={}, got {}".format(lib,ver,v))