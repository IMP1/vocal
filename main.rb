require_relative 'base_blocks'
require_relative 'runner'


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
runner = Vocal::Runner.new(CODE, "test_prog", [], options)
runner.run