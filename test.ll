; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string**, i64 }
%string = type { i8*, i64 }
%Shop = type { i64, %string }

define i32 @main(%array.string* %0) {
entry:
  %args = alloca %array.string*, align 8
  store %array.string* %0, %array.string** %args, align 8
  call void @stark_runtime_priv_mm_init()
  ; s shop
  %s = alloca %Shop*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %1 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %1, i32 0, i32 0
  store i8 97, i8* %dataptr, align 1
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %2 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %2, i32 0, i32 1
  store i64 1, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %2, i32 0, i32 0
  %3 = bitcast [1 x i8]* %1 to i8*
  store i8* %3, i8** %stringdatainit, align 8
  %call = call %Shop* @stark.structs.main.Shop.constructor(i64 1, %string* %2)
  store %Shop* %call, %Shop** %s, align 8
  %alloc2 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %4 = bitcast i8* %alloc2 to [1 x i8]*
  %dataptr3 = getelementptr inbounds [1 x i8], [1 x i8]* %4, i32 0, i32 0
  store i8 98, i8* %dataptr3, align 1
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %5 = bitcast i8* %alloc4 to %string*
  %stringleninit5 = getelementptr inbounds %string, %string* %5, i32 0, i32 1
  store i64 1, i64* %stringleninit5, align 4
  %stringdatainit6 = getelementptr inbounds %string, %string* %5, i32 0, i32 0
  %6 = bitcast [1 x i8]* %4 to i8*
  store i8* %6, i8** %stringdatainit6, align 8
  ;g
  %g = alloca %string*, align 8
  store %string* %5, %string** %g, align 8
  
  ; h expr
  %7 = load %Shop*, %Shop** %s, align 8
  %memberptr = getelementptr inbounds %Shop, %Shop* %7, i32 0, i32 1
  %load = load %string, %string* %memberptr, align 8
  ;h >>> error  should alloc a %string*
  %h = alloca %string, align 8
  store %string %load, %string* %h, align 8
  
  ret i32 0
}

declare void @stark_runtime_priv_mm_init()

declare i8* @stark_runtime_priv_mm_alloc(i64)

define %Shop* @stark.structs.main.Shop.constructor(i64 %id, %string* %name) {
entry:
  %id1 = alloca i64, align 8
  store i64 %id, i64* %id1, align 4
  %name2 = alloca %string*, align 8
  store %string* %name, %string** %name2, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %0 = bitcast i8* %alloc to %Shop*
  %structmemberinit = getelementptr inbounds %Shop, %Shop* %0, i32 0, i32 0
  %1 = load i64, i64* %id1, align 4
  store i64 %1, i64* %structmemberinit, align 4
  %structmemberinit3 = getelementptr inbounds %Shop, %Shop* %0, i32 0, i32 1
  %2 = load %string*, %string** %name2, align 8
  store %string* %2, %string* %structmemberinit3, align 8
  ret %Shop* %0
}