; ModuleID = 'main'
source_filename = "main"

%string = type { i8*, i64 }

define void @stark.functions.main.printHello(%string* %msg1) {
entry:
  %msg = alloca %string*, align 8
  store %string zeroinitializer, %string** %msg, align 8
  store %string* %msg1, %string** %msg, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 6))
  %0 = bitcast i8* %alloc to [6 x i8]*
  %dataptr = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 0
  store i8 72, i8* %dataptr, align 1
  %dataptr2 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 1
  store i8 101, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 2
  store i8 108, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 3
  store i8 108, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 4
  store i8 111, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 5
  store i8 32, i8* %dataptr6, align 1
  %alloc7 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %1 = bitcast i8* %alloc7 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 6, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [6 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  call void @stark_runtime_pub_print(%string* %1)
  %load = load %string*, %string** %msg, align 8
  call void @stark_runtime_pub_println(%string* %load)
  ret void
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare void @stark_runtime_pub_print(%string*)

declare void @stark_runtime_pub_println(%string*)

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 4))
  %0 = bitcast i8* %alloc to [4 x i8]*
  %dataptr = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 0
  store i8 84, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 1
  store i8 111, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 2
  store i8 110, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 3
  store i8 121, i8* %dataptr3, align 1
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %1 = bitcast i8* %alloc4 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 4, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [4 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  call void @stark.functions.main.printHello(%string* %1)
  ret i64 0
}

declare void @stark_runtime_priv_mm_init()