; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string**, i64 }
%string = type { i8*, i64 }

define i32 @main(%array.string* %0) {
entry:
  %args = alloca %array.string*, align 8
  store %array.string* %0, %array.string** %args, align 8
  call void @stark_runtime_priv_mm_init()
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 4))
  %1 = bitcast i8* %alloc to [4 x i8]*
  %dataptr = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 0
  store i8 100, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 1
  store i8 100, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 2
  store i8 100, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 3
  store i8 100, i8* %dataptr3, align 1
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %2 = bitcast i8* %alloc4 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %2, i32 0, i32 1
  store i64 4, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %2, i32 0, i32 0
  %3 = bitcast [4 x i8]* %1 to i8*
  store i8* %3, i8** %stringdatainit, align 8
  %alloc5 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to [1 x %string*]*
  %elementptr = getelementptr inbounds [1 x %string*], [1 x %string*]* %4, i32 0, i32 0
  store %string* %2, %string** %elementptr, align 8
  %alloc6 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %5 = bitcast i8* %alloc6 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %5, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %5, i32 0, i32 0
  %6 = bitcast [1 x %string*]* %4 to %string**
  store %string** %6, %string*** %arrayeleminit, align 8
  %alloc7 = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 4))
  %7 = bitcast i8* %alloc7 to [4 x i8]*
  %dataptr8 = getelementptr inbounds [4 x i8], [4 x i8]* %7, i32 0, i32 0
  store i8 100, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [4 x i8], [4 x i8]* %7, i32 0, i32 1
  store i8 100, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [4 x i8], [4 x i8]* %7, i32 0, i32 2
  store i8 100, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [4 x i8], [4 x i8]* %7, i32 0, i32 3
  store i8 100, i8* %dataptr11, align 1
  %alloc12 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %8 = bitcast i8* %alloc12 to %string*
  %stringleninit13 = getelementptr inbounds %string, %string* %8, i32 0, i32 1
  store i64 4, i64* %stringleninit13, align 4
  %stringdatainit14 = getelementptr inbounds %string, %string* %8, i32 0, i32 0
  %9 = bitcast [4 x i8]* %7 to i8*
  store i8* %9, i8** %stringdatainit14, align 8
  %alloc15 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %10 = bitcast i8* %alloc15 to [1 x %string*]*
  %elementptr16 = getelementptr inbounds [1 x %string*], [1 x %string*]* %10, i32 0, i32 0
  store %string* %8, %string** %elementptr16, align 8
  %alloc17 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %11 = bitcast i8* %alloc17 to %array.string*
  %arrayleninit18 = getelementptr inbounds %array.string, %array.string* %11, i32 0, i32 1
  store i64 1, i64* %arrayleninit18, align 4
  %arrayeleminit19 = getelementptr inbounds %array.string, %array.string* %11, i32 0, i32 0
  %12 = bitcast [1 x %string*]* %10 to %string**
  store %string** %12, %string*** %arrayeleminit19, align 8
  %13 = bitcast %array.string* %5 to i8*
  %14 = bitcast %array.string* %11 to i8*
  %concat = call i8* @stark_runtime_priv_concat_array(i8* %13, i8* %14, i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %15 = bitcast i8* %concat to %array.string*
  ret i32 0
}

declare void @stark_runtime_priv_mm_init()

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare i8* @stark_runtime_priv_concat_array(i8*, i8*, i64)