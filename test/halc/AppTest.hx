package halc;

class AppTest extends haxe.unit.TestCase {

	public function testRun() {
		var s = '';

		var app = new App({
			name:'',
			action:function(c) {
				s = s + c.args()[0];
			},
		});

		app.run(['foo']);
		app.run(['bar']);
		assertEquals(s, 'foobar');
	}

	public function testCommand() {
		var run = false;
		var command = new Command({
			name:'foo',
			usage:'',
			description:'',
			action:function(c) {
				run = true;
			},
		});

		var app = new App({
			name:'',
			action: function (c) {},
		});
		app.appendCommand(command);

		app.run(['bar']);
		assertFalse(run);

		app.run(['foo']);
		assertTrue(run);
	}
}
