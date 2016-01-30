# egl

Nim bindings for EGL, the native platform interface for rendering APIs.

![egl Logo](docs/logo.png)


## About

This project contains bindings to *Khronos EGL* for the [Nim](http://nim-lang.org)
programming language. EGL is an interface between Khronos rendering APIs such as
*OpenGL ES* or *OpenVG* and the underlying native platform window system.


## Supported Platforms

- ~~Android~~
- ~~FreeBSD~~
- ~~iOS~~
- ~~Linux~~
- ~~OpenBSD~~
- ~~MacOS X~~
- Windows


## Prerequisites

### Windows

The latest versions of Windows do not include support for OpenGL ES out of the
box, and an emulator needs to be installed. We have tested this package with the
*ARM MALI OpenGL ES Emulator* (see link below). Other emulators may work as well.


## Dependencies

This project depends on [nim-lang/x11](https://github.com/nim-lang/x11) for
FreeBSD, Linux, OpenBSD and Unix variants. It can be acquired via *nimble*, i.e.

```nimble install x11```


## Usage

Import the *egl* module from this package to make the bindings available in your
project:

```nimrod
import egl
```


## Support

Please [file an issue](https://github.com/nimious/egl/issues), submit a
[pull request](https://github.com/nimious/egl/pulls?q=is%3Aopen+is%3Apr)
or email us at info@nimio.us if this package is out of date or contains bugs.


## References

* [ARM MALI OpenGL ES Emulator for Windows](http://malideveloper.arm.com/develop-for-mali/tools/software-tools/opengl-es-emulator/)
* [Khronos EGL Homepage](https://www.khronos.org/egl/)
* [Khronos EGL Registry](https://www.khronos.org/registry/egl/)
* [Nim Programming Language](http://nim-lang.org/)
