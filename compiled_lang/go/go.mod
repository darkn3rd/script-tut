// A minimal module so `go build <file>.go` works reliably for every
// lesson in this directory regardless of the installed Go version's
// module-mode defaults - none of these lessons have external
// dependencies, so nothing else is needed here.
module scripttut/compiled_lang/go

go 1.21
