import os, string, sys
pj = os.path.join

# Bring in the AutoDist build helper
sys.path.append('tools/build')
from AutoDist import *

#------------------------------------------------------------------------------
# Define some generally useful functions
#------------------------------------------------------------------------------
def GetCppDomVersion():
   "Gets the CppDom version from cppdom/version.h"
   import re

   contents = open('cppdom/version.h', 'r').read()
   major = re.compile('.*(#define *CPPDOM_VERSION_MAJOR *(\d+)).*', re.DOTALL).sub(r'\2', contents)
   minor = re.compile('.*(#define *CPPDOM_VERSION_MINOR *(\d+)).*', re.DOTALL).sub(r'\2', contents)
   patch = re.compile('.*(#define *CPPDOM_VERSION_PATCH *(\d+)).*', re.DOTALL).sub(r'\2', contents)
   return (int(major), int(minor), int(patch))

def GetPlatform():
   "Determines what platform this build is being run on."
   if string.find(sys.platform, 'irix') != -1:
      return 'irix'
   elif string.find(sys.platform, 'linux') != -1:
      return 'linux'
   elif string.find(sys.platform, 'cygwin') != -1:
      return 'win32'
   elif string.find(os.name, 'win32') != -1:
      return 'win32'
   else:
      return sys.platform
Export('GetPlatform')

def CreateConfig(target, source, env):
   "Creates the prefix-config file users use to compile against this library"
   import re

   targets = map(lambda x: str(x), target)
   sources = map(lambda x: str(x), source)

   submap = env['submap']

   # Build each target from its source
   for i in range(len(targets)):
      print "Generating config file " + targets[i]
      contents = open(sources[i], 'r').read()

      # Go through the substitution dictionary and modify the contents read in
      # from the source file
      for key, value in submap.items():
         contents = re.sub(re.escape(key), re.escape(value), contents)

      # Write out the target file with the new contents
      open(targets[0], 'w').write(contents)
      os.chmod(targets[0], 0755)
   return 0

def BuildLinuxEnvironment():
   "Builds a base environment for other modules to build on set up for linux"
   global optimize, profile, builders

   CXX = os.path.basename(WhereIs('g++3') or 'g++')
   LINK = CXX
   CXXFLAGS = ['-Wall']
   LINKFLAGS = []

   # Enable profiling?
   if profile != 'no':
      CXXFLAGS.extend(['-pg'])
      LINKFLAGS.extend(['-pg'])

   # Debug or optimize build?
   if optimize != 'no':
      CXXFLAGS.extend(['-DNDEBUG', '-O2'])
   else:
      CXXFLAGS.extend(['-D_DEBUG', '-g'])

   return Environment(
      ENV         = os.environ,
      CXX         = CXX,
      CXXFLAGS    = CXXFLAGS,
      LINK        = LINK,
      LINKFLAGS   = LINKFLAGS
   )

def BuildIRIXEnvironment():
   "Builds a base environment for other modules to build on set up for IRIX"
   global optimize, profile, builders

   CXX = 'CC'
   LINK = CXX
   CXXFLAGS = ['-n32', '-mips3', '-LANG:std', '-w2']
   LINKFLAGS = CXXFLAGS

   # Enable profiling?
   if profile != 'no':
      CXXFLAGS.extend([])
      LINKFLAGS.extend([])

   # Debug or optimize build?
   if optimize != 'no':
      CXXFLAGS.extend(['-DNDEBUG', '-O2'])
   else:
      CXXFLAGS.extend(['-D_DEBUG', '-g', '-gslim'])

   return Environment(
      ENV         = os.environ,
      CXX         = CXX,
      CXXFLAGS    = CXXFLAGS,
      LINK        = LINK,
      LINKFLAGS   = LINKFLAGS
   )

def BuildWin32Environment():
   return Environment(ENV = os.environ)

#------------------------------------------------------------------------------
# Grok the arguments to this build
#------------------------------------------------------------------------------
EnsureSConsVersion(0,10)

# Figure out what vesion of CppDom we're using
CPPDOM_VERSION = GetCppDomVersion()
print 'Building CppDom Version: %i.%i.%i' % CPPDOM_VERSION

# Get command-line arguments
optimize = ARGUMENTS.get('optimize', 'no')
profile = ARGUMENTS.get('profile', 'no')
PREFIX = ARGUMENTS.get('prefix', '/usr/local')
Prefix(PREFIX)
Export('PREFIX')

# Create the extra builders
# Define a builder for the cppdom-config script
builders = {
   'ConfigBuilder'   : Builder(action = CreateConfig)
}

# Create and export the base environment
if GetPlatform() == 'irix':
   baseEnv = BuildIRIXEnvironment()
elif GetPlatform() == 'linux':
   baseEnv = BuildLinuxEnvironment()
elif GetPlatform() == 'win32':
   baseEnv = BuildWin32Environment()
else:
   print 'Unsupported build environment: ' + GetPlatform()
   sys.exit(-1)
Export('baseEnv')

# Process subdirectories
subdirs = Split("""
   cppdom
   test
""")



# Create the CppDom package
pkg = Package('cppdom', '%i.%i.%i' % CPPDOM_VERSION)
pkg.addExtraDist(Split("""
   AUTHORS
   ChangeLog
   COPYING
   README
   cppdom-config.in
   SConstruct
   cppdom/SConstruct
   doc/cppdom.doxy
   doc/dox/examples_index.dox
   doc/dox/mainpage.dox
   test/SConstruct
   tools/build/AutoDist.py
   vc7/cppdom.sln
   vc7/cppdom.vcproj
"""))
Export('pkg')

# Process subdirectories
subdirs = Split('cppdom test')
SConscript(dirs = subdirs)


# Setup the builder for cppdom-config
env = baseEnv.Copy(BUILDERS = builders)
env.ConfigBuilder('cppdom-config', 'cppdom-config.in',
   submap = {
      '@prefix@'                    : PREFIX,
      '@exec_prefix@'               : '${prefix}',
      '@cppdom_cxxflags@'           : '',
      '@includedir@'                : pj(PREFIX, 'include'),
      '@cppdom_extra_cxxflags@'     : '',
      '@cppdom_extra_include_dirs@' : '',
      '@cppdom_libs@'               : '-lcppdom',
      '@libdir@'                    : pj(PREFIX, 'lib'),
      '@VERSION_MAJOR@'             : str(CPPDOM_VERSION[0]),
      '@VERSION_MINOR@'             : str(CPPDOM_VERSION[1]),
      '@VERSION_PATCH@'             : str(CPPDOM_VERSION[2]),
   }
)

env.Depends('cppdom-config', 'cppdom/version.h')
env.Install(pj(PREFIX, 'bin'), 'cppdom-config')

pkg.build()

# Build everything by default
Default('.')
