package halc;

import halc.Flag;
import halc.Help;

typedef AppConfig = {
	name:String,
	?usage:String,
	?version:String,
	?commands:Array<Command>,
	?flags:Array<Flag<Dynamic>>,
	?action:Context -> Void,
	?author:String,
	?email:String,
};

class App {

	public var name(default, null):String;
	public var usage(default, null) = 'A new cli application';
	public var version(default, null) = '0.0.0';
	public var commands(default, null) = new Array<Command>();
	public var flags(default, null) = new Array<Flag<Dynamic>>();
	public var action(default, null) = HelpCommand.getInstance().action;
	public var author(default, null) = 'Author';
	public var email(default, null) = 'unknown@email';

	public function new(config:AppConfig) {
		name = config.name;
		usage = (config.usage != null) ? config.usage : usage;
		version = (config.version != null) ? config.version : version;
		commands = (config.commands != null) ? config.commands : commands;
		flags = (config.flags != null) ? config.flags : flags;
		action = (config.action != null) ? config.action : action;
		author = (config.author != null) ? config.author : author;
		email = (config.email != null) ? config.email : email;
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
