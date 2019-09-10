require_relative 'base_blocks'
require_relative 'runner'

SISYPHUS = <<-END

.....
.  2.
.  /.
.>>..

END

PRINTER = <<-END

$*Z
   
>>.

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
runner = Vocal::Runner.new(PRINTER, "test_prog", [1, 2, 3, 4], options)
runner.run