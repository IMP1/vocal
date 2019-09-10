require_relative 'base_blocks'
require_relative 'runner'

SISYPHUS = <<-END

.....
.  2.
.  /.
.>>..

END

CODE = <<-END

.@.........
.3.........
.£.........
.   .......
.ι   ......
..ι   ...Z.
...ι  +*  .
....ι    /.
.....>.>>..

END

options = {
    delay: 0.2,
    trace: true,
}
runner = Vocal::Runner.new(SISYPHUS, "test_prog", [], options)
runner.run