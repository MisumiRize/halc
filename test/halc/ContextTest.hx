package halc;

import halc.Flag;

class ContextTest extends haxe.unit.TestCase {

	public function testArgInt() {
		var flags = [ new Flag<Int>('test', 12, '') ];
		var set = new FlagSet(flags);
		var context = new Context(null, set, set);
		var int:Int = context.arg('test');

		assertEquals(int, 12);
	}

	public function testArgString() {
		var flags = [ new Flag<String>('test', 'hello world', '') ];
		var set = new FlagSet(flags);
		var context = new Context(null, set, set);
		var string:String = context.arg('test');

		assertEquals(string, 'hello world');
	}

	public function testArgBool() {
		var flags = [ new Flag<Bool>('test', false, '') ];
		var set = new FlagSet(flags);
		var context = new Context(null, set, set);
		var bool:Bool = context.arg('test');

		assertFalse(bool);
	}

	public function testArgs() {
		var flags = [ new Flag<Bool>('test', false, '') ];
		var set = new FlagSet(flags);
		set.parse(['--test', 'bar', 'baz']);
		var context = new Context(null, set, set);

		assertEquals(context.args().length, 2);
	}

	public function testIsSet() {
		var flags:Array<Flag<Dynamic>> = [
			new Flag<Bool>('myflag', false, ''),
			new Flag<String>('otherflag', 'hello world', ''),
		];
		var set = new FlagSet(flags);
		set.parse(['--myflag', 'bar', 'baz']);
		var globalFlags = [
			new Flag<Bool>('myflagGlobal', true, ''),
		];
		var globalSet = new FlagSet(globalFlags);
		globalSet.parse(['--myflagGlobal', 'bar', 'baz']);
		var context = new Context(null, set, globalSet);

		assertTrue(context.isSet('myflag'));
		assertFalse(context.isSet('otherflag'));
		assertFalse(context.isSet('moreflag'));
		assertFalse(context.isSet('myflagGlobal'));
	}

	public function testGlobalIsSet() {
		var flags = [
			new Flag<Bool>('myflag', false, ''),
		];
		var set = new FlagSet(flags);
		set.parse(['--myflag', 'bar', 'baz']);
		var globalFlags:Array<Flag<Dynamic>> = [
			new Flag<Bool>('myflagGlobal', true, ''),
			new Flag<String>('otherflagGlobal', 'hello world', ''),
		];
		var globalSet = new FlagSet(globalFlags);
		globalSet.parse(['--myflagGlobal', 'bar', 'baz']);
		var context = new Context(null, set, globalSet);

		assertFalse(context.globalIsSet('myflag'));
		assertTrue(context.globalIsSet('myflagGlobal'));
		assertFalse(context.globalIsSet('otherflag'));
		assertFalse(context.globalIsSet('moreflag'));
	}
}
