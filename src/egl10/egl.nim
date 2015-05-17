## *io-egl* - Nim bindings for EGL, the native platform interface for rendering
## APIs.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.

{.deadCodeElim: on.}

when defined(windows):
  import windows

  const dllname = "libegl.dll"

  type
    EGLNativeDisplayType* = HDC
    EGLNativePixmapType* = HBITMAP
    EGLNativeWindowType* = HWND

elif defined(macosx):
  type
    EGLNativeDisplayType* = cint
    EGLNativePixmapType* = pointer
    EGLNativeWindowType* = pointer

elif defined(android):
  #type
  #  EGLNativeDisplayType* = pointer
  #  EGLNativePixmapType* = pointer
  #  EGLNativeWindowType* = ptr ANativeWindow
  {.error: "io-serialport does not support Android yet".}

elif defined(freebsd) or defined(linux) or defined(openbsd) or defined(unix):
  import xlib, xutil

  type
    EGLNativeDisplayType* = PXDisplay
    EGLNativePixmapType* = TPixmap
    EGLNativeWindowType* = TWindow

else:
  {.error: "io-serialport does not support this platform".}


type
  # EGL 1.2 types, renamed for consistency in EGL 1.3
  NativeDisplayType* = EGLNativeDisplayType
  NativePixmapType* = EGLNativePixmapType
  NativeWindowType* = EGLNativeWindowType

  # Define EGLint. This must be a signed integral type large enough to contain
  # all legal attribute names and values passed into and out of EGL, whether
  # their type is boolean, bitmask, enumerant (symbolic constant), integer,
  # handle, or other.  While in general a 32-bit integer will suffice, if
  # handles are 64 bit types, then EGLint should be defined as a signed 64-bit
  # integer type.
  EGLInt* = int


type
  EGLBoolean* = cuint
  EGLDisplay* = pointer
  EGLConfig* = pointer
  EGLSurface* = pointer
  EGLContext* = pointer


type
  EGLAttribList* {.unchecked.} = seq[EGLInt]
  EGLMustCastToProperProcType* = proc ()


const
  EGL_ALPHA_SIZE* = 0x00003021
  EGL_BAD_ACCESS* = 0x00003002
  EGL_BAD_ALLOC* = 0x00003003
  EGL_BAD_ATTRIBUTE* = 0x00003004
  EGL_BAD_CONFIG* = 0x00003005
  EGL_BAD_CONTEXT* = 0x00003006
  EGL_BAD_CURRENT_SURFACE* = 0x00003007
  EGL_BAD_DISPLAY* = 0x00003008
  EGL_BAD_MATCH* = 0x00003009
  EGL_BAD_NATIVE_PIXMAP* = 0x0000300A
  EGL_BAD_NATIVE_WINDOW* = 0x0000300B
  EGL_BAD_PARAMETER* = 0x0000300C
  EGL_BAD_SURFACE* = 0x0000300D
  EGL_BLUE_SIZE* = 0x00003022
  EGL_BUFFER_SIZE* = 0x00003020
  EGL_CONFIG_CAVEAT* = 0x00003027
  EGL_CONFIG_ID* = 0x00003028
  EGL_CORE_NATIVE_ENGINE* = 0x0000305B
  EGL_DEPTH_SIZE* = 0x00003025
  EGL_DONT_CARE* = -1
  EGL_DRAW* = 0x00003059
  EGL_EXTENSIONS* = 0x00003055
  EGL_FALSE* = 0
  EGL_GREEN_SIZE* = 0x00003023
  EGL_HEIGHT* = 0x00003056
  EGL_LARGEST_PBUFFER* = 0x00003058
  EGL_LEVEL* = 0x00003029
  EGL_MAX_PBUFFER_HEIGHT* = 0x0000302A
  EGL_MAX_PBUFFER_PIXELS* = 0x0000302B
  EGL_MAX_PBUFFER_WIDTH* = 0x0000302C
  EGL_NATIVE_RENDERABLE* = 0x0000302D
  EGL_NATIVE_VISUAL_ID* = 0x0000302E
  EGL_NATIVE_VISUAL_TYPE* = 0x0000302F
  EGL_NONE* = 0x00003038
  EGL_NON_CONFORMANT_CONFIG* = 0x00003051
  EGL_NOT_INITIALIZED* = 0x00003001
  EGL_NO_CONTEXT* = (cast[EGLContext](0))
  EGL_NO_DISPLAY* = (cast[EGLDisplay](0))
  EGL_NO_SURFACE* = (cast[EGLSurface](0))
  EGL_PBUFFER_BIT* = 0x00000001
  EGL_PIXMAP_BIT* = 0x00000002
  EGL_READ* = 0x0000305A
  EGL_RED_SIZE* = 0x00003024
  EGL_SAMPLES* = 0x00003031
  EGL_SAMPLE_BUFFERS* = 0x00003032
  EGL_SLOW_CONFIG* = 0x00003050
  EGL_STENCIL_SIZE* = 0x00003026
  EGL_SUCCESS* = 0x00003000
  EGL_SURFACE_TYPE* = 0x00003033
  EGL_TRANSPARENT_BLUE_VALUE* = 0x00003035
  EGL_TRANSPARENT_GREEN_VALUE* = 0x00003036
  EGL_TRANSPARENT_RED_VALUE* = 0x00003037
  EGL_TRANSPARENT_RGB* = 0x00003052
  EGL_TRANSPARENT_TYPE* = 0x00003034
  EGL_TRUE* = 1
  EGL_VENDOR* = 0x00003053
  EGL_VERSION* = 0x00003054
  EGL_WIDTH* = 0x00003057
  EGL_WINDOW_BIT* = 0x00000004


