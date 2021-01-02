extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void



/*func toto(i: int): int {
    if (i < 3) {
        y: int = 0
        y = y + 1
        return y
    } else {
        return 0
    }
}
printi(toto(2))*/


// Recursive call if ko
func fib(x: int): int {
    if (x < 3) {
        return 1
    } else {
        return fib(x - 1) + fib(x - 2)
    }
}
assertIntEquals(fib(9), 34)

/*
func countdown(start: int): int {
    r: int = 0
    //printi(start)
    if (start == 0) {
        print("stop")
        return start
    } else {
        print("cont")
        r = countdown(start - 1)
        printi(r)
        return r
    }
}
s:int = 10
print("result")
s = countdown(s)
printi(s)*/

//-------------------------------------------------------------

// Crash when using var in if condition
/*x: int = 12
if(x != 2) {
    print("true")
} 
else {
    print("false")
}*/

// With variable IR = KO
/*
@true = constant [5 x i8] c"true\00"
@false = constant [6 x i8] c"false\00"

define internal void @main() {
entry:
  %x = alloca i64, align 8
  store i64 12, i64* %x, align 4
  %0 = load i64, i64* %x, align 4
  %1 = icmp sgt i64 %0, 2
  br i1 %1, label %if, label %else

if:                                               ; preds = %entry
  call void @print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @true, i32 0, i32 0))
  br label %ifcont

else:                                             ; preds = %entry
  call void @print(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @false, i32 0, i32 0))
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  %iftmp = phi void [ <badref>, %if ], [ <badref>, %else ]
  ret void
}
*/

//--------------------------------------------------------------------------------------------------------

// With constant IR = OK
/*
@true = constant [5 x i8] c"true\00"
@false = constant [6 x i8] c"false\00"

define internal void @main() {
entry:
  %x = alloca i64, align 8
  store i64 12, i64* %x, align 4
  br i1 true, label %if, label %else

if:                                               ; preds = %entry
  call void @print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @true, i32 0, i32 0))
  br label %ifcont

else:                                             ; preds = %entry
  call void @print(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @false, i32 0, i32 0))
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  %iftmp = phi void [ <badref>, %if ], [ <badref>, %else ]
  ret void
}
*/

//--------------------------------------------------------------------------------------------------------

// With variable but wihtout else block IR = OK
/*
@true = constant [5 x i8] c"true\00"

define internal void @main() {
entry:
  %x = alloca double, align 8
  store double 1.200000e+01, double* %x, align 8
  %0 = load double, double* %x, align 8
  %1 = fcmp one double %0, 2.000000e+00
  br i1 %1, label %if, label %ifcont

if:                                               ; preds = %entry
  call void @print(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @true, i32 0, i32 0))
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  %iftmp = phi void [ <badref>, %if ]
  ret void
}
*/