package halc;

import halc.Help;
import haxe.Template;

class HelpCommand extends Command {

	static var instance:HelpCommand;

	public function new() {
		super({
			name:'help',
			shortName:'h',
			usage:'Shows a list of commands or help for one command',
			action:function(c) {
				HelpPrinter.showAppHelp(c);
			},
		});
	}

	static public function getInstance() {
		if (HelpCommand.instance == null) {
			HelpCommand.instance = new HelpCommand();
		}

		return HelpCommand.instance;
	}
}

class VersionPrinter {

	static public function checkVersion(c:Context) {
		var show:Bool = c.globalArg('version');

		if (show) {
			VersionPrinter.printVersion(c);
			return true;
		}

		return false;
	}

	static public function printVersion(c:Context) {
		Sys.println(c.app.name + ' version ' + c.app.version);
	}
}

class HelpPrinter {

	static inline var APP_HELP_TEMPLATE =
"NAME:
   ::name:: - ::usage::

USAGE:
   ::name::::if (flags.length > 0):: [global options]::end:: command::if (flags.length > 0):: [command options]::end:: [arguments...]

VERSION:
   ::version::::if ((author.length+email.length)>0)::

AUTHOR: ::if (author.length > 0)::
   ::author::::if (email.length > 0):: - <::email::>::end::::else::
   ::email::::end::::end::

COMMANDS:
   ::foreach commands::::__current__.name::::if (__current__.shortName.length > 0)::, ::__current__.shortName::::end:: \t::__current__.usage::
   ::end::::if (flags.length > 0)::
GLOBAL OPTIONS:
   ::foreach flags::::__current__::
   ::end::::end::
";

	static inline var COMMAND_HELP_TEMPLATE =
"NAME:
   ::name:: - ::usage::

USAGE:
   command ::name::::if (flags.length > 0):: [command options]::end:: [arguments...]::if (description.length > 0)::

DESCRIPTION:
   ::description::::end::::if (flags.length > 0)::

OPTIONS:
   ::foreach flags::::__current__::
   ::end::::end::
";

	static public function checkHelp(c:Context):Bool {
		var show:Bool = c.globalArg('help');

		if (show) {
			HelpPrinter.showAppHelp(c);
			return true;
		}

		return false;
	}

	static public function showAppHelp(c:Context) {
		var tmpl = new Template(HelpPrinter.APP_HELP_TEMPLATE);
		var app = c.app;
		Sys.print(tmpl.execute({
			name: app.name,
			usage: app.usage,
			commands: app.commands,
			flags: app.flags,
			version: app.version,
			author: app.author,
			email: app.email,
		}));
	}

	static public function checkCommandHelp(c:Context, name:String):Bool {
		var show:Bool = c.arg('help');

		if (show) {
			HelpPrinter.showCommandHelp(c, name);
			return true;
		}

		return false;
	}

	static public function showCommandHelp(c:Context, name:String) {
		for (command in c.app.commands) {
			if (command.hasName(name)) {
				var tmpl = new Template(HelpPrinter.COMMAND_HELP_TEMPLATE);
				Sys.print(tmpl.execute({
					name: command.name,
					usage: command.usage,
					description: command.description,
					flags: command.flags,
				}));
				return;
			}
		}
	}
}
