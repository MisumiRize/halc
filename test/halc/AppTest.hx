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
}
