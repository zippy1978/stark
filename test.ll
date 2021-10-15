; ModuleID = 'main'
source_filename = "main"

%array.string = type { %string**, i64 }
%string = type { i8*, i64 }

define i32 @main(%array.string* %0) {
entry:
  %args = alloca %array.string*, align 8
  store %array.string* %0, %array.string** %args, align 8
  call void @stark_runtime_priv_mm_init()
  %test = alloca void ()*, align 8
  store void ()* null, void ()** %test, align 8
  store void ()* null, void ()** %test, align 8
  %load = load void ()*, void ()** %test, align 8
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 12))
  %1 = bitcast i8* %alloc to [12 x i8]*
  %dataptr = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 0
  store i8 116, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 1
  store i8 101, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 2
  store i8 115, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 3
  store i8 116, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 4
  store i8 32, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 5
  store i8 105, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 6
  store i8 115, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 7
  store i8 32, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 8
  store i8 110, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 9
  store i8 117, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 10
  store i8 108, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [12 x i8], [12 x i8]* %1, i32 0, i32 11
  store i8 108, i8* %dataptr11, align 1
  %alloc12 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %2 = bitcast i8* %alloc12 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %2, i32 0, i32 1
  store i64 12, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %2, i32 0, i32 0
  %3 = bitcast [12 x i8]* %1 to i8*
  store i8* %3, i8** %stringdatainit, align 8
  call void @stark_runtime_pub_println(%string* %2)
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  ret i32 0
}

declare void @stark_runtime_priv_mm_init()

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare void @stark_runtime_pub_println(%string*)