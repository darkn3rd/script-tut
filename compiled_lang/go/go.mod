// A minimal module so `go build <file>.go` works reliably for every
// lesson in this directory regardless of the installed Go version's
// module-mode defaults - none of these lessons have external
// dependencies, so nothing else is needed here.
//
// 1.23, not 1.21: f03.loop.go uses a range-over-func iterator (the
//  "iter" package, added in 1.23) and f13.loop.go uses range-over-int
//  (added in 1.22) - both are gated by this directive, not just by the
//  installed toolchain version.
module scripttut/compiled_lang/go

go 1.23
