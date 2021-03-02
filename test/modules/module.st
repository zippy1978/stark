/**
 * Test module.
 * Used for import testing.
 */
 module test

// A struct
 struct Test {
     name: string
 }

// A function
 func addTest(a: int, b: int): int {
     return a + b
 }

 // A funtion returning a Test type
 func returnTest(): Test {
     t: Test
     t.name = "this is a test"
     return t
 }