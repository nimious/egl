## *egl* - Nim bindings for EGL, the native platform interface for rendering
## APIs.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.

import egl, windows


type
  NativeWindow* = object
    context*: EGLContext
    display*: EGLDisplay
    nativeDisplay*: EGLNativeDisplayType
    nativeWindow*: EGLNativeWindowType
    surface*: EGLSurface


when defined(windows):
  proc windowProc(hWnd: HWND, uMsg: WINUINT, wParam: WPARAM, lParam: LPARAM):
    LRESULT {.stdcall.} =
    result = 1

    case uMsg
    of WM_CREATE:
      discard
    of WM_PAINT:
      let window = cast[ptr NativeWindow](GetWindowLongPtr(hWnd, GWL_USERDATA))
      discard eglSwapBuffers(window.display, window.surface)
      discard ValidateRect(window.nativeWindow, nil)
    of WM_DESTROY:
      PostQuitMessage(0)
    else:
      result = DefWindowProc(hWnd, uMsg, wParam, lParam)


  proc createNativeWindow*(window: ptr NativeWindow; width, height: int): bool =
    var hInstance: HINST
    var wndclass = WNDCLASS(
        style: CS_OWNDC,
        lpfnWndProc: windowProc,
        hInstance: hInstance,
        hbrBackground: cast[HBRUSH](GetStockObject(BLACK_BRUSH)),
        lpszClassName: "egl")

    if RegisterClass(addr wndclass) != 0:
      let style = WS_VISIBLE or WS_POPUP or WS_BORDER or WS_SYSMENU or WS_CAPTION
      var rect = RECT(
        TopLeft: POINT(x: 0, y: 0),
        BottomRight: POINT(x: (LONG)width, y: (LONG)height))

      discard AdjustWindowRect(addr rect, style, 0)

      window.nativeWindow = CreateWindow(
        "egl",
        "egl Example",
        style,
        0,
        0,
        (int32)width,
        (int32)height,
        0,
        0,
        hInstance,
        nil)

      discard SetWindowLongPtr(window.nativeWindow, GWL_USERDATA, cast[LONG](window))

    if window.nativeWindow == 0:
      result = false
    else:
      discard ShowWindow(window.nativeWindow, 1)
      result = true
