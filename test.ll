; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string*, i64 }
%string = type { i8*, i64 }

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  %t = alloca %array.string*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 97, i8* %dataptr, align 1
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 1, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %alloc2 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %3 = bitcast i8* %alloc2 to [1 x %string*]*
  %elementptr = getelementptr inbounds [1 x %string*], [1 x %string*]* %3, i32 0, i32 0
  store %string* %1, %string** %elementptr, align 8
  %alloc3 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %4 = bitcast i8* %alloc3 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %4, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %4, i32 0, i32 0
  %5 = bitcast [1 x %string*]* %3 to %string**
  ; error
  store %string** %5, %string** %arrayeleminit, align 8
  store %array.string* %4, %array.string** %t, align 8
  %s = alloca %string*, align 8
  %6 = load %array.string*, %array.string** %t, align 8
  %elementptrs = getelementptr inbounds %array.string, %array.string* %6, i32 0, i32 0
  %7 = load %string*, %string** %elementptrs, align 8
  %8 = getelementptr inbounds %string, %string* %7, i32 0
  %load = load %string, %string* %8, align 8
  store %string %load, %string** %s, align 8
  ret i64 0
}

declare void @stark_runtime_priv_mm_init()

declare i8* @stark_runtime_priv_mm_alloc(i64)