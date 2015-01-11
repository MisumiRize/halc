package halc;

import arguable.ArgParser;

class Flag<T> {
	public var name:String;
	public var value:T;
	var usage:String;

	public function new(name:String, value:T, usage:String) {
		this.name = name;
		this.value = value;
		this.usage = usage;
	}

	public function toString() {
		var v = '';
		switch (Type.typeof(value)) {
			case TBool:
				v = '';
			case TClass(String):
				var valueString = Std.string(value);
				v = (valueString.length > 0) ? "'" + value + "'" : '';
			default:
				v = "'" + Std.string(value) + "'";
		}
		
		return getOutputName() + ' ' + v + '\t' + usage;
	}

	public function isBoolFlag():Bool {
		return Type.typeof(value) == TBool;
	}

	public function getNames():Array<String> {
		return name
			.split(',')
			.map(function(key) { return StringTools.trim(key); });
	}

	public static function prependPrefix(name:String) {
		var trimmed = StringTools.trim(name);
		return (trimmed.length == 1) ? trimmed : '-' + trimmed;
	}

	function getOutputName() {
		return name
			.split(',')
			.map(function(key) { return '-' + Flag.prependPrefix(key); })
			.join(', ');
	}
}

class HelpFlag extends Flag<Bool> {

	static var instance;

	public function new() {
		super('help, h', false, 'show help');
	}

	static public function getInstance() {
		if (HelpFlag.instance == null) {
			HelpFlag.instance = new HelpFlag();
		}
		return HelpFlag.instance;
	}
}

class VersionFlag extends Flag<Bool> {

	static var instance;

	public function new() {
		super('version, v', false, 'print the version');
	}

	static public function getInstance() {
		if (VersionFlag.instance == null) {
			VersionFlag.instance = new VersionFlag();
		}
		return VersionFlag.instance;
	}
}

abstract FlagValue(String) from String to String {

	public function new(value:String) {
		this = value;
	}

	@:to
	public function toInt():Int {
		var value = Std.parseInt(this);
		return (value != null) ? value : 0;
	}

	@:to
	public function toFloat():Float {
		return Std.parseFloat(this);
	}

	@:to
	public function toBool():Bool {
		switch (this) {
			case '1', 't', 'true', 'True', 'TRUE':
				return true;
			case '0', 'f', 'false', 'False', 'FALSE':
				return false;
			default:
				return false;
		}
	}
}

class FlagSet {

	var internal = new Map<String, Flag<Dynamic>>();
	var argValues:ArgValues;

	public function new(flags:Array<Flag<Dynamic>>) {
		apply(flags);
	}

	public function parse(args:Array<String>) {
		var filled = [];
		for (arg in args) {
			filled.push(arg);

			if (arg.charAt(0) == '-') {
				var flag = internal.get(arg.substring(1));

				if (flag != null && flag.isBoolFlag()) {
					filled.push('');
				}
			}
		}

		ArgParser.delimeter = '-';
		argValues = ArgParser.parse(filled);
	}

	public function value(name:String):FlagValue {
		var flag = getFlag(name);
		if (flag == null) {
			return '';
		}

		var arg:Null<Arg> = lookupArg(name);
		if (arg == null) {
			return Std.string(flag.value);
		}

		if (arg.value == '' && flag.isBoolFlag()) {
			return Std.string(true);
		}

		return arg.value;
	}

	public function lookupArg(name:String):Null<Arg> {
		if (argValues == null) {
			return null;
		}

		var flag = getFlag(name);
		if (flag == null) {
			return null;
		}

		var keys = flag.getNames();
		var arg:Null<Arg> = null;
		for (key in keys) {
			arg = getArg(key);
			if (arg != null) {
				break;
			}
		}

		return arg;
	}

	public function args():Array<String> {
		return argValues.invalid.map(function(arg) { return arg.name; });
	}

	function apply(flags:Array<Flag<Dynamic>>) {
		for (flag in flags) {
			var keys = flag.name.split(',');
			for (key in keys) {
				internal.set(Flag.prependPrefix(key), flag);
			}
		}
	}

	function getFlag(name:String):Null<Flag<Dynamic>> {
		var flagName = Flag.prependPrefix(name);
		return internal.get(flagName);
	}

	function getArg(name:String):Null<Arg> {
		var argName = Flag.prependPrefix(name);
		return argValues.get(argName);
	}
}
