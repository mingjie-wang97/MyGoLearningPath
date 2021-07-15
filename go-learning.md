# My Go Learning Path

## 1. Basic GO

### - Import Library

Group imports together for better coding style

``` go
import (
	"fmt"
	"math"
)
```

### - Exported Names

Name is exported if it begins with a **Capital Letter**

```go
func main() {
	fmt.Println(math.pi)
}
// cannot refer to unexported name math.pi

func main() {
	fmt.Println(math.Pi)
}
// 3.141592653589793
// working because 'Pi' begins with capital letter
```

### - Function

```go
// If function parameters share the same type, you can omit the type from all but the last
// This function is the SAME as 
func add(x int, y int) int {
	return x + y
}
func add(x, y int) int {
	return x + y
}

// Function can return anything as reult
func swap(x, y string) (string, string) {
	return y, x
}
func main() {
	a, b := swap("hello", "world")
	fmt.Println(a, b) // world hello
}

// Go's return values may be named. If so, they are treated as variables defined at the top of the function.
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
// This is the same as
func split(sum int) (int, int) {
	var x int = sum * 4 / 9
	var y int = sum - x
	return x, y
}
```

### - Variables

```go
// The `var` statement declares a list of variables; as in function argument lists, the type is last.
var c, python, java bool
func main() {
	var i int
	fmt.Println(i, c, python, java) // 0 false false false
}

// A var declaration can include initializers, one per variable.
// If an initializer is present, the type can be omitted; the variable will take the type of the initializer.
var i, j int = 1, 2
func main() {
	var c, python, java = true, false, "no!"
	fmt.Println(i, j, c, python, java) // 1 2 true false no!
  i = "test" // cannot use "test" (type untyped string) as type int in assignment
}

/*
Inside a function, the := short assignment statement can be used in place of a var declaration with implicit type.
Outside a function, every statement begins with a keyword (var, func, and so on) and so the := construct is not available.
*/
func main() {
	var i, j int = 1, 2
	k := 3
	c, python, java := true, false, "no!"
	fmt.Println(i, j, k, c, python, java) // 1 2 3 true false no!
 	i := 4 // no new variables on left side of :=
  {
		i := "test"
		fmt.Println(i) // test
    var k string = "testk"
		fmt.Println(k) // testk
	}
	fmt.Println(i) // 1
	fmt.Println(k) // 3
}
```

### - Basic Types

```go
bool -> false
string -> ""
// int -> signed integer (all int); uint -> unsigned integer (int >= 0)
int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr
byte // alias for uint8 -> 0
rune // alias for int32
     // represents a Unicode code point
float32 float64
complex64 complex128

// Default values for variables
func main() {
	var i int
	var f float64
	var b bool
	var s string
	fmt.Printf("%v %v %v %q\n", i, f, b, s) // 0 0 false ""
}
```

### - Type Conversions

Go assignment between items of different type requires an explicit conversion.

```go
func main() {
	var x, y int = 3, 4
	var f float64 = math.Sqrt(float64(x*x + y*y))
	var z uint = uint(f)
	fmt.Println(x, y, f, z) // 3 4 5 5
  f =  math.Sqrt(x*x + y*y) 
  // cannot use x * x + y * y (type int) as type float64 in argument to math.Sqrt
}

/*
When declaring a variable without specifying an explicit type (either by using the := syntax or var = expression syntax), the variable's type is inferred from the value on the right hand side.
*/
var i int
j := i // j is an int
// Numeric Type
i := 42           // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128

// Constants
const World = "世界"
fmt.Println("Hello", World)
World = "test" // cannot assign to World (declared const)

// Large OR Small Constants
const (
	// Create a huge number by shifting a 1 bit left 100 places.
	// In other words, the binary number that is 1 followed by 100 zeroes.
	Big = 1 << 100
	// Shift it right again 99 places, so we end up with 1<<1, or 2.
	Small = Big >> 99
)
func needInt(x int) int { return x*10 + 1 }
func needFloat(x float64) float64 {
	return x * 0.1
}
func main() {
	fmt.Println(needInt(Small)) // 21
	fmt.Println(needInt(Big)) // constant 1267650600228229401496703205376 overflows int
	fmt.Println(needFloat(Small)) // 0.2
	fmt.Println(needFloat(Big)) // 1.2676506002282295e+29
}
```

