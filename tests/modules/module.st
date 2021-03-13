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
     return Test("this is a test")
 }