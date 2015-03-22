import os.path
import sys
filename = str(sys.argv[1])
print("Filename %s" % str(filename))
extension = os.path.splitext(filename)[1]
print("extension %s" % str(extension))


