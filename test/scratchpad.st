extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void


// Works with 2 if !
/*func fib(x: int): int {
    printi(x)
    if (x < 3) {
        return 1
    } 
    if (x >=3) {
        print("rec")
        return 0
        //return fib(x - 1) + fib(x - 2)
    }
}
printi(fib(2))*/


// But not with if/else
/*func fib(x: int): int {
    printi(x)
    if (x < 3) {
        return 1
    } else {
        print("rec")
        return 0
        //return fib(x - 1) + fib(x - 2)
    }
}
printi(fib(2))*/


/*y: double = 1.0
printi(y == 2.0)*/


// Crash when using var in if condition
x: double = 12.0
if(x != 2.0) {
    print("true")
} 
else {
    print("false")
}

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