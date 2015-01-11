package halc;

class Command {

	public var name:String;
	var shortName:String;
	var usage:String;
	public var action:Context -> Void;
}
