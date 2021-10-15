; ModuleID = 'test'
source_filename = "test"

%Test = type { %string* }
%string = type { i8*, i64 }
%array.int = type { i64*, i64 }

define i64 @stark.functions.test.addTest(i64 %a1, i64 %b2) {
entry:
  %a = alloca i64, align 8
  store i64 0, i64* %a, align 4
  store i64 %a1, i64* %a, align 4
  %b = alloca i64, align 8
  store i64 0, i64* %b, align 4
  store i64 %b2, i64* %b, align 4
  %load = load i64, i64* %a, align 4
  %load3 = load i64, i64* %b, align 4
  %binop = add i64 %load, %load3
  ret i64 %binop
}

define %Test* @stark.functions.test.returnTest() {
entry:
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 14))
  %0 = bitcast i8* %alloc to [14 x i8]*
  %dataptr = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 0
  store i8 116, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 1
  store i8 104, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 2
  store i8 105, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 3
  store i8 115, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 4
  store i8 32, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 5
  store i8 105, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 6
  store i8 115, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 7
  store i8 32, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 8
  store i8 97, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 9
  store i8 32, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 10
  store i8 116, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 11
  store i8 101, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 12
  store i8 115, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [14 x i8], [14 x i8]* %0, i32 0, i32 13
  store i8 116, i8* %dataptr13, align 1
  %alloc14 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc14 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 14, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [14 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %call = call %Test* @stark.structs.test.Test.constructor(%string* %1)
  ret %Test* %call
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

define internal %Test* @stark.structs.test.Test.constructor(%string* %name) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Test*
  %structmemberinit = getelementptr inbounds %Test, %Test* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  ret %Test* %0
}

define void @stark.functions.test.empty() {
entry:
  ret void
}

define void @stark.functions.test.withNestedFunx() {
entry:
  %f1 = alloca void (i64)*, align 8
  store void (i64)* @stark.functions.test.stark.functions.test.mod.st.anon1, void (i64)** %f1, align 8
  %0 = load void (i64)*, void (i64)** %f1, align 8
  call void %0(i64 2)
  %f2 = alloca void (%array.int*)*, align 8
  store void (%array.int*)* @stark.functions.test.stark.functions.test.mod.st.anon2, void (%array.int*)** %f2, align 8
  ret void
}

define internal void @stark.functions.test.stark.functions.test.mod.st.anon1(i64 %a1) {
entry:
  %a = alloca i64, align 8
  store i64 0, i64* %a, align 4
  store i64 %a1, i64* %a, align 4
  %load = load i64, i64* %a, align 4
  %binop = mul i64 %load, 2
  %b = alloca i64, align 8
  store i64 %binop, i64* %b, align 4
  ret void
}

define internal void @stark.functions.test.stark.functions.test.mod.st.anon2(%array.int* %a1) {
entry:
  %a = alloca %array.int*, align 8
  store i64 0, %array.int** %a, align 4
  store %array.int* %a1, %array.int** %a, align 8
  %0 = load %array.int*, %array.int** %a, align 8
  %elementptrs = getelementptr inbounds %array.int, %array.int* %0, i32 0, i32 0
  %1 = load i64*, i64** %elementptrs, align 8
  %2 = getelementptr inbounds i64, i64* %1, i32 0
  %load = load i64, i64* %2, align 4
  %binop = mul i64 %load, 2
  %b = alloca i64, align 8
  store i64 %binop, i64* %b, align 4
  ret void
}

define void @stark.functions.test.sig(i64 ()* %c1) {
entry:
  %c = alloca i64 ()*, align 8
  store i64 ()* null, i64 ()** %c, align 8
  store i64 ()* %c1, i64 ()** %c, align 8
  ret void
}