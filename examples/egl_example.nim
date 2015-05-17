## *io-egl* - Nim bindings for EGL, the native platform interface for rendering
## APIs.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.

import egl, nativewindow, os


# get and initialize an EGL display connection
var window: NativeWindow
window.display = eglGetDisplay(0)
discard eglInitialize(window.display, nil, nil)

# get appropriate EGL frame buffer configuration
var config: EGLConfig
var configAttribs = @[
  EGL_RED_SIZE, 1,
  EGL_GREEN_SIZE, 1,
  EGL_BLUE_SIZE, 1,
  EGL_NONE
]

discard eglChooseConfig(window.display, addr configAttribs[0], addr config, 0, nil)

# create native window
discard createNativeWindow(addr window, 400, 300)

# create EGL window surface
window.surface = eglCreateWindowSurface(window.display, config, window.nativeWindow, nil)

# attach context to surface
discard eglMakeCurrent(window.display, window.surface, window.surface, window.context)

sleep(5000)