### - For Loop

```go
func main() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum) // 45
}

// The init and post statements are optional.
func main() {
	sum := 1
	for ; sum < 1000; {
		sum += sum
	}
	fmt.Println(sum) // 1024
}

// At that point you can drop the semicolons:
func main() {
	sum := 1
	for sum < 1000 {
		sum += sum
	}
	fmt.Println(sum) // 1024
}
```

### - If Statement

```go
func checkPositive(x int) bool {
  if x >= 0 {
    return true
  } else {
    return false
  }
}

// Like for, the if statement can start with a short statement to execute before the condition.
// can also use v in the else branch
func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
  fmt.Println(v) // undefined: v
	return lim
}
func main() {
	fmt.Println(
		pow(3, 2, 10), // 9
		pow(3, 3, 20), // 20
	)
}
```

### - Switch

Go's switch is like the one in C, C++, Java, JavaScript, and PHP, except that Go only runs the selected case, not all the cases that follow. 

**In effect, the `break` statement that is needed at the end of each case in those languages is provided automatically in Go.**

 Another important difference is that Go's switch cases need not be constants, and the values involved need not be integers.

Switch cases evaluate cases from top to bottom, **stopping when a case succeeds.**

**Switch without a condition is the same as `switch true`. This construct can be a clean way to write long if-then-else chains.**

``` go
func main() {
	t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
}
```

### - Defer

A defer statement defers the execution of a function until the surrounding function returns.

The deferred call's arguments are evaluated immediately, but the function call is not executed until the surrounding function returns.

```go
func main() {
	defer fmt.Println("world")

	fmt.Println("hello")
}
// hello
// world

/*
Deferred function calls are pushed onto a stack. When a function returns, its deferred calls are executed in last-in-first-out order.
*/
func main() {
	fmt.Println("counting")
	for i := 0; i < 3; i++ {
		defer fmt.Println(i)
	}
	fmt.Println("done")
}
/*
  counting
  done
  2
  1
  0
*/
```

### - Pointer

A pointer holds the memory address of a value.

The type `*T` is a pointer to a `T` value. Its zero value is `nil`.

```go
var p *int
```

The `&` operator generates a pointer to its operand.

```go
i := 42
p = &i
```

The `*` operator denotes the pointer's underlying value.

```go
fmt.Println(*p) // read i through the pointer p
*p = 21         // set i through the pointer p
```

### - Structs

A `struct` is a collection of fields.

```go
type Vertex struct {
	X int
	Y int
}

func main() {
	fmt.Println(Vertex{1, 2})
}

// we can also access struct field via a dot
v.X = 4
fmt.Println(v.X) // 4
```

### - Pointers to Struct

To access the field `X` of a struct when we have the struct pointer `p` we could write `(*p).X`. However, that notation is cumbersome, so the language permits us instead to write just `p.X`, without the explicit dereference.

```go
func main() {
	v := Vertex{1, 2}
	p := &v
	p.X = 5
  fmt.Println(v) // {5 2}
}
```

### - Struct Literals

A struct literal denotes a newly allocated struct value by listing the values of its fields.

You can list just a subset of fields by using the `Name:` syntax. (And the order of named fields is irrelevant.)

The special prefix `&` returns a pointer to the struct value.

```go
type Vertex struct {
	X, Y int
}

var (
	v1 = Vertex{1, 2}  // has type Vertex
	v2 = Vertex{X: 1}  // Y:0 is implicit
	v3 = Vertex{}      // X:0 and Y:0
	v4 = Vertex{Y: 5}      // X:0 and Y:5
	p  = &Vertex{1, 2} // has type *Vertex
)

func main() {
	fmt.Println(v1, p, v2, v3, v4) // {1 2} &{1 2} {1 0} {0 0} {0 5}
}
```

### - Array

