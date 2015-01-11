package halc;

import halc.Flag;
import halc.Help;

class App {

	public var name:String;
	public var usage = 'A new cli application';
	public var version = '0.0.0';
	public var commands = new Array<Command>();
	public var flags = new Array<Flag<Dynamic>>();
	public var action = HelpCommand.getInstance().action;
	public var author = 'Author';
	public var email = 'unknown@email';

	public function new(name:String) {
		this.name = name;
	}

	public function run(arguments:Array<String>) {

		var helpCommand = HelpCommand.getInstance();
		if (!hasCommand(helpCommand)) {
			commands.push(helpCommand);
			appendFlag(HelpFlag.getInstance());
		}

		appendFlag(VersionFlag.getInstance());

		var set = new FlagSet(flags);
		set.parse(arguments);
		var context = new Context(this, set, set);

		if (VersionPrinter.checkVersion(context)) {
			return;
		}

		if (HelpPrinter.checkHelp(context)) {
			return;
		}

		action(context);
	}

	function hasCommand(command:Command):Bool {
		var match = commands.filter(function(c) { return c.name == command.name; });
		return match.length != 0;
	}

	function hasFlag(flag:Flag<Dynamic>):Bool {
		var match = flags.filter(function(f) { return f.name == flag.name; });
		return match.length != 0;
	}

	function appendFlag(flag:Flag<Dynamic>) {
		if (!hasFlag(flag)) {
			flags.push(flag);
		}
	}
}
