package halc;

class AppTest extends haxe.unit.TestCase {

	public function testRun() {
		var s = '';

		var app = new App('');
		app.action = function(c) {
			s = s + c.args()[0];
		}

		app.run(['foo']);
		app.run(['bar']);
		assertEquals(s, 'foobar');
	}

	public function testCommand() {
		var command = new Command('foo');
		var run = false;
		command.action = function(c) {
			run = true;
		};

		var app = new App('');
		app.action = function (c) {};
		app.appendCommand(command);

		app.run(['bar']);
		assertFalse(run);

		app.run(['foo']);
		assertTrue(run);
	}
}
