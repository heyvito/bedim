# bedim
<p align="center">
<img alt="Platform" src="https://img.shields.io/badge/platform-macOS-yellow.svg?style=flat" />
<img alt="Language" src="https://img.shields.io/badge/language-ObjC-blue.svg?style=flat" />
<img alt="Version" src="https://img.shields.io/github/tag/victorgama/dropletkit.svg?color=green&style=flat" />
<img alt="License" src="https://img.shields.io/github/license/victorgama/bedim.svg?style=flat" />
</p>

Bedim is a small MenuBar app that blurs your wallpapers when an application is visible. When there's nothing else on the screen, your wallpaper is then restored.

* Current version: 1.0
* Requires: macOS 10.10 or higher

**Note**: the default `master` branch will always be stable.

## Install
* [Download Bedim](https://github.com/victorgama/bedim/releases/download/v1.0/Bedim.zip)
* Last version SHA256: `4f07abdb28ed8767b2ccdf197c4ae68a28f1fec6e3df23dad07fdd739be1969c`

To install, extract the downloaded archive and just drag-and-drop Bedim to your `Applications` folder. When you run Bedim for the first time, you will be asked to allow it to control your UI. macOS will ask you to open `Security & Privacy` in `System Preferences`. Once open, go to the `Accessibility` section and click the checkbox next to Bedim to enable control. An admin account is required to accomplish this.

### Why Bedim requires accessibility permissions?
Bedim uses the accessbility API to track windows and their locations across screens. Apple only allows the Accessbility API to get this kind of information.

## Uninstall
To remove Bedim, simply quit it using the MenuBar icon, and delete it from your `Applications` folder.

## Development

To hack on Bedim you will need to have a few tools installed on your system:

* Git
* Xcode & Xcode command line tools
* Carthage

Once everything is installed, clone this repository to your machine:

```
$ git clone https://github.com/victorgama/bedim.git
$ cd bedim
```

All tasks are executed through a `Makefile`.
Download required dependencies using Carthage:

```
$ make bootstrap
```

And open `Bedim.xcodeproj`.

### Release

Another task defined in the `Makefile`  is responsible for building and outputting a binary form into the `build` directory:

```
$ make release
```

## Contributing
Pull requests are always welcome. Also feel free to open issues.

## Contact
If you have any questions, feedback or just want to say hi, you can [open an issue](https://github.com/victorgama/bedim/issues/new), send an [email](mailto:hey@vito.io) or [tweet](https://twitter.com/heyvito).

## License
Bedim is released under the MIT License. See [license](LICENSE.md) for more information.
