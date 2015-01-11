package halc;

import halc.Flag;

typedef Test<T> = {
	var name:String;
	var value:T;
	var expected:String;
};

class FlagTest extends haxe.unit.TestCase {

	public function testBoolFlagHelpOutput() {
		var boolFlagTests:Array<Test<Bool>> = [
			{name: 'help', value: false, expected: '--help \t'},
			{name: 'h', value: false, expected: '-h \t'},
		];

		for (test in boolFlagTests) {
			var flag = new Flag<Bool>(test.name, test.value, '');
			var output = flag.toString();

			assertEquals(output, test.expected);
		}
	}

	public function testStringHelpOutput() {
		var stringFlagTests:Array<Test<String>> = [
			{name: 'help', value: '', expected: '--help \t'},
			{name: 'h', value: '', expected: '-h \t'},
			{name: 'test', value: 'Something', expected: "--test 'Something'\t"},
		];

		for (test in stringFlagTests) {
			var flag = new Flag<String>(test.name, test.value, '');
			var output = flag.toString();

			assertEquals(output, test.expected);
		}
	}

	public function testIntFlagHelpOutput() {
		var flag = new Flag<Int>('help', 0, '');
		var output = flag.toString();

		assertEquals(output, "--help '0'\t");
	}

	public function testFloatFlagHelpOutput() {
		var flag = new Flag<Float>('help', 0, '');
		var output = flag.toString();

		assertEquals(output, "--help '0'\t");
	}
}

class FlagSetTest extends haxe.unit.TestCase {

	public function testParseMultiString() {
		var flags:Array<Flag<Dynamic>> = [
			new Flag<String>('serve, s', '', ''),
		];
		var set = new FlagSet(flags);
		set.parse(['-s', '10']);

		assertEquals(set.value('serve'), '10');
		assertEquals(set.value('s'), '10');
	}
}
