; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string**, i64 }
%string = type { i8*, i64 }
%Hello = type { %string* }

define i32 @main(%array.string* %0) {
entry:
  %args = alloca %array.string*, align 8
  store %array.string* %0, %array.string** %args, align 8
  call void @stark_runtime_priv_mm_init()
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 6))
  %1 = bitcast i8* %alloc to [6 x i8]*
  %dataptr = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 0
  store i8 115, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 1
  store i8 116, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 2
  store i8 114, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 3
  store i8 105, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 4
  store i8 110, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i32 0, i32 5
  store i8 103, i8* %dataptr5, align 1
  %alloc6 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %2 = bitcast i8* %alloc6 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %2, i32 0, i32 1
  store i64 6, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %2, i32 0, i32 0
  %3 = bitcast [6 x i8]* %1 to i8*
  store i8* %3, i8** %stringdatainit, align 8
  %alloc7 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %4 = bitcast i8* %alloc7 to [1 x %string*]*
  %elementptr = getelementptr inbounds [1 x %string*], [1 x %string*]* %4, i32 0, i32 0
  store %string* %2, %string** %elementptr, align 8
  %alloc8 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %5 = bitcast i8* %alloc8 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %5, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %5, i32 0, i32 0
  %6 = bitcast [1 x %string*]* %4 to %string**
  store %string** %6, %string*** %arrayeleminit, align 8
  %arr = alloca %array.string*, align 8
  store %array.string* %5, %array.string** %arr, align 8
  %7 = load %array.string*, %array.string** %arr, align 8
  %elementptrs = getelementptr inbounds %array.string, %array.string* %7, i32 0, i32 0
  %8 = load %string**, %string*** %elementptrs, align 8
  %9 = getelementptr inbounds %string*, %string** %8, i32 0
  %load = load %string*, %string** %9, align 8
  call void @stark_runtime_pub_println(%string* %load)
  ret i32 0
}

declare void @stark_runtime_priv_mm_init()

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare void @stark_runtime_pub_println(%string*)

define %array.string* @stark.functions.main.test() {
entry:
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 3))
  %0 = bitcast i8* %alloc to [3 x i8]*
  %dataptr = getelementptr inbounds [3 x i8], [3 x i8]* %0, i32 0, i32 0
  store i8 100, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [3 x i8], [3 x i8]* %0, i32 0, i32 1
  store i8 100, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [3 x i8], [3 x i8]* %0, i32 0, i32 2
  store i8 100, i8* %dataptr2, align 1
  %alloc3 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc3 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 3, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [3 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %3 = bitcast i8* %alloc4 to [1 x %string*]*
  %elementptr = getelementptr inbounds [1 x %string*], [1 x %string*]* %3, i32 0, i32 0
  store %string* %1, %string** %elementptr, align 8
  %alloc5 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %4, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %4, i32 0, i32 0
  %5 = bitcast [1 x %string*]* %3 to %string**
  store %string** %5, %string*** %arrayeleminit, align 8
  ret %array.string* %4
}

define %Hello* @stark.functions.main.test2() {
entry:
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 6))
  %0 = bitcast i8* %alloc to [6 x i8]*
  %dataptr = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 0
  store i8 103, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 1
  store i8 105, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 2
  store i8 108, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 3
  store i8 108, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 4
  store i8 101, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [6 x i8], [6 x i8]* %0, i32 0, i32 5
  store i8 115, i8* %dataptr5, align 1
  %alloc6 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc6 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 6, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [6 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %call = call %Hello* @stark.structs.main.Hello.constructor(%string* %1)
  ret %Hello* %call
}

define internal %Hello* @stark.structs.main.Hello.constructor(%string* %name) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Hello*
  %structmemberinit = getelementptr inbounds %Hello, %Hello* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  ret %Hello* %0
}