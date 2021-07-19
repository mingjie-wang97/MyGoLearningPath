module example.com/hello

go 1.16

require (
	mingjie.com/greetings v0.0.0-00010101000000-000000000000
	rsc.io/quote v1.5.2
)

replace mingjie.com/greetings => ../greetings
