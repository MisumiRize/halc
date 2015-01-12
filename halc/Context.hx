package halc;

import halc.Flag;

class Context {

	public var app:App;
	public var flagSet:FlagSet;
	public var globalFlagSet:FlagSet;

	public function new(app:App, flagSet:FlagSet, globalFlagSet:FlagSet) {
		this.app = app;
		this.flagSet = flagSet;
		this.globalFlagSet = globalFlagSet;
	}

	public function arg(name:String):FlagValue {
		return flagSet.value(name);
	}

	public function args():Array<String> {
		return flagSet.args;
	}

	public function isSet(name:String):Bool {
		return flagSet.lookupArg(name) != null;
	}

	public function globalArg(name:String):FlagValue {
		return globalFlagSet.value(name);
	}

	public function globalIsSet(name:String):Bool {
		return globalFlagSet.lookupArg(name) != null;
	}
}