proc eglChooseConfig*(display: EGLDisplay; attribList: ptr EGLInt;
  configs: ptr EGLConfig; configSize: EGLint; numConfig: ptr EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Return a list of EGL frame buffer configurations that match specified
  ## attributes.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## attribList
  ##   Specifies attributes required to match by configs.
  ## configs
  ##   Returns an array of frame buffer configurations.
  ## configSize
  ##   Specifies the size of the array of frame buffer configurations.
  ## numConfig
  ##   Returns the number of frame buffer configurations returned.
  ## result
  ##   `EGL_TRUE` on success, `EGL_FALSE` on failure.
  ##
  ## `configs` and `numConfig` are not modified when `EGL_FALSE` is returned.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_BAD_ATTRIBUTE` if `attributeList` contains an invalid frame buffer
  ##   configuration attribute or an attribute value that is unrecognized or out
  ##   of range.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_PARAMETER` if num_config is `nil`.


proc eglCopyBuffers*(display: EGLDisplay; surface: EGLSurface;
  nativePixmap: EGLNativePixmapType): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Copy EGL surface color buffer to a native pixmap.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## surface
  ##   Specifies the EGL surface whose color buffer is to be copied.
  ## nativePixmap
  ##   Specifies the native pixmap as target of the copy.
  ## result
  ##   `EGL_FALSE` if swapping of the buffers failed, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_SURFACE` if `surface` is not an EGL drawing surface.
  ## - `EGL_BAD_NATIVE_PIXMAP` if the implementation does not support native
  ##   pixmaps.
  ## - `EGL_BAD_NATIVE_PIXMAP` if `nativePixmap` is not a valid native pixmap.
  ## - `EGL_BAD_MATCH` if the format of `nativePixmap` is not compatible with
  ##   the color buffer of surface.
  ## - `EGL_CONTEXT_LOST` if a power management event has occurred. The
  ##   application must destroy all contexts and reinitialise OpenGL ES state
  ##   and objects to continue rendering.


proc eglCreateContext*(display: EGLDisplay; config: EGLConfig;
  shareContext: EGLContext; attribList: ptr EGLint): EGLContext
  {.cdecl, dynlib: dllname, importc.}
  ## Create a new EGL rendering context.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## config
  ##   Specifies the EGL frame buffer configuration that defines the frame
  ##   buffer resource available to the rendering context.
  ## shareContext
  ##   Specifies another EGL rendering context with which to share data, as
  ##   defined by the client API corresponding to the contexts. Data is also
  ##   shared with all other contexts with which `shareContext` shares data.
  ##   `EGL_NO_CONTEXT` indicates that no sharing is to take place.
  ## attribList
  ##   Specifies attributes and attribute values for the context being created.
  ##   Only the attribute EGL_CONTEXT_CLIENT_VERSION may be specified.
  ## result
  ##   `EGL_NO_CONTEXT` if creation of the context fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_MATCH` if the current rendering API is `EGL_NONE` (this can only
  ##   arise in an EGL implementation which does not support OpenGL ES, prior to
  ##   the first call to `eglBindAPI <#eglBindAPI>`_).
  ## - `EGL_BAD_MATCH` if the server context state for `shareContext` exists in
  ##   an address space which cannot be shared with the newly created context,
  ##   if `shareContext` was created on a different display than the one
  ##   referenced by `config`, or if the contexts are otherwise incompatible.
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONFIG` if `config` is not an EGL frame buffer configuration, or
  ##   does not support the current rendering API. This includes requesting
  ##   creation of an OpenGL ES 1.x context when the `EGL_RENDERABLE_TYPE`
  ##   attribute of config does not contain `EGL_OPENGL_ES_BIT`, or creation of
  ##   an OpenGL ES 2.x context when the attribute does not contain
  ##   `EGL_OPENGL_ES2_BIT`.
  ## - `EGL_BAD_CONTEXT` if `shareContext` is not an EGL rendering context of
  ##   the same client API type as the newly created context and is not
  ##   `EGL_NO_CONTEXT`.
  ## - `EGL_BAD_ATTRIBUTE` if `attribList` contains an invalid context attribute
  ##   or if an attribute is not recognized or out of range. Note that attribute
  ##   `EGL_CONTEXT_CLIENT_VERSION` is only valid when the current rendering API
  ##   is `EGL_OPENGL_ES_API`.
  ## - `EGL_BAD_ALLOC` if there are not enough resources to allocate the new
  ##   context.


proc eglCreatePbufferSurface*(display: EGLDisplay; config: EGLConfig;
  attribList: ptr EGLint): EGLSurface {.cdecl, dynlib: dllname, importc.}
  ## Create a new EGL pixel buffer surface.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## config
  ##   Specifies the EGL frame buffer configuration that defines the frame
  ##   buffer resource available to the surface.
  ## attribList
  ##   Specifies pixel buffer surface attributes. May be `nil` or empty (first
  ##   attribute is `EGL_NONE`).
  ## result
  ##   `EGL_NO_SURFACE` if creation of the context fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONFIG` if `config` is not an EGL frame buffer configuration.
  ## - `EGL_BAD_ATTRIBUTE` if `attribList` contains an invalid pixel buffer
  ##   attribute or if an attribute value is not recognized or out of range.
  ## - `EGL_BAD_ATTRIBUTE` if `attribList` contains any of the attributes
  ##   `EGL_MIPMAP_TEXTURE`, `EGL_TEXTURE_FORMAT`, or `EGL_TEXTURE_TARGET`, and
  ##   `config` does not support OpenGL ES rendering (e.g. the EGL version is
  ##   1.2 or later, and the `EGL_RENDERABLE_TYPE` attribute of config does not
  ##   include at least one of `EGL_OPENGL_ES_BIT` or `EGL_OPENGL_ES2_BIT`).
  ## - `EGL_BAD_ALLOC` if there are not enough resources to allocate the new
  ##   surface.
  ## - `EGL_BAD_MATCH` if config does not support rendering to pixel buffers
  ##   (the `EGL_SURFACE_TYPE` attribute does not contain `EGL_PBUFFER_BIT`).
  ## - `EGL_BAD_MATCH` if the `EGL_TEXTURE_FORMAT` attribute is not
  ##   `EGL_NO_TEXTURE`, and `EGL_WIDTH` and/or `EGL_HEIGHT` specify an invalid
  ##   size (e.g., the texture size is not a power of 2, and the underlying
  ##   OpenGL ES implementation does not support non-power-of-two textures).
  ## - `EGL_BAD_MATCH` if the `EGL_TEXTURE_FORMAT` attribute is
  ##   `EGL_NO_TEXTURE`, and `EGL_TEXTURE_TARGET` is something other than
  ##   `EGL_NO_TEXTURE`; or, `EGL_TEXTURE_FORMAT` is something other than
  ##   `EGL_NO_TEXTURE`, and `EGL_TEXTURE_TARGET` is `EGL_NO_TEXTURE`.
  ## - `EGL_BAD_MATCH` if config does not support the specified OpenVG alpha
  ##   format attribute (the value of `EGL_VG_ALPHA_FORMAT` is
  ##   `EGL_VG_ALPHA_FORMAT_PRE` and the `EGL_VG_ALPHA_FORMAT_PRE_BIT` is not
  ##   set in the `EGL_SURFACE_TYPE` attribute of `config`) or colorspace
  ##   attribute (the value of `EGL_VG_COLORSPACE` is `EGL_VG_COLORSPACE_LINEAR`
  ##   and the `EGL_VG_COLORSPACE_LINEAR_IT` is not set in the
  ##   `EGL_SURFACE_TYPE` attribute of `config`).


proc eglCreatePixmapSurface*(display: EGLDisplay; config: EGLConfig;
  nativePixmap: EGLNativePixmapType; attribList: ptr EGLint): EGLSurface
  {.cdecl, dynlib: dllname, importc.}
  ## Create a new EGL pixmap surface.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## config
  ##   Specifies the EGL frame buffer configuration that defines the frame
  ##   buffer resource available to the surface.
  ## nativePixmap
  ##   Specifies the native pixmap.
  ## attribList
  ##   Specifies pixmap surface attributes. May be `nil` or empty (first
  ##   attribute is `EGL_NONE`).
  ## result
  ##   `EGL_NO_SURFACE` if creation of the context fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONFIG` if config is not an EGL config.
  ## - `EGL_BAD_NATIVE_PIXMAP` if `nativePixmap` is not a valid native pixmap.
  ## - `EGL_BAD_ATTRIBUTE` if `attribList` contains an invalid pixmap attribute
  ##   or if an attribute value is not recognized or out of range.
  ## - `EGL_BAD_ALLOC` if there are not enough resources to allocate the new
  ##   surface.
  ## - `EGL_BAD_MATCH` if the attributes of `nativePixmap` do not correspond to
  ##   config or if config does not support rendering to pixmaps (the
  ##   `EGL_SURFACE_TYPE` attribute does not contain `EGL_PIXMAP_BIT`).
  ## - `EGL_BAD_MATCH` if config does not support the specified OpenVG alpha
  ##   format attribute (the value of `EGL_VG_ALPHA_FORMAT` is
  ##   `EGL_VG_ALPHA_FORMAT_PRE` and the `EGL_VG_ALPHA_FORMAT_PRE_BIT` is not
  ##   set in the `EGL_SURFACE_TYPE` attribute of `config`) or colorspace
  ##   attribute (the value of `EGL_VG_COLORSPACE` is `EGL_VG_COLORSPACE_LINEAR`
  ##   and the `EGL_VG_COLORSPACE_LINEAR_IT` is not set in the
  ##   `EGL_SURFACE_TYPE` attribute of `config`).


proc eglCreateWindowSurface*(display: EGLDisplay; config: EGLConfig;
  nativeWindow: EGLNativeWindowType; attribList: ptr EGLint): EGLSurface
  {.cdecl, dynlib: dllname, importc.}
  ## Create a new EGL window surface.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## config
  ##   Specifies the EGL frame buffer configuration that defines the frame
  ##   buffer resource available to the surface.
  ## nativeWindow
  ##   Specifies the native window.
  ## attribList
  ##   Specifies window surface attributes. May be `nil` or empty (first
  ##  attribute is `EGL_NONE`).
  ## result
  ##   `EGL_NO_SURFACE` if creation of the context fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONFIG` if config is not an EGL frame buffer configuration.
  ## - `EGL_BAD_NATIVE_WINDOW` if native_window is not a valid native window.
  ## - `EGL_BAD_ATTRIBUTE` if `attribList` contains an invalid window attribute
  ##   or if an attribute value is not recognized or is out of range.
  ## - `EGL_BAD_ALLOC` if there are not enough resources to allocate the new
  ##   surface.
  ## - `EGL_BAD_MATCH` if the attributes of `nativeWindow` do not correspond to
  ##   config or if config does not support rendering to windows (the
  ##   `EGL_SURFACE_TYPE` attribute does not contain `EGL_WINDOW_BIT`).
  ## - `EGL_BAD_MATCH` if config does not support the specified OpenVG alpha
  ##   format attribute (the value of `EGL_VG_ALPHA_FORMAT` is
  ##   `EGL_VG_ALPHA_FORMAT_PRE` and the `EGL_VG_ALPHA_FORMAT_PRE_BIT` is not
  ##   set in the `EGL_SURFACE_TYPE attribute of `config`) or colorspace
  ##   attribute (the value of `EGL_VG_COLORSPACE` is `EGL_VG_COLORSPACE_LINEAR`
  ##   and the `EGL_VG_COLORSPACE_LINEAR_IT` is not set in the
  ##   `EGL_SURFACE_TYPE` attribute of `config`).


proc eglDestroyContext*(display: EGLDisplay; context: EGLContext): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Destroy an EGL rendering context.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## context
  ##   Specifies the EGL rendering context to be destroyed.
  ## result
  ##   `EGL_FALSE` if destruction of the context fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONTEXT` if `context` is not an EGL rendering context.


proc eglDestroySurface*(display: EGLDisplay; surface: EGLSurface): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Destroy an EGL surface.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## surface
  ##   Specifies the EGL surface to be destroyed.
  ## result
  ##   `EGL_FALSE` if destruction of the surface fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_SURFACE` if `surface` is not an EGL surface.


proc eglGetConfigAttrib*(display: EGLDisplay; config: EGLConfig;
  attribute: EGLint; value: ptr EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Return information about an EGL frame buffer configuration.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## config
  ##   Specifies the EGL frame buffer configuration to be queried.
  ## attribute
  ##   Specifies the EGL rendering context attribute to be returned.
  ## value
  ##   Returns the requested value.
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise. `value` is not modified
  ##   when `EGL_FALSE` is returned.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONFIG` if config is not an EGL frame buffer configuration.
  ## - `EGL_BAD_ATTRIBUTE` if attribute is not a valid frame buffer
  ##   configuration attribute.


proc eglGetConfigs*(display: EGLDisplay; configs: ptr EGLConfig;
  configSize: EGLint; numConfig: ptr EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Return a list of all EGL frame buffer configurations for a display.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## configs
  ##   Returns a list of configs.
  ## configSize
  ##   Specifies the size of the list of configs.
  ## numConfig
  ##   Returns the number of configs returned.
  ## result
  ##   `EGL_TRUE` on success, `EGL_FALSE` on failure.
  ##
  ## `configs` and `numConfig` are not modified when `EGL_FALSE` is returned.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_PARAMETER` if `numConfig` is `nil`.


proc eglGetCurrentDisplay*(): EGLDisplay {.cdecl, dynlib: dllname, importc.}
  ## Return the display for the current EGL rendering context.
  ##
  ## result
  ##   The current EGL display connection.


proc eglGetCurrentSurface*(readdraw: EGLint): EGLSurface
  {.cdecl, dynlib: dllname, importc.}
  ## Return the read or draw surface for the current EGL rendering context.
  ##
  ## readdraw
  ##   Specifies whether the EGL read or draw surface is to be returned.
  ## result
  ##   The read or draw surface attached to the current EGL rendering context.


proc eglGetDisplay*(nativeDisplay: EGLNativeDisplayType): EGLDisplay
  {.cdecl, dynlib: dllname, importc.}
  ## Return an EGL display connection.
  ##
  ## nativeDisplay
  ##   Specifies the display to connect to. `EGL_DEFAULT_DISPLAY` indicates the
  ##   default display.
  ## result
  ##   The display connection, or `EGL_NO_DISPLAY` if no display connection
  ##   matching `nativeDisplay` is available.
  ##
  ## No error is generated.


proc eglGetError*(): EGLint {.cdecl, dynlib: dllname, importc.}
  ## Return error information.
  ##
  ## result
  ##   - `EGL_SUCCESS`: The last function succeeded without error.
  ##   - `EGL_NOT_INITIALIZED`: EGL is not initialized, or could not be
  ##     initialized, for the specified EGL display connection.
  ##   - `EGL_BAD_ACCESS`: EGL cannot access a requested resource (for example a
  ##     context is bound in another thread).
  ##   - `EGL_BAD_ALLOC`: EGL failed to allocate resources for the requested
  ##     operation.
  ##   - `EGL_BAD_ATTRIBUTE`: An unrecognized attribute or attribute value was
  ##     passed in the attribute list.
  ##   - `EGL_BAD_CONTEXT`: An EGLContext argument does not name a valid EGL
  ##     rendering context.
  ##   - `EGL_BAD_CONFIG`: An EGLConfig argument does not name a valid EGL frame
  ##     buffer configuration.
  ##   - `EGL_BAD_CURRENT_SURFACE`: The current surface of the calling thread is
  ##     a window, pixel buffer or pixmap that is no longer valid.
  ##   - `EGL_BAD_DISPLAY`: An EGLDisplay argument does not name a valid EGL
  ##     display connection.
  ##   - `EGL_BAD_SURFACE`: An EGLSurface argument does not name a valid surface
  ##     (window, pixel buffer or pixmap) configured for GL rendering.
  ##   - `EGL_BAD_MATCH`: Arguments are inconsistent (for example, a valid
  ##     context requires buffers not supplied by a valid surface).
  ##   - `EGL_BAD_PARAMETER`: One or more argument values are invalid.
  ##   - `EGL_BAD_NATIVE_PIXMAP`: A NativePixmapType argument does not refer to
  ##     a valid native pixmap.
  ##   - `EGL_BAD_NATIVE_WINDOW`: A NativeWindowType argument does not refer to
  ##     a valid native window.
  ##   - `EGL_CONTEXT_LOST`: A power management event has occurred. The
  ##     application must destroy all contexts and reinitialise OpenGL ES state
  ##     and objects to continue rendering.
  ##
  ## A call to eglGetError sets the error to `EGL_SUCCESS`.


proc eglGetProcAddress*(procname: cstring): EGLMustCastToProperProcType
  {.cdecl, dynlib: dllname, importc.}
  ## Return a GL or an EGL extension function.
  ##
  ## procname
  ##   Specifies the name of the function to return.
  ## result
  ##   The address of the extension function named by `procname`.


proc eglInitialize*(display: EGLDisplay; major: ptr EGLint; minor: ptr EGLint):
  EGLBoolean {.cdecl, dynlib: dllname, importc.}
  ## Initialize an EGL display connection.
  ##
  ## display
  ##   Specifies the EGL display connection to initialize.
  ## major
  ##   Returns the major version number of the EGL implementation. May be `nil`.
  ## minor
  ##   Returns the minor version number of the EGL implementation. May be `nil`.


proc eglMakeCurrent*(display: EGLDisplay; draw: EGLSurface; read: EGLSurface;
  context: EGLContext): EGLBoolean {.cdecl, dynlib: dllname, importc.}
  ## Attach an EGL rendering context to EGL surfaces.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## draw
  ##   Specifies the EGL draw surface.
  ## read
  ##   Specifies the EGL read surface.
  ## context
  ##   Specifies the EGL rendering context to be attached to the surfaces.
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise. If `EGL_FALSE` is returned,
  ##   the previously current rendering context and surfaces (if any) remain
  ##   unchanged.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_SURFACE` if `draw` or `read` is not an EGL surface.
  ## - `EGL_BAD_CONTEXT` if `context` is not an EGL rendering context.
  ## - `EGL_BAD_MATCH` if `draw` or `read` are not compatible with `context`, or
  ##   if `context` is set to `EGL_NO_CONTEXT` and `draw` or `read` are not set
  ##   to `EGL_NO_SURFACE`, or if `draw` or `read` are set to `EGL_NO_SURFACE`
  ##   and `context` is not set to `EGL_NO_CONTEXT`.
  ## - `EGL_BAD_ACCESS` if `context` is current to some other thread.
  ## - `EGL_BAD_NATIVE_PIXMAP` if a native pixmap underlying either `draw` or
  ##   `read` is no longer valid.
  ## - `EGL_BAD_NATIVE_WINDOW` if a native window underlying either `draw` or
  ##   `read` is no longer valid.
  ## - `EGL_BAD_CURRENT_SURFACE` if the previous context has unflushed commands
  ##   and the previous surface is no longer valid.
  ## - `EGL_BAD_ALLOC` if allocation of ancillary buffers for `draw` or `read`
  ##   were delayed until `eglMakeCurrent` is called, and there are not enough
  ##   resources to allocate them.
  ## - `EGL_CONTEXT_LOST` if a power management event has occurred. The
  ##   application must destroy all contexts and reinitialise OpenGL ES state
  ##   and objects to continue rendering.


proc eglQueryContext*(display: EGLDisplay; context: EGLContext;
  attribute: EGLint; value: ptr EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Return EGL rendering context information.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## context
  ##   Specifies the EGL rendering context to query.
  ## attribute
  ##   Specifies the EGL rendering context attribute to be returned.
  ## value
  ##   Returns the requested value.
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise. `value` is not modified
  ##   when `EGL_FALSE` is returned.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_CONTEXT` if `context` is not an EGL rendering context.
  ## - `EGL_BAD_ATTRIBUTE` if `attribute` is not a valid context attribute.


proc eglQueryString*(display: EGLDisplay; name: EGLint): cstring
  {.cdecl, dynlib: dllname, importc.}
  ## Return a string describing an EGL display connection.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## name
  ##   Specifies a symbolic constant, one of `EGL_CLIENT_APIS`, `EGL_VENDOR`,
  ##   `EGL_VERSION`, or `EGL_EXTENSIONS`.
  ## result
  ##   `nil` is returned on failure.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_PARAMETER` if `name` is not an accepted value.


proc eglQuerySurface*(display: EGLDisplay; surface: EGLSurface;
  attribute: EGLint; value: ptr EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Return EGL surface information.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## surface
  ##   Specifies the EGL surface to query.
  ## attribute
  ##   Specifies the EGL surface attribute to be returned.
  ## value
  ##   Returns the requested value.
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise. `value` is not modified
  ##   when `EGL_FALSE` is returned.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_SURFACE` if `surface` is not an EGL surface.
  ## - `EGL_BAD_ATTRIBUTE` if `attribute` is not a valid surface attribute.


proc eglSwapBuffers*(display: EGLDisplay; surface: EGLSurface): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Post EGL surface color buffer to a native window.
  ##
  ## display
  ##   Specifies the EGL display connection.
  ## surface
  ##   Specifies the EGL drawing surface whose buffers are to be swapped.
  ## result
  ##   `EGL_FALSE` if swapping of the buffers fails, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.
  ## - `EGL_NOT_INITIALIZED` if `display` has not been initialized.
  ## - `EGL_BAD_SURFACE` if `surface` is not an EGL drawing surface.
  ## - `EGL_CONTEXT_LOST` if a power management event has occurred. The
  ##   application must destroy all contexts and reinitialise OpenGL ES state
  ##   and objects to continue rendering.


proc eglTerminate*(display: EGLDisplay): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Terminate an EGL display connection.
  ##
  ## display
  ##   Specifies the EGL display connection to terminate.
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_DISPLAY` if `display` is not an EGL display connection.


proc eglWaitGL*(): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Complete GL execution prior to subsequent native rendering calls.
  ##
  ## result
  ##   `EGL_FALSE` on failure, `EGL_TRUE` otherwise.
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_CURRENT_SURFACE` if the surface associated with the current
  ##   context has a native window or pixmap, and that window or pixmap is no
  ##   longer valid.


proc eglWaitNative*(engine: EGLint): EGLBoolean
  {.cdecl, dynlib: dllname, importc.}
  ## Complete native execution prior to subsequent GL rendering calls.
  ##
  ## engine
  ##   Specifies a particular marking engine to be waited on. Must be
  ##   `EGL_CORE_NATIVE_ENGINE`.
  ## result
  ##   `EGL_TRUE` on success, `EGL_FALSE` otherwise
  ##
  ## The following error codes may be generated:
  ## - `EGL_BAD_PARAMETER` if `engine` is not a recognized marking engine.
  ## - `EGL_BAD_CURRENT_SURFACE` if the surface associated with the current
  ##   context has a native window or pixmap, and that window or pixmap is no
  ##   longer valid.
