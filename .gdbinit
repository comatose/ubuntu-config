python
import sys
sys.path.insert(0, '/home/comatose/bin/gdb-stl-printer/')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
