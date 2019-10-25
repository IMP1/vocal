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

GATED = <<-END

      0
..$...Y...Z.
.          .
.>>>>>>>>>>.

END

options = {
    delay: 0.2,
    trace: true,
}
runner = Vocal::Runner.new(GATED, "test_prog", [0, nil, 0, 1, 0, nil, 4, nil, 0], options)
runner.run