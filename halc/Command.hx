package halc;

import halc.Flag;
import halc.Help;

typedef CommandConfig = {
	name:String,
	?shortName:String,
	usage:String,
	?description:String,
	action:Context -> Void,
	?flags:Array<Flag<Dynamic>>,
}

class Command {

	public var name(default, null):String;
	public var shortName(default, null) = '';
	public var usage(default, null):String;
	public var description(default, null) = '';
	public var action(default, null):Context -> Void;
	public var flags(default, null) = new Array<Flag<Dynamic>>();

	public function new(config:CommandConfig) {
		name = config.name;
		shortName = (config.shortName != null) ? config.shortName : shortName;
		usage = config.usage;
		description = (config.description != null) ? config.description : description;
		action = config.action;
		flags = (config.flags != null) ? config.flags : flags;
	}

	public function run(context:Context) {
		appendFlag(HelpFlag.getInstance());

		var set = new FlagSet(flags);

		var firstFlagIndex = -1;
		var args = context.args();
		var length = args.length;
		for (index in 0...length) {
			if (args[index].charAt(0) == '-') {
				firstFlagIndex = index;
				break;
			}
		}

		if (firstFlagIndex > -1) {
			var regularArgs = args.slice(1, firstFlagIndex);
			var flagArgs = args.slice(firstFlagIndex);
			set.parse(flagArgs.concat(regularArgs));
		} else {
			set.parse(args.slice(1));
		}

		var c = new Context(context.app, set, context.globalFlagSet);

		if (HelpPrinter.checkCommandHelp(c, name)) {
			return;
		}

		action(c);
	}

	public function hasName(name:String):Bool {
		return this.name == name || shortName == name;
	}

	public function appendFlag(flag:Flag<Dynamic>):Command {
		if (!hasFlag(flag)) {
			flags.push(flag);
		}

		return this;
	}

	function hasFlag(flag:Flag<Dynamic>):Bool {
		for (f in flags) {
			if (f.name == flag.name) {
				return true;
			}
		}

		return false;
	}
}
