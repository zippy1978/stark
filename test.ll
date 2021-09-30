; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string**, i64 }
%string = type { i8*, i64 }

define i32 @main(%array.string* %0) {
entry:
  %args = alloca %array.string*, align 8
  store %array.string* %0, %array.string** %args, align 8
  call void @stark_runtime_priv_mm_init()
  %ggtest = alloca void ()*, align 8
  store void ()* null, void ()** %ggtest, align 8
  store void ()* @stark.functions.main.gg, void ()** %ggtest, align 8
  call void %ggtest()
  ret i32 0
}

declare void @stark_runtime_priv_mm_init()

define void @stark.functions.main.gg() {
entry:
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 2))
  %0 = bitcast i8* %alloc to [2 x i8]*
  %dataptr = getelementptr inbounds [2 x i8], [2 x i8]* %0, i32 0, i32 0
  store i8 111, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [2 x i8], [2 x i8]* %0, i32 0, i32 1
  store i8 107, i8* %dataptr1, align 1
  %alloc2 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc2 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 2, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [2 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  call void @stark_runtime_pub_println(%string* %1)
  ret void
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare void @stark_runtime_pub_println(%string*)