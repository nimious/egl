## *egl* - Nim bindings for EGL, the native platform interface for rendering
## APIs.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.

# In this example code, initialize EGL without X11 and create OpenGL context.
# You can do off-screen rendering, GPGPU or querying OpenGL info with OpenGL functions.
import egl, opengl
{.passL: "-lEGL".}

# OpenGL version
const
  GLMajorVer = 4
  GLMinorVer = 0

# Initialize EGL
var display = eglGetDisplay(EGL_DEFAULT_DISPLAY)
doAssert display != EGL_NO_DISPLAY
doAssert eglInitialize(display, nil, nil) != EGL_FALSE

var config: EGLConfig
var numConfig: EGLint
var configAttribs  = [
    cast[EGLint](EGL_SURFACE_TYPE),       EGL_PBUFFER_BIT,
    EGL_RENDERABLE_TYPE,    EGL_OPENGL_BIT,
    EGL_NONE
]
doAssert eglChooseConfig(display, addr configAttribs[0], addr config, 1, addr numConfig) != EGL_FALSE
doAssert numConfig > 0
doAssert eglBindAPI(EGL_OPENGL_API) != EGL_FALSE

const EGL_CONTEXT_FLAGS_KHR: EGLint  = 0x30FC
const EGL_CONTEXT_OPENGL_DEBUG_BIT_KHR: EGLint              = 0x00000001
const EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE_BIT_KHR: EGLint = 0x00000002

var contextAttrib = [
    cast[EGLint](EGL_CONTEXT_MAJOR_VERSION),    GLMajorVer,
    EGL_CONTEXT_MINOR_VERSION,                  GLMinorVer,
    EGL_CONTEXT_OPENGL_PROFILE_MASK,            EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT,
    EGL_CONTEXT_FLAGS_KHR,                      EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE_BIT_KHR,
    EGL_NONE
]
var context = eglCreateContext(display, config, EGL_NO_CONTEXT, addr contextAttrib[0])
doAssert context != EGL_NO_CONTEXT
doAssert eglMakeCurrent(display, EGL_NO_SURFACE, EGL_NO_SURFACE, context) != EGL_FALSE

loadExtensions()

# You can use OpenGL from here
let verStr = glGetString(GL_VERSION)
doAssert verStr != nil
echo cast[cstring](verStr)

# Uninitialize EGL
discard eglTerminate(display)
