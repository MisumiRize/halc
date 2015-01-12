package halc;

import halc.Flag;
import halc.Help;

class Command {

	public var name:String;
	public var shortName:String = '';
	public var usage:String = '';
	public var action = function(c:Context):Void {};
	var flags = new Array<Flag<Dynamic>>();

	public function new(name:String) {
		this.name = name;
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
