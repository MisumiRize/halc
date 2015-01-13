HALC (HAxe Lightweight Cli)
====

HALC is simple library for CLI development.

## Installation

```sh
$ haxelib install arguable
$ haxelib git halc https://github.com/MisumiRize/halc.git
```

## Usage

HALC is currently avaiable on cpp and neko.

```haxe
class Main {
	var app = new halc.App('myapp');
	app.action = function(c:halc.Context) {
		trace('Hello, world!');
	};
	app.run(Sys.args());
}
```

Write some Haxe code and build.

```sh
-lib arguable
-main Main
-neko myapp.n
```

```sh
$ neko myapp.n
```
