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

		var args = context.args();
		if (args.length > 0) {
			var c = getCommand(args[0]);
			if (c != null) {
				c.run(context);
				return;
			}
		}

		action(context);
	}

	public function appendCommand(command:Command):App {
		if (!hasCommand(command)) {
			commands.push(command);
		}

		return this;
	}

	public function appendFlag(flag:Flag<Dynamic>):App {
		if (!hasFlag(flag)) {
			flags.push(flag);
		}

		return this;
	}

	function getCommand(name:String):Command {
		for (c in commands) {
			if (c.hasName(name)) {
				return c;
			}
		}

		return null;
	}

	function hasCommand(command:Command):Bool {
		for (c in commands) {
			if (c.hasName(command.name)) {
				return true;
			}
		}

		return false;
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
