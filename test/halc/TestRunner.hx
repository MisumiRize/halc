package halc;

import halc.FlagTest;

class TestRunner {

	public static function main() {
		var runner = new haxe.unit.TestRunner();
		runner.add(new AppTest());
		runner.add(new FlagTest());
		runner.add(new FlagSetTest());
		runner.add(new ContextTest());
		runner.run();
	}
}
