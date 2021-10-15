; ModuleID = 'mod'
source_filename = "mod"

define i64 @stark.functions.mod.test(i64 ()* %c1) {
entry:
  %c = alloca i64 ()*, align 8
  store i64 ()** null, i64 ()** %c, align 8
  store i64 ()* %c1, i64 ()** %c, align 8
  ret i64 378
}