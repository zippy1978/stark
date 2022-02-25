; ModuleID = 'main'
source_filename = "main"

%fs.FileResult = type { %fs.File*, %string* }
%fs.File = type { i8*, %string* }
%string = type { i8*, i64 }
%http.HttpResult = type { %string* }
%json.JSONResult = type { %json.JSONValue*, %string* }
%json.JSONValue = type { %string*, %string*, i64, double, i1, %array.json.JSONValue*, %array.json.JSONProperty* }
%array.json.JSONValue = type { %json.JSONValue**, i64 }
%array.json.JSONProperty = type { %json.JSONProperty**, i64 }
%json.JSONProperty = type { %string*, %json.JSONValue* }
%array.int = type { i64*, i64 }
%FileResult = type { %File*, %string* }
%File = type { i8*, %string* }
%HttpResult = type { %string* }
%JSONResult = type { %JSONValue*, %string* }
%JSONValue = type { %string*, %string*, i64, double, i1, %array.JSONValue*, %array.JSONProperty* }
%array.JSONValue = type { %JSONValue**, i64 }
%array.JSONProperty = type { %JSONProperty**, i64 }
%JSONProperty = type { %string*, %JSONValue* }
%array.string = type { %string**, i64 }

define void @stark.functions.main.handleFileError(%fs.FileResult* %fr1) {
entry:
  %fr = alloca %fs.FileResult*, align 8
  store %fs.FileResult* null, %fs.FileResult** %fr, align 8
  store %fs.FileResult* %fr1, %fs.FileResult** %fr, align 8
  %0 = load %fs.FileResult*, %fs.FileResult** %fr, align 8
  %memberptr = getelementptr inbounds %fs.FileResult, %fs.FileResult* %0, i32 0, i32 1
  %load = load %string*, %string** %memberptr, align 8
  %1 = ptrtoint %string* %load to i64
  %cmp = icmp ne i64 %1, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %2 = load %fs.FileResult*, %fs.FileResult** %fr, align 8
  %memberptr2 = getelementptr inbounds %fs.FileResult, %fs.FileResult* %2, i32 0, i32 1
  %load3 = load %string*, %string** %memberptr2, align 8
  call void @stark_runtime_pub_println(%string* %load3)
  call void @exit(i64 1)
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  ret void
}

declare void @stark_runtime_pub_println(%string*)

declare void @exit(i64)

define void @stark.functions.main.handleHttpError(%http.HttpResult* %hr1) {
entry:
  %hr = alloca %http.HttpResult*, align 8
  store %http.HttpResult* null, %http.HttpResult** %hr, align 8
  store %http.HttpResult* %hr1, %http.HttpResult** %hr, align 8
  %0 = load %http.HttpResult*, %http.HttpResult** %hr, align 8
  %memberptr = getelementptr inbounds %http.HttpResult, %http.HttpResult* %0, i32 0, i32 0
  %load = load %string*, %string** %memberptr, align 8
  %1 = ptrtoint %string* %load to i64
  %cmp = icmp ne i64 %1, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %2 = load %http.HttpResult*, %http.HttpResult** %hr, align 8
  %memberptr2 = getelementptr inbounds %http.HttpResult, %http.HttpResult* %2, i32 0, i32 0
  %load3 = load %string*, %string** %memberptr2, align 8
  call void @stark_runtime_pub_println(%string* %load3)
  call void @exit(i64 1)
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  ret void
}

define void @stark.functions.main.handleJSONError(%json.JSONResult* %jr1) {
entry:
  %jr = alloca %json.JSONResult*, align 8
  store %json.JSONResult* null, %json.JSONResult** %jr, align 8
  store %json.JSONResult* %jr1, %json.JSONResult** %jr, align 8
  %0 = load %json.JSONResult*, %json.JSONResult** %jr, align 8
  %memberptr = getelementptr inbounds %json.JSONResult, %json.JSONResult* %0, i32 0, i32 1
  %load = load %string*, %string** %memberptr, align 8
  %1 = ptrtoint %string* %load to i64
  %cmp = icmp ne i64 %1, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %2 = load %json.JSONResult*, %json.JSONResult** %jr, align 8
  %memberptr2 = getelementptr inbounds %json.JSONResult, %json.JSONResult* %2, i32 0, i32 1
  %load3 = load %string*, %string** %memberptr2, align 8
  call void @stark_runtime_pub_println(%string* %load3)
  call void @exit(i64 1)
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  ret void
}

define void @stark.functions.main.downloadTestFile(%string* %url2) {
entry:
  %url = alloca %string*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %url, align 8
  store %string* %url2, %string** %url, align 8
  %alloc3 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([10 x i8]* getelementptr ([10 x i8], [10 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [10 x i8]*
  %dataptr4 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 0
  store i8 116, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 1
  store i8 101, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 2
  store i8 115, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 3
  store i8 116, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 4
  store i8 46, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 5
  store i8 106, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 6
  store i8 115, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 7
  store i8 111, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 8
  store i8 110, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 9
  store i8 0, i8* %dataptr13, align 1
  %alloc14 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc14 to %string*
  %stringleninit15 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 9, i64* %stringleninit15, align 4
  %stringdatainit16 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [10 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit16, align 8
  %alloc17 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc17 to [2 x i8]*
  %dataptr18 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 0
  store i8 119, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 1
  store i8 0, i8* %dataptr19, align 1
  %alloc20 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc20 to %string*
  %stringleninit21 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 1, i64* %stringleninit21, align 4
  %stringdatainit22 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [2 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit22, align 8
  %call = call %fs.FileResult* bitcast (%FileResult* (%string*, %string*)* @stark.functions.fs.openFile to %fs.FileResult* (%string*, %string*)*)(%string* %4, %string* %7)
  %f = alloca %fs.FileResult*, align 8
  store %fs.FileResult* %call, %fs.FileResult** %f, align 8
  %load = load %fs.FileResult*, %fs.FileResult** %f, align 8
  call void @stark.functions.main.handleFileError(%fs.FileResult* %load)
  %load23 = load %string*, %string** %url, align 8
  %9 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  %memberptr = getelementptr inbounds %fs.FileResult, %fs.FileResult* %9, i32 0, i32 0
  %load24 = load %fs.File*, %fs.File** %memberptr, align 8
  %call25 = call %http.HttpResult* bitcast (%HttpResult* (%string*, %fs.File*)* @stark.functions.http.downloadFile to %http.HttpResult* (%string*, %fs.File*)*)(%string* %load23, %fs.File* %load24)
  %hr = alloca %http.HttpResult*, align 8
  store %http.HttpResult* %call25, %http.HttpResult** %hr, align 8
  %load26 = load %http.HttpResult*, %http.HttpResult** %hr, align 8
  call void @stark.functions.main.handleHttpError(%http.HttpResult* %load26)
  %10 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  %memberptr27 = getelementptr inbounds %fs.FileResult, %fs.FileResult* %10, i32 0, i32 0
  %load28 = load %fs.File*, %fs.File** %memberptr27, align 8
  %call29 = call %fs.FileResult* bitcast (%FileResult* (%File*)* @stark.functions.fs.closeFile to %fs.FileResult* (%fs.File*)*)(%fs.File* %load28)
  store %fs.FileResult* %call29, %fs.FileResult** %f, align 8
  %load30 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  call void @stark.functions.main.handleFileError(%fs.FileResult* %load30)
  ret void
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

define %string* @stark.functions.main.readTestFile() {
entry:
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %result = alloca %string*, align 8
  store %string* %1, %string** %result, align 8
  %alloc2 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([10 x i8]* getelementptr ([10 x i8], [10 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc2 to [10 x i8]*
  %dataptr3 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 0
  store i8 116, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 1
  store i8 101, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 2
  store i8 115, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 3
  store i8 116, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 4
  store i8 46, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 5
  store i8 106, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 6
  store i8 115, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 7
  store i8 111, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 8
  store i8 110, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i32 0, i32 9
  store i8 0, i8* %dataptr12, align 1
  %alloc13 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc13 to %string*
  %stringleninit14 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 9, i64* %stringleninit14, align 4
  %stringdatainit15 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [10 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit15, align 8
  %alloc16 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc16 to [2 x i8]*
  %dataptr17 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 0
  store i8 114, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 1
  store i8 0, i8* %dataptr18, align 1
  %alloc19 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc19 to %string*
  %stringleninit20 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 1, i64* %stringleninit20, align 4
  %stringdatainit21 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [2 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit21, align 8
  %call = call %fs.FileResult* bitcast (%FileResult* (%string*, %string*)* @stark.functions.fs.openFile to %fs.FileResult* (%string*, %string*)*)(%string* %4, %string* %7)
  %f = alloca %fs.FileResult*, align 8
  store %fs.FileResult* %call, %fs.FileResult** %f, align 8
  %load = load %fs.FileResult*, %fs.FileResult** %f, align 8
  call void @stark.functions.main.handleFileError(%fs.FileResult* %load)
  %cstr = alloca i8*, align 8
  %alloc22 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([51 x i8]* getelementptr ([51 x i8], [51 x i8]* null, i32 1) to i64))
  %9 = bitcast i8* %alloc22 to [51 x i8]*
  %dataptr23 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 0
  store i8 48, i8* %dataptr23, align 1
  %dataptr24 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 1
  store i8 49, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 2
  store i8 50, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 3
  store i8 51, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 4
  store i8 52, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 5
  store i8 53, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 6
  store i8 54, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 7
  store i8 55, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 8
  store i8 56, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 9
  store i8 57, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 10
  store i8 48, i8* %dataptr33, align 1
  %dataptr34 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 11
  store i8 49, i8* %dataptr34, align 1
  %dataptr35 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 12
  store i8 50, i8* %dataptr35, align 1
  %dataptr36 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 13
  store i8 51, i8* %dataptr36, align 1
  %dataptr37 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 14
  store i8 52, i8* %dataptr37, align 1
  %dataptr38 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 15
  store i8 53, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 16
  store i8 54, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 17
  store i8 55, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 18
  store i8 56, i8* %dataptr41, align 1
  %dataptr42 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 19
  store i8 57, i8* %dataptr42, align 1
  %dataptr43 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 20
  store i8 48, i8* %dataptr43, align 1
  %dataptr44 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 21
  store i8 49, i8* %dataptr44, align 1
  %dataptr45 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 22
  store i8 50, i8* %dataptr45, align 1
  %dataptr46 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 23
  store i8 51, i8* %dataptr46, align 1
  %dataptr47 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 24
  store i8 52, i8* %dataptr47, align 1
  %dataptr48 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 25
  store i8 53, i8* %dataptr48, align 1
  %dataptr49 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 26
  store i8 54, i8* %dataptr49, align 1
  %dataptr50 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 27
  store i8 55, i8* %dataptr50, align 1
  %dataptr51 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 28
  store i8 56, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 29
  store i8 57, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 30
  store i8 48, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 31
  store i8 49, i8* %dataptr54, align 1
  %dataptr55 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 32
  store i8 50, i8* %dataptr55, align 1
  %dataptr56 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 33
  store i8 51, i8* %dataptr56, align 1
  %dataptr57 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 34
  store i8 52, i8* %dataptr57, align 1
  %dataptr58 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 35
  store i8 53, i8* %dataptr58, align 1
  %dataptr59 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 36
  store i8 54, i8* %dataptr59, align 1
  %dataptr60 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 37
  store i8 55, i8* %dataptr60, align 1
  %dataptr61 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 38
  store i8 56, i8* %dataptr61, align 1
  %dataptr62 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 39
  store i8 57, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 40
  store i8 48, i8* %dataptr63, align 1
  %dataptr64 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 41
  store i8 49, i8* %dataptr64, align 1
  %dataptr65 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 42
  store i8 50, i8* %dataptr65, align 1
  %dataptr66 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 43
  store i8 51, i8* %dataptr66, align 1
  %dataptr67 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 44
  store i8 52, i8* %dataptr67, align 1
  %dataptr68 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 45
  store i8 53, i8* %dataptr68, align 1
  %dataptr69 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 46
  store i8 54, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 47
  store i8 55, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 48
  store i8 56, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 49
  store i8 57, i8* %dataptr72, align 1
  %dataptr73 = getelementptr inbounds [51 x i8], [51 x i8]* %9, i32 0, i32 50
  store i8 0, i8* %dataptr73, align 1
  %alloc74 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %10 = bitcast i8* %alloc74 to %string*
  %stringleninit75 = getelementptr inbounds %string, %string* %10, i32 0, i32 1
  store i64 50, i64* %stringleninit75, align 4
  %stringdatainit76 = getelementptr inbounds %string, %string* %10, i32 0, i32 0
  %11 = bitcast [51 x i8]* %9 to i8*
  store i8* %11, i8** %stringdatainit76, align 8
  %call77 = call i8* @stark_runtime_pub_toCString(%string* %10)
  store i8* %call77, i8** %cstr, align 8
  br label %whiletest

whiletest:                                        ; preds = %ifcont, %entry
  %12 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  %memberptr = getelementptr inbounds %fs.FileResult, %fs.FileResult* %12, i32 0, i32 0
  %load78 = load %fs.File*, %fs.File** %memberptr, align 8
  %call79 = call i1 bitcast (i1 (%File*)* @stark.functions.fs.fileIsEOF to i1 (%fs.File*)*)(%fs.File* %load78)
  %cmp = icmp eq i1 %call79, false
  br i1 %cmp, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load80 = load i8*, i8** %cstr, align 8
  %13 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  %memberptr81 = getelementptr inbounds %fs.FileResult, %fs.FileResult* %13, i32 0, i32 0
  %14 = load %fs.File*, %fs.File** %memberptr81, align 8
  %memberptr82 = getelementptr inbounds %fs.File, %fs.File* %14, i32 0, i32 0
  %load83 = load i8*, i8** %memberptr82, align 8
  %call84 = call i8* @fgets(i8* %load80, i64 50, i8* %load83)
  %cmp85 = icmp eq i8* %call84, null
  br i1 %cmp85, label %if, label %else

if:                                               ; preds = %while
  br label %ifcont

else:                                             ; preds = %while
  %load86 = load %string*, %string** %result, align 8
  %load87 = load i8*, i8** %cstr, align 8
  %call88 = call %string* @stark_runtime_pub_fromCString(i8* %load87)
  %concat = call %string* @stark_runtime_priv_concat_string(%string* %load86, %string* %call88)
  store %string* %concat, %string** %result, align 8
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %15 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  %memberptr89 = getelementptr inbounds %fs.FileResult, %fs.FileResult* %15, i32 0, i32 0
  %load90 = load %fs.File*, %fs.File** %memberptr89, align 8
  %call91 = call %fs.FileResult* bitcast (%FileResult* (%File*)* @stark.functions.fs.closeFile to %fs.FileResult* (%fs.File*)*)(%fs.File* %load90)
  store %fs.FileResult* %call91, %fs.FileResult** %f, align 8
  %load92 = load %fs.FileResult*, %fs.FileResult** %f, align 8
  call void @stark.functions.main.handleFileError(%fs.FileResult* %load92)
  %load93 = load %string*, %string** %result, align 8
  ret %string* %load93
}

declare i8* @stark_runtime_pub_toCString(%string*)

declare i8* @fgets(i8*, i64, i8*)

declare %string* @stark_runtime_pub_fromCString(i8*)

declare %string* @stark_runtime_priv_concat_string(%string*, %string*)

define i64 @stark.functions.main.averageTime(%array.int* %durations2) {
entry:
  %durations = alloca %array.int*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([0 x i64]* getelementptr ([0 x i64], [0 x i64]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [0 x i64]*
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.int* getelementptr (%array.int, %array.int* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %array.int*
  %arrayleninit = getelementptr inbounds %array.int, %array.int* %1, i32 0, i32 1
  store i64 0, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.int, %array.int* %1, i32 0, i32 0
  %2 = bitcast [0 x i64]* %0 to i64*
  store i64* %2, i64** %arrayeleminit, align 8
  store %array.int* %1, %array.int** %durations, align 8
  store %array.int* %durations2, %array.int** %durations, align 8
  %total = alloca i64, align 8
  store i64 0, i64* %total, align 4
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 4
  br label %whiletest

whiletest:                                        ; preds = %while, %entry
  %load = load i64, i64* %i, align 4
  %3 = load %array.int*, %array.int** %durations, align 8
  %memberptr = getelementptr inbounds %array.int, %array.int* %3, i32 0, i32 1
  %load3 = load i64, i64* %memberptr, align 4
  %cmp = icmp slt i64 %load, %load3
  br i1 %cmp, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load4 = load i64, i64* %total, align 4
  %load5 = load i64, i64* %i, align 4
  %4 = trunc i64 %load5 to i32
  %5 = load %array.int*, %array.int** %durations, align 8
  %elementptrs = getelementptr inbounds %array.int, %array.int* %5, i32 0, i32 0
  %6 = load i64*, i64** %elementptrs, align 8
  %7 = getelementptr inbounds i64, i64* %6, i32 %4
  %load6 = load i64, i64* %7, align 4
  %binop = add i64 %load4, %load6
  store i64 %binop, i64* %total, align 4
  %load7 = load i64, i64* %i, align 4
  %binop8 = add i64 %load7, 1
  store i64 %binop8, i64* %i, align 4
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %load9 = load i64, i64* %total, align 4
  %8 = load %array.int*, %array.int** %durations, align 8
  %memberptr10 = getelementptr inbounds %array.int, %array.int* %8, i32 0, i32 1
  %load11 = load i64, i64* %memberptr10, align 4
  %binop12 = sdiv i64 %load9, %load11
  ret i64 %binop12
}

define %array.int* @stark.functions.main.runTest(%string* %url2, i64 %count3) {
entry:
  %url = alloca %string*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %url, align 8
  store %string* %url2, %string** %url, align 8
  %count = alloca i64, align 8
  store i64 0, i64* %count, align 4
  store i64 %count3, i64* %count, align 4
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([9 x i8]* getelementptr ([9 x i8], [9 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc4 to [9 x i8]*
  %dataptr5 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 0
  store i8 84, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 1
  store i8 101, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 2
  store i8 115, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 3
  store i8 116, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 4
  store i8 105, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 5
  store i8 110, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 6
  store i8 103, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 7
  store i8 32, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [9 x i8], [9 x i8]* %3, i32 0, i32 8
  store i8 0, i8* %dataptr13, align 1
  %alloc14 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc14 to %string*
  %stringleninit15 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 8, i64* %stringleninit15, align 4
  %stringdatainit16 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [9 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit16, align 8
  %load = load %string*, %string** %url, align 8
  %concat = call %string* @stark_runtime_priv_concat_string(%string* %4, %string* %load)
  call void @stark_runtime_pub_println(%string* %concat)
  %load17 = load %string*, %string** %url, align 8
  call void @stark.functions.main.downloadTestFile(%string* %load17)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 4
  %durations = alloca %array.int*, align 8
  %alloc18 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([0 x i64]* getelementptr ([0 x i64], [0 x i64]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc18 to [0 x i64]*
  %alloc19 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.int* getelementptr (%array.int, %array.int* null, i32 1) to i64))
  %7 = bitcast i8* %alloc19 to %array.int*
  %arrayleninit = getelementptr inbounds %array.int, %array.int* %7, i32 0, i32 1
  store i64 0, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.int, %array.int* %7, i32 0, i32 0
  %8 = bitcast [0 x i64]* %6 to i64*
  store i64* %8, i64** %arrayeleminit, align 8
  store %array.int* %7, %array.int** %durations, align 8
  %call = call %string* @stark.functions.main.readTestFile()
  %jsonString = alloca %string*, align 8
  store %string* %call, %string** %jsonString, align 8
  br label %whiletest

whiletest:                                        ; preds = %ifcont, %entry
  %load20 = load i64, i64* %i, align 4
  %load21 = load i64, i64* %count, align 4
  %cmp = icmp slt i64 %load20, %load21
  br i1 %cmp, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %call22 = call i64 @stark_runtime_pub_time()
  %start = alloca i64, align 8
  store i64 %call22, i64* %start, align 4
  %alloc23 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([9 x i8]* getelementptr ([9 x i8], [9 x i8]* null, i32 1) to i64))
  %9 = bitcast i8* %alloc23 to [9 x i8]*
  %dataptr24 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 0
  store i8 82, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 1
  store i8 117, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 2
  store i8 110, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 3
  store i8 110, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 4
  store i8 105, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 5
  store i8 110, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 6
  store i8 103, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 7
  store i8 32, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [9 x i8], [9 x i8]* %9, i32 0, i32 8
  store i8 0, i8* %dataptr32, align 1
  %alloc33 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %10 = bitcast i8* %alloc33 to %string*
  %stringleninit34 = getelementptr inbounds %string, %string* %10, i32 0, i32 1
  store i64 8, i64* %stringleninit34, align 4
  %stringdatainit35 = getelementptr inbounds %string, %string* %10, i32 0, i32 0
  %11 = bitcast [9 x i8]* %9 to i8*
  store i8* %11, i8** %stringdatainit35, align 8
  %load36 = load i64, i64* %i, align 4
  %binop = add i64 %load36, 1
  %conv = call %string* @stark_runtime_priv_conv_int_string(i64 %binop)
  %concat37 = call %string* @stark_runtime_priv_concat_string(%string* %10, %string* %conv)
  %alloc38 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %12 = bitcast i8* %alloc38 to [2 x i8]*
  %dataptr39 = getelementptr inbounds [2 x i8], [2 x i8]* %12, i32 0, i32 0
  store i8 47, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [2 x i8], [2 x i8]* %12, i32 0, i32 1
  store i8 0, i8* %dataptr40, align 1
  %alloc41 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %13 = bitcast i8* %alloc41 to %string*
  %stringleninit42 = getelementptr inbounds %string, %string* %13, i32 0, i32 1
  store i64 1, i64* %stringleninit42, align 4
  %stringdatainit43 = getelementptr inbounds %string, %string* %13, i32 0, i32 0
  %14 = bitcast [2 x i8]* %12 to i8*
  store i8* %14, i8** %stringdatainit43, align 8
  %concat44 = call %string* @stark_runtime_priv_concat_string(%string* %concat37, %string* %13)
  %load45 = load i64, i64* %count, align 4
  %conv46 = call %string* @stark_runtime_priv_conv_int_string(i64 %load45)
  %concat47 = call %string* @stark_runtime_priv_concat_string(%string* %concat44, %string* %conv46)
  call void @stark_runtime_pub_print(%string* %concat47)
  %load48 = load i64, i64* %i, align 4
  %cmp49 = icmp sgt i64 %load48, 0
  br i1 %cmp49, label %if, label %ifcont

if:                                               ; preds = %while
  %alloc50 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %15 = bitcast i8* %alloc50 to [3 x i8]*
  %dataptr51 = getelementptr inbounds [3 x i8], [3 x i8]* %15, i32 0, i32 0
  store i8 32, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [3 x i8], [3 x i8]* %15, i32 0, i32 1
  store i8 40, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [3 x i8], [3 x i8]* %15, i32 0, i32 2
  store i8 0, i8* %dataptr53, align 1
  %alloc54 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %16 = bitcast i8* %alloc54 to %string*
  %stringleninit55 = getelementptr inbounds %string, %string* %16, i32 0, i32 1
  store i64 2, i64* %stringleninit55, align 4
  %stringdatainit56 = getelementptr inbounds %string, %string* %16, i32 0, i32 0
  %17 = bitcast [3 x i8]* %15 to i8*
  store i8* %17, i8** %stringdatainit56, align 8
  %load57 = load %array.int*, %array.int** %durations, align 8
  %call58 = call i64 @stark.functions.main.averageTime(%array.int* %load57)
  %conv59 = call %string* @stark_runtime_priv_conv_int_string(i64 %call58)
  %concat60 = call %string* @stark_runtime_priv_concat_string(%string* %16, %string* %conv59)
  %alloc61 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([4 x i8]* getelementptr ([4 x i8], [4 x i8]* null, i32 1) to i64))
  %18 = bitcast i8* %alloc61 to [4 x i8]*
  %dataptr62 = getelementptr inbounds [4 x i8], [4 x i8]* %18, i32 0, i32 0
  store i8 109, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [4 x i8], [4 x i8]* %18, i32 0, i32 1
  store i8 115, i8* %dataptr63, align 1
  %dataptr64 = getelementptr inbounds [4 x i8], [4 x i8]* %18, i32 0, i32 2
  store i8 41, i8* %dataptr64, align 1
  %dataptr65 = getelementptr inbounds [4 x i8], [4 x i8]* %18, i32 0, i32 3
  store i8 0, i8* %dataptr65, align 1
  %alloc66 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %19 = bitcast i8* %alloc66 to %string*
  %stringleninit67 = getelementptr inbounds %string, %string* %19, i32 0, i32 1
  store i64 3, i64* %stringleninit67, align 4
  %stringdatainit68 = getelementptr inbounds %string, %string* %19, i32 0, i32 0
  %20 = bitcast [4 x i8]* %18 to i8*
  store i8* %20, i8** %stringdatainit68, align 8
  %concat69 = call %string* @stark_runtime_priv_concat_string(%string* %concat60, %string* %19)
  call void @stark_runtime_pub_print(%string* %concat69)
  br label %ifcont

ifcont:                                           ; preds = %if, %while
  %alloc70 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %21 = bitcast i8* %alloc70 to [2 x i8]*
  %dataptr71 = getelementptr inbounds [2 x i8], [2 x i8]* %21, i32 0, i32 0
  store i8 13, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [2 x i8], [2 x i8]* %21, i32 0, i32 1
  store i8 0, i8* %dataptr72, align 1
  %alloc73 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %22 = bitcast i8* %alloc73 to %string*
  %stringleninit74 = getelementptr inbounds %string, %string* %22, i32 0, i32 1
  store i64 1, i64* %stringleninit74, align 4
  %stringdatainit75 = getelementptr inbounds %string, %string* %22, i32 0, i32 0
  %23 = bitcast [2 x i8]* %21 to i8*
  store i8* %23, i8** %stringdatainit75, align 8
  call void @stark_runtime_pub_print(%string* %22)
  call void @stark_runtime_pub_printflush()
  %load76 = load %string*, %string** %jsonString, align 8
  %call77 = call %json.JSONResult* bitcast (%JSONResult* (%string*)* @stark.functions.json.parse to %json.JSONResult* (%string*)*)(%string* %load76)
  %jr = alloca %json.JSONResult*, align 8
  store %json.JSONResult* %call77, %json.JSONResult** %jr, align 8
  %load78 = load %json.JSONResult*, %json.JSONResult** %jr, align 8
  call void @stark.functions.main.handleJSONError(%json.JSONResult* %load78)
  %call79 = call i64 @stark_runtime_pub_time()
  %end = alloca i64, align 8
  store i64 %call79, i64* %end, align 4
  %load80 = load i64, i64* %end, align 4
  %load81 = load i64, i64* %start, align 4
  %binop82 = sub i64 %load80, %load81
  %duration = alloca i64, align 8
  store i64 %binop82, i64* %duration, align 4
  %load83 = load %array.int*, %array.int** %durations, align 8
  %load84 = load i64, i64* %duration, align 4
  %alloc85 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([1 x i64]* getelementptr ([1 x i64], [1 x i64]* null, i32 1) to i64))
  %24 = bitcast i8* %alloc85 to [1 x i64]*
  %elementptr = getelementptr inbounds [1 x i64], [1 x i64]* %24, i32 0, i32 0
  store i64 %load84, i64* %elementptr, align 4
  %alloc86 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%array.int* getelementptr (%array.int, %array.int* null, i32 1) to i64))
  %25 = bitcast i8* %alloc86 to %array.int*
  %arrayleninit87 = getelementptr inbounds %array.int, %array.int* %25, i32 0, i32 1
  store i64 1, i64* %arrayleninit87, align 4
  %arrayeleminit88 = getelementptr inbounds %array.int, %array.int* %25, i32 0, i32 0
  %26 = bitcast [1 x i64]* %24 to i64*
  store i64* %26, i64** %arrayeleminit88, align 8
  %27 = bitcast %array.int* %load83 to i8*
  %28 = bitcast %array.int* %25 to i8*
  %concat89 = call i8* @stark_runtime_priv_concat_array(i8* %27, i8* %28, i64 ptrtoint (i64** getelementptr (i64*, i64** null, i32 1) to i64))
  %29 = bitcast i8* %concat89 to %array.int*
  store %array.int* %29, %array.int** %durations, align 8
  %load90 = load i64, i64* %i, align 4
  %binop91 = add i64 %load90, 1
  store i64 %binop91, i64* %i, align 4
  call void @sleep(i64 1)
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %alloc92 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([26 x i8]* getelementptr ([26 x i8], [26 x i8]* null, i32 1) to i64))
  %30 = bitcast i8* %alloc92 to [26 x i8]*
  %dataptr93 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 0
  store i8 82, i8* %dataptr93, align 1
  %dataptr94 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 1
  store i8 97, i8* %dataptr94, align 1
  %dataptr95 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 2
  store i8 110, i8* %dataptr95, align 1
  %dataptr96 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 3
  store i8 32, i8* %dataptr96, align 1
  %dataptr97 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 4
  store i8 119, i8* %dataptr97, align 1
  %dataptr98 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 5
  store i8 105, i8* %dataptr98, align 1
  %dataptr99 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 6
  store i8 116, i8* %dataptr99, align 1
  %dataptr100 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 7
  store i8 104, i8* %dataptr100, align 1
  %dataptr101 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 8
  store i8 32, i8* %dataptr101, align 1
  %dataptr102 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 9
  store i8 97, i8* %dataptr102, align 1
  %dataptr103 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 10
  store i8 118, i8* %dataptr103, align 1
  %dataptr104 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 11
  store i8 101, i8* %dataptr104, align 1
  %dataptr105 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 12
  store i8 114, i8* %dataptr105, align 1
  %dataptr106 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 13
  store i8 97, i8* %dataptr106, align 1
  %dataptr107 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 14
  store i8 103, i8* %dataptr107, align 1
  %dataptr108 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 15
  store i8 101, i8* %dataptr108, align 1
  %dataptr109 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 16
  store i8 32, i8* %dataptr109, align 1
  %dataptr110 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 17
  store i8 116, i8* %dataptr110, align 1
  %dataptr111 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 18
  store i8 105, i8* %dataptr111, align 1
  %dataptr112 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 19
  store i8 109, i8* %dataptr112, align 1
  %dataptr113 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 20
  store i8 101, i8* %dataptr113, align 1
  %dataptr114 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 21
  store i8 32, i8* %dataptr114, align 1
  %dataptr115 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 22
  store i8 111, i8* %dataptr115, align 1
  %dataptr116 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 23
  store i8 102, i8* %dataptr116, align 1
  %dataptr117 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 24
  store i8 32, i8* %dataptr117, align 1
  %dataptr118 = getelementptr inbounds [26 x i8], [26 x i8]* %30, i32 0, i32 25
  store i8 0, i8* %dataptr118, align 1
  %alloc119 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %31 = bitcast i8* %alloc119 to %string*
  %stringleninit120 = getelementptr inbounds %string, %string* %31, i32 0, i32 1
  store i64 25, i64* %stringleninit120, align 4
  %stringdatainit121 = getelementptr inbounds %string, %string* %31, i32 0, i32 0
  %32 = bitcast [26 x i8]* %30 to i8*
  store i8* %32, i8** %stringdatainit121, align 8
  %load122 = load %array.int*, %array.int** %durations, align 8
  %call123 = call i64 @stark.functions.main.averageTime(%array.int* %load122)
  %conv124 = call %string* @stark_runtime_priv_conv_int_string(i64 %call123)
  %concat125 = call %string* @stark_runtime_priv_concat_string(%string* %31, %string* %conv124)
  %alloc126 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %33 = bitcast i8* %alloc126 to [3 x i8]*
  %dataptr127 = getelementptr inbounds [3 x i8], [3 x i8]* %33, i32 0, i32 0
  store i8 109, i8* %dataptr127, align 1
  %dataptr128 = getelementptr inbounds [3 x i8], [3 x i8]* %33, i32 0, i32 1
  store i8 115, i8* %dataptr128, align 1
  %dataptr129 = getelementptr inbounds [3 x i8], [3 x i8]* %33, i32 0, i32 2
  store i8 0, i8* %dataptr129, align 1
  %alloc130 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %34 = bitcast i8* %alloc130 to %string*
  %stringleninit131 = getelementptr inbounds %string, %string* %34, i32 0, i32 1
  store i64 2, i64* %stringleninit131, align 4
  %stringdatainit132 = getelementptr inbounds %string, %string* %34, i32 0, i32 0
  %35 = bitcast [3 x i8]* %33 to i8*
  store i8* %35, i8** %stringdatainit132, align 8
  %concat133 = call %string* @stark_runtime_priv_concat_string(%string* %concat125, %string* %34)
  call void @stark_runtime_pub_print(%string* %concat133)
  %alloc134 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %36 = bitcast i8* %alloc134 to [3 x i8]*
  %dataptr135 = getelementptr inbounds [3 x i8], [3 x i8]* %36, i32 0, i32 0
  store i8 13, i8* %dataptr135, align 1
  %dataptr136 = getelementptr inbounds [3 x i8], [3 x i8]* %36, i32 0, i32 1
  store i8 10, i8* %dataptr136, align 1
  %dataptr137 = getelementptr inbounds [3 x i8], [3 x i8]* %36, i32 0, i32 2
  store i8 0, i8* %dataptr137, align 1
  %alloc138 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %37 = bitcast i8* %alloc138 to %string*
  %stringleninit139 = getelementptr inbounds %string, %string* %37, i32 0, i32 1
  store i64 2, i64* %stringleninit139, align 4
  %stringdatainit140 = getelementptr inbounds %string, %string* %37, i32 0, i32 0
  %38 = bitcast [3 x i8]* %36 to i8*
  store i8* %38, i8** %stringdatainit140, align 8
  call void @stark_runtime_pub_print(%string* %37)
  %load141 = load %array.int*, %array.int** %durations, align 8
  ret %array.int* %load141
}

declare i64 @stark_runtime_pub_time()

declare %string* @stark_runtime_priv_conv_int_string(i64)

declare void @stark_runtime_pub_print(%string*)

declare void @stark_runtime_pub_printflush()

declare i8* @stark_runtime_priv_concat_array(i8*, i8*, i64)

declare void @sleep(i64)

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  call void @GC_enable_incremental()
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([34 x i8]* getelementptr ([34 x i8], [34 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [34 x i8]*
  %dataptr = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 0
  store i8 87, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 1
  store i8 101, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 2
  store i8 108, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 3
  store i8 99, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 4
  store i8 111, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 5
  store i8 109, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 6
  store i8 101, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 7
  store i8 32, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 8
  store i8 116, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 9
  store i8 111, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 10
  store i8 32, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 11
  store i8 116, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 12
  store i8 104, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 13
  store i8 101, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 14
  store i8 32, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 15
  store i8 74, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 16
  store i8 83, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 17
  store i8 79, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 18
  store i8 78, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 19
  store i8 32, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 20
  store i8 112, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 21
  store i8 97, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 22
  store i8 114, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 23
  store i8 115, i8* %dataptr23, align 1
  %dataptr24 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 24
  store i8 101, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 25
  store i8 32, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 26
  store i8 98, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 27
  store i8 101, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 28
  store i8 110, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 29
  store i8 99, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 30
  store i8 104, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 31
  store i8 32, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 32
  store i8 33, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [34 x i8], [34 x i8]* %0, i32 0, i32 33
  store i8 0, i8* %dataptr33, align 1
  %alloc34 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc34 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 33, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [34 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  call void @stark_runtime_pub_println(%string* %1)
  %count = alloca i64, align 8
  store i64 25, i64* %count, align 4
  %alloc35 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([95 x i8]* getelementptr ([95 x i8], [95 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc35 to [95 x i8]*
  %dataptr36 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 0
  store i8 104, i8* %dataptr36, align 1
  %dataptr37 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 1
  store i8 116, i8* %dataptr37, align 1
  %dataptr38 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 2
  store i8 116, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 3
  store i8 112, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 4
  store i8 115, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 5
  store i8 58, i8* %dataptr41, align 1
  %dataptr42 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 6
  store i8 47, i8* %dataptr42, align 1
  %dataptr43 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 7
  store i8 47, i8* %dataptr43, align 1
  %dataptr44 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 8
  store i8 114, i8* %dataptr44, align 1
  %dataptr45 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 9
  store i8 97, i8* %dataptr45, align 1
  %dataptr46 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 10
  store i8 119, i8* %dataptr46, align 1
  %dataptr47 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 11
  store i8 46, i8* %dataptr47, align 1
  %dataptr48 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 12
  store i8 103, i8* %dataptr48, align 1
  %dataptr49 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 13
  store i8 105, i8* %dataptr49, align 1
  %dataptr50 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 14
  store i8 116, i8* %dataptr50, align 1
  %dataptr51 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 15
  store i8 104, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 16
  store i8 117, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 17
  store i8 98, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 18
  store i8 117, i8* %dataptr54, align 1
  %dataptr55 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 19
  store i8 115, i8* %dataptr55, align 1
  %dataptr56 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 20
  store i8 101, i8* %dataptr56, align 1
  %dataptr57 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 21
  store i8 114, i8* %dataptr57, align 1
  %dataptr58 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 22
  store i8 99, i8* %dataptr58, align 1
  %dataptr59 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 23
  store i8 111, i8* %dataptr59, align 1
  %dataptr60 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 24
  store i8 110, i8* %dataptr60, align 1
  %dataptr61 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 25
  store i8 116, i8* %dataptr61, align 1
  %dataptr62 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 26
  store i8 101, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 27
  store i8 110, i8* %dataptr63, align 1
  %dataptr64 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 28
  store i8 116, i8* %dataptr64, align 1
  %dataptr65 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 29
  store i8 46, i8* %dataptr65, align 1
  %dataptr66 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 30
  store i8 99, i8* %dataptr66, align 1
  %dataptr67 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 31
  store i8 111, i8* %dataptr67, align 1
  %dataptr68 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 32
  store i8 109, i8* %dataptr68, align 1
  %dataptr69 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 33
  store i8 47, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 34
  store i8 97, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 35
  store i8 109, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 36
  store i8 97, i8* %dataptr72, align 1
  %dataptr73 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 37
  store i8 109, i8* %dataptr73, align 1
  %dataptr74 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 38
  store i8 99, i8* %dataptr74, align 1
  %dataptr75 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 39
  store i8 104, i8* %dataptr75, align 1
  %dataptr76 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 40
  store i8 117, i8* %dataptr76, align 1
  %dataptr77 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 41
  store i8 114, i8* %dataptr77, align 1
  %dataptr78 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 42
  store i8 47, i8* %dataptr78, align 1
  %dataptr79 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 43
  store i8 105, i8* %dataptr79, align 1
  %dataptr80 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 44
  store i8 74, i8* %dataptr80, align 1
  %dataptr81 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 45
  store i8 83, i8* %dataptr81, align 1
  %dataptr82 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 46
  store i8 79, i8* %dataptr82, align 1
  %dataptr83 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 47
  store i8 78, i8* %dataptr83, align 1
  %dataptr84 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 48
  store i8 66, i8* %dataptr84, align 1
  %dataptr85 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 49
  store i8 101, i8* %dataptr85, align 1
  %dataptr86 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 50
  store i8 110, i8* %dataptr86, align 1
  %dataptr87 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 51
  store i8 99, i8* %dataptr87, align 1
  %dataptr88 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 52
  store i8 104, i8* %dataptr88, align 1
  %dataptr89 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 53
  store i8 109, i8* %dataptr89, align 1
  %dataptr90 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 54
  store i8 97, i8* %dataptr90, align 1
  %dataptr91 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 55
  store i8 114, i8* %dataptr91, align 1
  %dataptr92 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 56
  store i8 107, i8* %dataptr92, align 1
  %dataptr93 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 57
  store i8 47, i8* %dataptr93, align 1
  %dataptr94 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 58
  store i8 109, i8* %dataptr94, align 1
  %dataptr95 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 59
  store i8 97, i8* %dataptr95, align 1
  %dataptr96 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 60
  store i8 115, i8* %dataptr96, align 1
  %dataptr97 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 61
  store i8 116, i8* %dataptr97, align 1
  %dataptr98 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 62
  store i8 101, i8* %dataptr98, align 1
  %dataptr99 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 63
  store i8 114, i8* %dataptr99, align 1
  %dataptr100 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 64
  store i8 47, i8* %dataptr100, align 1
  %dataptr101 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 65
  store i8 112, i8* %dataptr101, align 1
  %dataptr102 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 66
  store i8 97, i8* %dataptr102, align 1
  %dataptr103 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 67
  store i8 121, i8* %dataptr103, align 1
  %dataptr104 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 68
  store i8 108, i8* %dataptr104, align 1
  %dataptr105 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 69
  store i8 111, i8* %dataptr105, align 1
  %dataptr106 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 70
  store i8 97, i8* %dataptr106, align 1
  %dataptr107 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 71
  store i8 100, i8* %dataptr107, align 1
  %dataptr108 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 72
  store i8 47, i8* %dataptr108, align 1
  %dataptr109 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 73
  store i8 116, i8* %dataptr109, align 1
  %dataptr110 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 74
  store i8 119, i8* %dataptr110, align 1
  %dataptr111 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 75
  store i8 105, i8* %dataptr111, align 1
  %dataptr112 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 76
  store i8 116, i8* %dataptr112, align 1
  %dataptr113 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 77
  store i8 116, i8* %dataptr113, align 1
  %dataptr114 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 78
  store i8 101, i8* %dataptr114, align 1
  %dataptr115 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 79
  store i8 114, i8* %dataptr115, align 1
  %dataptr116 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 80
  store i8 95, i8* %dataptr116, align 1
  %dataptr117 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 81
  store i8 116, i8* %dataptr117, align 1
  %dataptr118 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 82
  store i8 105, i8* %dataptr118, align 1
  %dataptr119 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 83
  store i8 109, i8* %dataptr119, align 1
  %dataptr120 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 84
  store i8 101, i8* %dataptr120, align 1
  %dataptr121 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 85
  store i8 108, i8* %dataptr121, align 1
  %dataptr122 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 86
  store i8 105, i8* %dataptr122, align 1
  %dataptr123 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 87
  store i8 110, i8* %dataptr123, align 1
  %dataptr124 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 88
  store i8 101, i8* %dataptr124, align 1
  %dataptr125 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 89
  store i8 46, i8* %dataptr125, align 1
  %dataptr126 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 90
  store i8 106, i8* %dataptr126, align 1
  %dataptr127 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 91
  store i8 115, i8* %dataptr127, align 1
  %dataptr128 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 92
  store i8 111, i8* %dataptr128, align 1
  %dataptr129 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 93
  store i8 110, i8* %dataptr129, align 1
  %dataptr130 = getelementptr inbounds [95 x i8], [95 x i8]* %3, i32 0, i32 94
  store i8 0, i8* %dataptr130, align 1
  %alloc131 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc131 to %string*
  %stringleninit132 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 94, i64* %stringleninit132, align 4
  %stringdatainit133 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [95 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit133, align 8
  %load = load i64, i64* %count, align 4
  %call = call %array.int* @stark.functions.main.runTest(%string* %4, i64 %load)
  %alloc134 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([92 x i8]* getelementptr ([92 x i8], [92 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc134 to [92 x i8]*
  %dataptr135 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 0
  store i8 104, i8* %dataptr135, align 1
  %dataptr136 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 1
  store i8 116, i8* %dataptr136, align 1
  %dataptr137 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 2
  store i8 116, i8* %dataptr137, align 1
  %dataptr138 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 3
  store i8 112, i8* %dataptr138, align 1
  %dataptr139 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 4
  store i8 115, i8* %dataptr139, align 1
  %dataptr140 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 5
  store i8 58, i8* %dataptr140, align 1
  %dataptr141 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 6
  store i8 47, i8* %dataptr141, align 1
  %dataptr142 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 7
  store i8 47, i8* %dataptr142, align 1
  %dataptr143 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 8
  store i8 114, i8* %dataptr143, align 1
  %dataptr144 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 9
  store i8 97, i8* %dataptr144, align 1
  %dataptr145 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 10
  store i8 119, i8* %dataptr145, align 1
  %dataptr146 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 11
  store i8 46, i8* %dataptr146, align 1
  %dataptr147 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 12
  store i8 103, i8* %dataptr147, align 1
  %dataptr148 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 13
  store i8 105, i8* %dataptr148, align 1
  %dataptr149 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 14
  store i8 116, i8* %dataptr149, align 1
  %dataptr150 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 15
  store i8 104, i8* %dataptr150, align 1
  %dataptr151 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 16
  store i8 117, i8* %dataptr151, align 1
  %dataptr152 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 17
  store i8 98, i8* %dataptr152, align 1
  %dataptr153 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 18
  store i8 117, i8* %dataptr153, align 1
  %dataptr154 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 19
  store i8 115, i8* %dataptr154, align 1
  %dataptr155 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 20
  store i8 101, i8* %dataptr155, align 1
  %dataptr156 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 21
  store i8 114, i8* %dataptr156, align 1
  %dataptr157 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 22
  store i8 99, i8* %dataptr157, align 1
  %dataptr158 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 23
  store i8 111, i8* %dataptr158, align 1
  %dataptr159 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 24
  store i8 110, i8* %dataptr159, align 1
  %dataptr160 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 25
  store i8 116, i8* %dataptr160, align 1
  %dataptr161 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 26
  store i8 101, i8* %dataptr161, align 1
  %dataptr162 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 27
  store i8 110, i8* %dataptr162, align 1
  %dataptr163 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 28
  store i8 116, i8* %dataptr163, align 1
  %dataptr164 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 29
  store i8 46, i8* %dataptr164, align 1
  %dataptr165 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 30
  store i8 99, i8* %dataptr165, align 1
  %dataptr166 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 31
  store i8 111, i8* %dataptr166, align 1
  %dataptr167 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 32
  store i8 109, i8* %dataptr167, align 1
  %dataptr168 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 33
  store i8 47, i8* %dataptr168, align 1
  %dataptr169 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 34
  store i8 97, i8* %dataptr169, align 1
  %dataptr170 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 35
  store i8 109, i8* %dataptr170, align 1
  %dataptr171 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 36
  store i8 97, i8* %dataptr171, align 1
  %dataptr172 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 37
  store i8 109, i8* %dataptr172, align 1
  %dataptr173 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 38
  store i8 99, i8* %dataptr173, align 1
  %dataptr174 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 39
  store i8 104, i8* %dataptr174, align 1
  %dataptr175 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 40
  store i8 117, i8* %dataptr175, align 1
  %dataptr176 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 41
  store i8 114, i8* %dataptr176, align 1
  %dataptr177 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 42
  store i8 47, i8* %dataptr177, align 1
  %dataptr178 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 43
  store i8 105, i8* %dataptr178, align 1
  %dataptr179 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 44
  store i8 74, i8* %dataptr179, align 1
  %dataptr180 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 45
  store i8 83, i8* %dataptr180, align 1
  %dataptr181 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 46
  store i8 79, i8* %dataptr181, align 1
  %dataptr182 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 47
  store i8 78, i8* %dataptr182, align 1
  %dataptr183 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 48
  store i8 66, i8* %dataptr183, align 1
  %dataptr184 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 49
  store i8 101, i8* %dataptr184, align 1
  %dataptr185 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 50
  store i8 110, i8* %dataptr185, align 1
  %dataptr186 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 51
  store i8 99, i8* %dataptr186, align 1
  %dataptr187 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 52
  store i8 104, i8* %dataptr187, align 1
  %dataptr188 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 53
  store i8 109, i8* %dataptr188, align 1
  %dataptr189 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 54
  store i8 97, i8* %dataptr189, align 1
  %dataptr190 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 55
  store i8 114, i8* %dataptr190, align 1
  %dataptr191 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 56
  store i8 107, i8* %dataptr191, align 1
  %dataptr192 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 57
  store i8 47, i8* %dataptr192, align 1
  %dataptr193 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 58
  store i8 109, i8* %dataptr193, align 1
  %dataptr194 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 59
  store i8 97, i8* %dataptr194, align 1
  %dataptr195 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 60
  store i8 115, i8* %dataptr195, align 1
  %dataptr196 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 61
  store i8 116, i8* %dataptr196, align 1
  %dataptr197 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 62
  store i8 101, i8* %dataptr197, align 1
  %dataptr198 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 63
  store i8 114, i8* %dataptr198, align 1
  %dataptr199 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 64
  store i8 47, i8* %dataptr199, align 1
  %dataptr200 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 65
  store i8 112, i8* %dataptr200, align 1
  %dataptr201 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 66
  store i8 97, i8* %dataptr201, align 1
  %dataptr202 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 67
  store i8 121, i8* %dataptr202, align 1
  %dataptr203 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 68
  store i8 108, i8* %dataptr203, align 1
  %dataptr204 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 69
  store i8 111, i8* %dataptr204, align 1
  %dataptr205 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 70
  store i8 97, i8* %dataptr205, align 1
  %dataptr206 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 71
  store i8 100, i8* %dataptr206, align 1
  %dataptr207 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 72
  store i8 47, i8* %dataptr207, align 1
  %dataptr208 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 73
  store i8 103, i8* %dataptr208, align 1
  %dataptr209 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 74
  store i8 105, i8* %dataptr209, align 1
  %dataptr210 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 75
  store i8 116, i8* %dataptr210, align 1
  %dataptr211 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 76
  store i8 104, i8* %dataptr211, align 1
  %dataptr212 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 77
  store i8 117, i8* %dataptr212, align 1
  %dataptr213 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 78
  store i8 98, i8* %dataptr213, align 1
  %dataptr214 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 79
  store i8 95, i8* %dataptr214, align 1
  %dataptr215 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 80
  store i8 101, i8* %dataptr215, align 1
  %dataptr216 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 81
  store i8 118, i8* %dataptr216, align 1
  %dataptr217 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 82
  store i8 101, i8* %dataptr217, align 1
  %dataptr218 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 83
  store i8 110, i8* %dataptr218, align 1
  %dataptr219 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 84
  store i8 116, i8* %dataptr219, align 1
  %dataptr220 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 85
  store i8 115, i8* %dataptr220, align 1
  %dataptr221 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 86
  store i8 46, i8* %dataptr221, align 1
  %dataptr222 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 87
  store i8 106, i8* %dataptr222, align 1
  %dataptr223 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 88
  store i8 115, i8* %dataptr223, align 1
  %dataptr224 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 89
  store i8 111, i8* %dataptr224, align 1
  %dataptr225 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 90
  store i8 110, i8* %dataptr225, align 1
  %dataptr226 = getelementptr inbounds [92 x i8], [92 x i8]* %6, i32 0, i32 91
  store i8 0, i8* %dataptr226, align 1
  %alloc227 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc227 to %string*
  %stringleninit228 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 91, i64* %stringleninit228, align 4
  %stringdatainit229 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [92 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit229, align 8
  %load230 = load i64, i64* %count, align 4
  %call231 = call %array.int* @stark.functions.main.runTest(%string* %7, i64 %load230)
  %alloc232 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([85 x i8]* getelementptr ([85 x i8], [85 x i8]* null, i32 1) to i64))
  %9 = bitcast i8* %alloc232 to [85 x i8]*
  %dataptr233 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 0
  store i8 104, i8* %dataptr233, align 1
  %dataptr234 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 1
  store i8 116, i8* %dataptr234, align 1
  %dataptr235 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 2
  store i8 116, i8* %dataptr235, align 1
  %dataptr236 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 3
  store i8 112, i8* %dataptr236, align 1
  %dataptr237 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 4
  store i8 115, i8* %dataptr237, align 1
  %dataptr238 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 5
  store i8 58, i8* %dataptr238, align 1
  %dataptr239 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 6
  store i8 47, i8* %dataptr239, align 1
  %dataptr240 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 7
  store i8 47, i8* %dataptr240, align 1
  %dataptr241 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 8
  store i8 114, i8* %dataptr241, align 1
  %dataptr242 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 9
  store i8 97, i8* %dataptr242, align 1
  %dataptr243 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 10
  store i8 119, i8* %dataptr243, align 1
  %dataptr244 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 11
  store i8 46, i8* %dataptr244, align 1
  %dataptr245 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 12
  store i8 103, i8* %dataptr245, align 1
  %dataptr246 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 13
  store i8 105, i8* %dataptr246, align 1
  %dataptr247 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 14
  store i8 116, i8* %dataptr247, align 1
  %dataptr248 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 15
  store i8 104, i8* %dataptr248, align 1
  %dataptr249 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 16
  store i8 117, i8* %dataptr249, align 1
  %dataptr250 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 17
  store i8 98, i8* %dataptr250, align 1
  %dataptr251 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 18
  store i8 117, i8* %dataptr251, align 1
  %dataptr252 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 19
  store i8 115, i8* %dataptr252, align 1
  %dataptr253 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 20
  store i8 101, i8* %dataptr253, align 1
  %dataptr254 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 21
  store i8 114, i8* %dataptr254, align 1
  %dataptr255 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 22
  store i8 99, i8* %dataptr255, align 1
  %dataptr256 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 23
  store i8 111, i8* %dataptr256, align 1
  %dataptr257 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 24
  store i8 110, i8* %dataptr257, align 1
  %dataptr258 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 25
  store i8 116, i8* %dataptr258, align 1
  %dataptr259 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 26
  store i8 101, i8* %dataptr259, align 1
  %dataptr260 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 27
  store i8 110, i8* %dataptr260, align 1
  %dataptr261 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 28
  store i8 116, i8* %dataptr261, align 1
  %dataptr262 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 29
  store i8 46, i8* %dataptr262, align 1
  %dataptr263 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 30
  store i8 99, i8* %dataptr263, align 1
  %dataptr264 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 31
  store i8 111, i8* %dataptr264, align 1
  %dataptr265 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 32
  store i8 109, i8* %dataptr265, align 1
  %dataptr266 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 33
  store i8 47, i8* %dataptr266, align 1
  %dataptr267 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 34
  store i8 97, i8* %dataptr267, align 1
  %dataptr268 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 35
  store i8 109, i8* %dataptr268, align 1
  %dataptr269 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 36
  store i8 97, i8* %dataptr269, align 1
  %dataptr270 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 37
  store i8 109, i8* %dataptr270, align 1
  %dataptr271 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 38
  store i8 99, i8* %dataptr271, align 1
  %dataptr272 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 39
  store i8 104, i8* %dataptr272, align 1
  %dataptr273 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 40
  store i8 117, i8* %dataptr273, align 1
  %dataptr274 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 41
  store i8 114, i8* %dataptr274, align 1
  %dataptr275 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 42
  store i8 47, i8* %dataptr275, align 1
  %dataptr276 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 43
  store i8 105, i8* %dataptr276, align 1
  %dataptr277 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 44
  store i8 74, i8* %dataptr277, align 1
  %dataptr278 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 45
  store i8 83, i8* %dataptr278, align 1
  %dataptr279 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 46
  store i8 79, i8* %dataptr279, align 1
  %dataptr280 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 47
  store i8 78, i8* %dataptr280, align 1
  %dataptr281 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 48
  store i8 66, i8* %dataptr281, align 1
  %dataptr282 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 49
  store i8 101, i8* %dataptr282, align 1
  %dataptr283 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 50
  store i8 110, i8* %dataptr283, align 1
  %dataptr284 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 51
  store i8 99, i8* %dataptr284, align 1
  %dataptr285 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 52
  store i8 104, i8* %dataptr285, align 1
  %dataptr286 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 53
  store i8 109, i8* %dataptr286, align 1
  %dataptr287 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 54
  store i8 97, i8* %dataptr287, align 1
  %dataptr288 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 55
  store i8 114, i8* %dataptr288, align 1
  %dataptr289 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 56
  store i8 107, i8* %dataptr289, align 1
  %dataptr290 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 57
  store i8 47, i8* %dataptr290, align 1
  %dataptr291 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 58
  store i8 109, i8* %dataptr291, align 1
  %dataptr292 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 59
  store i8 97, i8* %dataptr292, align 1
  %dataptr293 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 60
  store i8 115, i8* %dataptr293, align 1
  %dataptr294 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 61
  store i8 116, i8* %dataptr294, align 1
  %dataptr295 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 62
  store i8 101, i8* %dataptr295, align 1
  %dataptr296 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 63
  store i8 114, i8* %dataptr296, align 1
  %dataptr297 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 64
  store i8 47, i8* %dataptr297, align 1
  %dataptr298 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 65
  store i8 112, i8* %dataptr298, align 1
  %dataptr299 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 66
  store i8 97, i8* %dataptr299, align 1
  %dataptr300 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 67
  store i8 121, i8* %dataptr300, align 1
  %dataptr301 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 68
  store i8 108, i8* %dataptr301, align 1
  %dataptr302 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 69
  store i8 111, i8* %dataptr302, align 1
  %dataptr303 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 70
  store i8 97, i8* %dataptr303, align 1
  %dataptr304 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 71
  store i8 100, i8* %dataptr304, align 1
  %dataptr305 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 72
  store i8 47, i8* %dataptr305, align 1
  %dataptr306 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 73
  store i8 114, i8* %dataptr306, align 1
  %dataptr307 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 74
  store i8 101, i8* %dataptr307, align 1
  %dataptr308 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 75
  store i8 112, i8* %dataptr308, align 1
  %dataptr309 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 76
  store i8 101, i8* %dataptr309, align 1
  %dataptr310 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 77
  store i8 97, i8* %dataptr310, align 1
  %dataptr311 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 78
  store i8 116, i8* %dataptr311, align 1
  %dataptr312 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 79
  store i8 46, i8* %dataptr312, align 1
  %dataptr313 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 80
  store i8 106, i8* %dataptr313, align 1
  %dataptr314 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 81
  store i8 115, i8* %dataptr314, align 1
  %dataptr315 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 82
  store i8 111, i8* %dataptr315, align 1
  %dataptr316 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 83
  store i8 110, i8* %dataptr316, align 1
  %dataptr317 = getelementptr inbounds [85 x i8], [85 x i8]* %9, i32 0, i32 84
  store i8 0, i8* %dataptr317, align 1
  %alloc318 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %10 = bitcast i8* %alloc318 to %string*
  %stringleninit319 = getelementptr inbounds %string, %string* %10, i32 0, i32 1
  store i64 84, i64* %stringleninit319, align 4
  %stringdatainit320 = getelementptr inbounds %string, %string* %10, i32 0, i32 0
  %11 = bitcast [85 x i8]* %9 to i8*
  store i8* %11, i8** %stringdatainit320, align 8
  %load321 = load i64, i64* %count, align 4
  %call322 = call %array.int* @stark.functions.main.runTest(%string* %10, i64 %load321)
  %alloc323 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([87 x i8]* getelementptr ([87 x i8], [87 x i8]* null, i32 1) to i64))
  %12 = bitcast i8* %alloc323 to [87 x i8]*
  %dataptr324 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 0
  store i8 104, i8* %dataptr324, align 1
  %dataptr325 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 1
  store i8 116, i8* %dataptr325, align 1
  %dataptr326 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 2
  store i8 116, i8* %dataptr326, align 1
  %dataptr327 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 3
  store i8 112, i8* %dataptr327, align 1
  %dataptr328 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 4
  store i8 115, i8* %dataptr328, align 1
  %dataptr329 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 5
  store i8 58, i8* %dataptr329, align 1
  %dataptr330 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 6
  store i8 47, i8* %dataptr330, align 1
  %dataptr331 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 7
  store i8 47, i8* %dataptr331, align 1
  %dataptr332 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 8
  store i8 114, i8* %dataptr332, align 1
  %dataptr333 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 9
  store i8 97, i8* %dataptr333, align 1
  %dataptr334 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 10
  store i8 119, i8* %dataptr334, align 1
  %dataptr335 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 11
  store i8 46, i8* %dataptr335, align 1
  %dataptr336 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 12
  store i8 103, i8* %dataptr336, align 1
  %dataptr337 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 13
  store i8 105, i8* %dataptr337, align 1
  %dataptr338 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 14
  store i8 116, i8* %dataptr338, align 1
  %dataptr339 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 15
  store i8 104, i8* %dataptr339, align 1
  %dataptr340 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 16
  store i8 117, i8* %dataptr340, align 1
  %dataptr341 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 17
  store i8 98, i8* %dataptr341, align 1
  %dataptr342 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 18
  store i8 117, i8* %dataptr342, align 1
  %dataptr343 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 19
  store i8 115, i8* %dataptr343, align 1
  %dataptr344 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 20
  store i8 101, i8* %dataptr344, align 1
  %dataptr345 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 21
  store i8 114, i8* %dataptr345, align 1
  %dataptr346 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 22
  store i8 99, i8* %dataptr346, align 1
  %dataptr347 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 23
  store i8 111, i8* %dataptr347, align 1
  %dataptr348 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 24
  store i8 110, i8* %dataptr348, align 1
  %dataptr349 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 25
  store i8 116, i8* %dataptr349, align 1
  %dataptr350 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 26
  store i8 101, i8* %dataptr350, align 1
  %dataptr351 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 27
  store i8 110, i8* %dataptr351, align 1
  %dataptr352 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 28
  store i8 116, i8* %dataptr352, align 1
  %dataptr353 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 29
  store i8 46, i8* %dataptr353, align 1
  %dataptr354 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 30
  store i8 99, i8* %dataptr354, align 1
  %dataptr355 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 31
  store i8 111, i8* %dataptr355, align 1
  %dataptr356 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 32
  store i8 109, i8* %dataptr356, align 1
  %dataptr357 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 33
  store i8 47, i8* %dataptr357, align 1
  %dataptr358 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 34
  store i8 97, i8* %dataptr358, align 1
  %dataptr359 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 35
  store i8 109, i8* %dataptr359, align 1
  %dataptr360 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 36
  store i8 97, i8* %dataptr360, align 1
  %dataptr361 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 37
  store i8 109, i8* %dataptr361, align 1
  %dataptr362 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 38
  store i8 99, i8* %dataptr362, align 1
  %dataptr363 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 39
  store i8 104, i8* %dataptr363, align 1
  %dataptr364 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 40
  store i8 117, i8* %dataptr364, align 1
  %dataptr365 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 41
  store i8 114, i8* %dataptr365, align 1
  %dataptr366 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 42
  store i8 47, i8* %dataptr366, align 1
  %dataptr367 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 43
  store i8 105, i8* %dataptr367, align 1
  %dataptr368 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 44
  store i8 74, i8* %dataptr368, align 1
  %dataptr369 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 45
  store i8 83, i8* %dataptr369, align 1
  %dataptr370 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 46
  store i8 79, i8* %dataptr370, align 1
  %dataptr371 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 47
  store i8 78, i8* %dataptr371, align 1
  %dataptr372 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 48
  store i8 66, i8* %dataptr372, align 1
  %dataptr373 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 49
  store i8 101, i8* %dataptr373, align 1
  %dataptr374 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 50
  store i8 110, i8* %dataptr374, align 1
  %dataptr375 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 51
  store i8 99, i8* %dataptr375, align 1
  %dataptr376 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 52
  store i8 104, i8* %dataptr376, align 1
  %dataptr377 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 53
  store i8 109, i8* %dataptr377, align 1
  %dataptr378 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 54
  store i8 97, i8* %dataptr378, align 1
  %dataptr379 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 55
  store i8 114, i8* %dataptr379, align 1
  %dataptr380 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 56
  store i8 107, i8* %dataptr380, align 1
  %dataptr381 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 57
  store i8 47, i8* %dataptr381, align 1
  %dataptr382 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 58
  store i8 109, i8* %dataptr382, align 1
  %dataptr383 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 59
  store i8 97, i8* %dataptr383, align 1
  %dataptr384 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 60
  store i8 115, i8* %dataptr384, align 1
  %dataptr385 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 61
  store i8 116, i8* %dataptr385, align 1
  %dataptr386 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 62
  store i8 101, i8* %dataptr386, align 1
  %dataptr387 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 63
  store i8 114, i8* %dataptr387, align 1
  %dataptr388 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 64
  store i8 47, i8* %dataptr388, align 1
  %dataptr389 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 65
  store i8 112, i8* %dataptr389, align 1
  %dataptr390 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 66
  store i8 97, i8* %dataptr390, align 1
  %dataptr391 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 67
  store i8 121, i8* %dataptr391, align 1
  %dataptr392 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 68
  store i8 108, i8* %dataptr392, align 1
  %dataptr393 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 69
  store i8 111, i8* %dataptr393, align 1
  %dataptr394 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 70
  store i8 97, i8* %dataptr394, align 1
  %dataptr395 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 71
  store i8 100, i8* %dataptr395, align 1
  %dataptr396 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 72
  store i8 47, i8* %dataptr396, align 1
  %dataptr397 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 73
  store i8 116, i8* %dataptr397, align 1
  %dataptr398 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 74
  store i8 114, i8* %dataptr398, align 1
  %dataptr399 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 75
  store i8 117, i8* %dataptr399, align 1
  %dataptr400 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 76
  store i8 101, i8* %dataptr400, align 1
  %dataptr401 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 77
  store i8 110, i8* %dataptr401, align 1
  %dataptr402 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 78
  store i8 117, i8* %dataptr402, align 1
  %dataptr403 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 79
  store i8 108, i8* %dataptr403, align 1
  %dataptr404 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 80
  store i8 108, i8* %dataptr404, align 1
  %dataptr405 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 81
  store i8 46, i8* %dataptr405, align 1
  %dataptr406 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 82
  store i8 106, i8* %dataptr406, align 1
  %dataptr407 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 83
  store i8 115, i8* %dataptr407, align 1
  %dataptr408 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 84
  store i8 111, i8* %dataptr408, align 1
  %dataptr409 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 85
  store i8 110, i8* %dataptr409, align 1
  %dataptr410 = getelementptr inbounds [87 x i8], [87 x i8]* %12, i32 0, i32 86
  store i8 0, i8* %dataptr410, align 1
  %alloc411 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %13 = bitcast i8* %alloc411 to %string*
  %stringleninit412 = getelementptr inbounds %string, %string* %13, i32 0, i32 1
  store i64 86, i64* %stringleninit412, align 4
  %stringdatainit413 = getelementptr inbounds %string, %string* %13, i32 0, i32 0
  %14 = bitcast [87 x i8]* %12 to i8*
  store i8* %14, i8** %stringdatainit413, align 8
  %load414 = load i64, i64* %count, align 4
  %call415 = call %array.int* @stark.functions.main.runTest(%string* %13, i64 %load414)
  %alloc416 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([92 x i8]* getelementptr ([92 x i8], [92 x i8]* null, i32 1) to i64))
  %15 = bitcast i8* %alloc416 to [92 x i8]*
  %dataptr417 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 0
  store i8 104, i8* %dataptr417, align 1
  %dataptr418 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 1
  store i8 116, i8* %dataptr418, align 1
  %dataptr419 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 2
  store i8 116, i8* %dataptr419, align 1
  %dataptr420 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 3
  store i8 112, i8* %dataptr420, align 1
  %dataptr421 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 4
  store i8 115, i8* %dataptr421, align 1
  %dataptr422 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 5
  store i8 58, i8* %dataptr422, align 1
  %dataptr423 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 6
  store i8 47, i8* %dataptr423, align 1
  %dataptr424 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 7
  store i8 47, i8* %dataptr424, align 1
  %dataptr425 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 8
  store i8 114, i8* %dataptr425, align 1
  %dataptr426 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 9
  store i8 97, i8* %dataptr426, align 1
  %dataptr427 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 10
  store i8 119, i8* %dataptr427, align 1
  %dataptr428 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 11
  store i8 46, i8* %dataptr428, align 1
  %dataptr429 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 12
  store i8 103, i8* %dataptr429, align 1
  %dataptr430 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 13
  store i8 105, i8* %dataptr430, align 1
  %dataptr431 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 14
  store i8 116, i8* %dataptr431, align 1
  %dataptr432 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 15
  store i8 104, i8* %dataptr432, align 1
  %dataptr433 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 16
  store i8 117, i8* %dataptr433, align 1
  %dataptr434 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 17
  store i8 98, i8* %dataptr434, align 1
  %dataptr435 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 18
  store i8 117, i8* %dataptr435, align 1
  %dataptr436 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 19
  store i8 115, i8* %dataptr436, align 1
  %dataptr437 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 20
  store i8 101, i8* %dataptr437, align 1
  %dataptr438 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 21
  store i8 114, i8* %dataptr438, align 1
  %dataptr439 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 22
  store i8 99, i8* %dataptr439, align 1
  %dataptr440 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 23
  store i8 111, i8* %dataptr440, align 1
  %dataptr441 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 24
  store i8 110, i8* %dataptr441, align 1
  %dataptr442 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 25
  store i8 116, i8* %dataptr442, align 1
  %dataptr443 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 26
  store i8 101, i8* %dataptr443, align 1
  %dataptr444 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 27
  store i8 110, i8* %dataptr444, align 1
  %dataptr445 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 28
  store i8 116, i8* %dataptr445, align 1
  %dataptr446 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 29
  store i8 46, i8* %dataptr446, align 1
  %dataptr447 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 30
  store i8 99, i8* %dataptr447, align 1
  %dataptr448 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 31
  store i8 111, i8* %dataptr448, align 1
  %dataptr449 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 32
  store i8 109, i8* %dataptr449, align 1
  %dataptr450 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 33
  store i8 47, i8* %dataptr450, align 1
  %dataptr451 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 34
  store i8 97, i8* %dataptr451, align 1
  %dataptr452 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 35
  store i8 109, i8* %dataptr452, align 1
  %dataptr453 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 36
  store i8 97, i8* %dataptr453, align 1
  %dataptr454 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 37
  store i8 109, i8* %dataptr454, align 1
  %dataptr455 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 38
  store i8 99, i8* %dataptr455, align 1
  %dataptr456 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 39
  store i8 104, i8* %dataptr456, align 1
  %dataptr457 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 40
  store i8 117, i8* %dataptr457, align 1
  %dataptr458 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 41
  store i8 114, i8* %dataptr458, align 1
  %dataptr459 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 42
  store i8 47, i8* %dataptr459, align 1
  %dataptr460 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 43
  store i8 105, i8* %dataptr460, align 1
  %dataptr461 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 44
  store i8 74, i8* %dataptr461, align 1
  %dataptr462 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 45
  store i8 83, i8* %dataptr462, align 1
  %dataptr463 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 46
  store i8 79, i8* %dataptr463, align 1
  %dataptr464 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 47
  store i8 78, i8* %dataptr464, align 1
  %dataptr465 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 48
  store i8 66, i8* %dataptr465, align 1
  %dataptr466 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 49
  store i8 101, i8* %dataptr466, align 1
  %dataptr467 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 50
  store i8 110, i8* %dataptr467, align 1
  %dataptr468 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 51
  store i8 99, i8* %dataptr468, align 1
  %dataptr469 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 52
  store i8 104, i8* %dataptr469, align 1
  %dataptr470 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 53
  store i8 109, i8* %dataptr470, align 1
  %dataptr471 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 54
  store i8 97, i8* %dataptr471, align 1
  %dataptr472 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 55
  store i8 114, i8* %dataptr472, align 1
  %dataptr473 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 56
  store i8 107, i8* %dataptr473, align 1
  %dataptr474 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 57
  store i8 47, i8* %dataptr474, align 1
  %dataptr475 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 58
  store i8 109, i8* %dataptr475, align 1
  %dataptr476 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 59
  store i8 97, i8* %dataptr476, align 1
  %dataptr477 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 60
  store i8 115, i8* %dataptr477, align 1
  %dataptr478 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 61
  store i8 116, i8* %dataptr478, align 1
  %dataptr479 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 62
  store i8 101, i8* %dataptr479, align 1
  %dataptr480 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 63
  store i8 114, i8* %dataptr480, align 1
  %dataptr481 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 64
  store i8 47, i8* %dataptr481, align 1
  %dataptr482 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 65
  store i8 112, i8* %dataptr482, align 1
  %dataptr483 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 66
  store i8 97, i8* %dataptr483, align 1
  %dataptr484 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 67
  store i8 121, i8* %dataptr484, align 1
  %dataptr485 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 68
  store i8 108, i8* %dataptr485, align 1
  %dataptr486 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 69
  store i8 111, i8* %dataptr486, align 1
  %dataptr487 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 70
  store i8 97, i8* %dataptr487, align 1
  %dataptr488 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 71
  store i8 100, i8* %dataptr488, align 1
  %dataptr489 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 72
  store i8 47, i8* %dataptr489, align 1
  %dataptr490 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 73
  store i8 97, i8* %dataptr490, align 1
  %dataptr491 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 74
  store i8 112, i8* %dataptr491, align 1
  %dataptr492 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 75
  store i8 97, i8* %dataptr492, align 1
  %dataptr493 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 76
  store i8 99, i8* %dataptr493, align 1
  %dataptr494 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 77
  store i8 104, i8* %dataptr494, align 1
  %dataptr495 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 78
  store i8 101, i8* %dataptr495, align 1
  %dataptr496 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 79
  store i8 95, i8* %dataptr496, align 1
  %dataptr497 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 80
  store i8 98, i8* %dataptr497, align 1
  %dataptr498 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 81
  store i8 117, i8* %dataptr498, align 1
  %dataptr499 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 82
  store i8 105, i8* %dataptr499, align 1
  %dataptr500 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 83
  store i8 108, i8* %dataptr500, align 1
  %dataptr501 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 84
  store i8 100, i8* %dataptr501, align 1
  %dataptr502 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 85
  store i8 115, i8* %dataptr502, align 1
  %dataptr503 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 86
  store i8 46, i8* %dataptr503, align 1
  %dataptr504 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 87
  store i8 106, i8* %dataptr504, align 1
  %dataptr505 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 88
  store i8 115, i8* %dataptr505, align 1
  %dataptr506 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 89
  store i8 111, i8* %dataptr506, align 1
  %dataptr507 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 90
  store i8 110, i8* %dataptr507, align 1
  %dataptr508 = getelementptr inbounds [92 x i8], [92 x i8]* %15, i32 0, i32 91
  store i8 0, i8* %dataptr508, align 1
  %alloc509 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %16 = bitcast i8* %alloc509 to %string*
  %stringleninit510 = getelementptr inbounds %string, %string* %16, i32 0, i32 1
  store i64 91, i64* %stringleninit510, align 4
  %stringdatainit511 = getelementptr inbounds %string, %string* %16, i32 0, i32 0
  %17 = bitcast [92 x i8]* %15 to i8*
  store i8* %17, i8** %stringdatainit511, align 8
  %load512 = load i64, i64* %count, align 4
  %call513 = call %array.int* @stark.functions.main.runTest(%string* %16, i64 %load512)
  ret i64 0
}

declare void @stark_runtime_priv_mm_init()

declare void @GC_enable_incremental()

define %FileResult* @stark.functions.fs.openFile(%string* %name2, %string* %accessMode8) {
entry:
  %name = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %name, align 8
  store %string* %name2, %string** %name, align 8
  %accessMode = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %accessMode, align 8
  store %string* %accessMode8, %string** %accessMode, align 8
  %load = load %string*, %string** %name, align 8
  %call = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load)
  %load9 = load %string*, %string** %accessMode, align 8
  %call10 = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load9)
  %call11 = call i8* @fopen(i8* %call, i8* %call10)
  %fd = alloca i8*, align 8
  store i8* %call11, i8** %fd, align 8
  %error = alloca %string*, align 8
  store %string* null, %string** %error, align 8
  %value = alloca %File*, align 8
  store %File* null, %File** %value, align 8
  %load12 = load i8*, i8** %fd, align 8
  %cmp = icmp eq i8* %load12, null
  br i1 %cmp, label %if, label %else

if:                                               ; preds = %entry
  %alloc13 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([17 x i8]* getelementptr ([17 x i8], [17 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc13 to [17 x i8]*
  %dataptr14 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 0
  store i8 99, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 1
  store i8 97, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 2
  store i8 110, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 3
  store i8 110, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 4
  store i8 111, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 5
  store i8 116, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 6
  store i8 32, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 7
  store i8 111, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 8
  store i8 112, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 9
  store i8 101, i8* %dataptr23, align 1
  %dataptr24 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 10
  store i8 110, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 11
  store i8 32, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 12
  store i8 102, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 13
  store i8 105, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 14
  store i8 108, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 15
  store i8 101, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [17 x i8], [17 x i8]* %6, i32 0, i32 16
  store i8 0, i8* %dataptr30, align 1
  %alloc31 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc31 to %string*
  %stringleninit32 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 16, i64* %stringleninit32, align 4
  %stringdatainit33 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [17 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit33, align 8
  store %string* %7, %string** %error, align 8
  br label %ifcont

else:                                             ; preds = %entry
  %load34 = load i8*, i8** %fd, align 8
  %load35 = load %string*, %string** %name, align 8
  %call36 = call %File* @stark.structs.fs.File.constructor(i8* %load34, %string* %load35)
  store %File* %call36, %File** %value, align 8
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  %load37 = load %File*, %File** %value, align 8
  %load38 = load %string*, %string** %error, align 8
  %call39 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* %load37, %string* %load38)
  ret %FileResult* %call39
}

declare i8* @fopen(i8*, i8*)

define internal %File* @stark.structs.fs.File.constructor(i8* %descriptor, %string* %name) {
entry:
  %descriptor1 = alloca i8*, align 8
  store i8* %descriptor, i8** %descriptor1, align 8
  %name2 = alloca %string*, align 8
  store %string* %name, %string** %name2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%File* getelementptr (%File, %File* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %File*
  %structmemberinit = getelementptr inbounds %File, %File* %0, i32 0, i32 0
  %1 = load i8*, i8** %descriptor1, align 8
  store i8* %1, i8** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %File, %File* %0, i32 0, i32 1
  %2 = load %string*, %string** %name2, align 8
  store %string* %2, %string** %structmemberinit3, align 8
  ret %File* %0
}

define internal %FileResult* @stark.structs.fs.FileResult.constructor(%File* %value, %string* %error) {
entry:
  %value1 = alloca %File*, align 8
  store %File* %value, %File** %value1, align 8
  %error2 = alloca %string*, align 8
  store %string* %error, %string** %error2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%FileResult* getelementptr (%FileResult, %FileResult* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %FileResult*
  %structmemberinit = getelementptr inbounds %FileResult, %FileResult* %0, i32 0, i32 0
  %1 = load %File*, %File** %value1, align 8
  store %File* %1, %File** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %FileResult, %FileResult* %0, i32 0, i32 1
  %2 = load %string*, %string** %error2, align 8
  store %string* %2, %string** %structmemberinit3, align 8
  ret %FileResult* %0
}

define %FileResult* @stark.functions.fs.writeToFile(%File* %file1, %string* %content3) {
entry:
  %file = alloca %File*, align 8
  store %File* null, %File** %file, align 8
  store %File* %file1, %File** %file, align 8
  %content = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc2 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc2 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %content, align 8
  store %string* %content3, %string** %content, align 8
  %error = alloca %string*, align 8
  store %string* null, %string** %error, align 8
  %3 = load %File*, %File** %file, align 8
  %memberptr = getelementptr inbounds %File, %File* %3, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %cmp = icmp eq i8* %load, null
  br i1 %cmp, label %if, label %else

if:                                               ; preds = %entry
  %alloc4 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([19 x i8]* getelementptr ([19 x i8], [19 x i8]* null, i32 1) to i64))
  %4 = bitcast i8* %alloc4 to [19 x i8]*
  %dataptr5 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 0
  store i8 102, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 1
  store i8 105, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 2
  store i8 108, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 3
  store i8 101, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 4
  store i8 32, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 5
  store i8 105, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 6
  store i8 115, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 7
  store i8 32, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 8
  store i8 110, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 9
  store i8 111, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 10
  store i8 116, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 11
  store i8 32, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 12
  store i8 111, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 13
  store i8 112, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 14
  store i8 101, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 15
  store i8 110, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 16
  store i8 101, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 17
  store i8 100, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [19 x i8], [19 x i8]* %4, i32 0, i32 18
  store i8 0, i8* %dataptr23, align 1
  %alloc24 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %5 = bitcast i8* %alloc24 to %string*
  %stringleninit25 = getelementptr inbounds %string, %string* %5, i32 0, i32 1
  store i64 18, i64* %stringleninit25, align 4
  %stringdatainit26 = getelementptr inbounds %string, %string* %5, i32 0, i32 0
  %6 = bitcast [19 x i8]* %4 to i8*
  store i8* %6, i8** %stringdatainit26, align 8
  store %string* %5, %string** %error, align 8
  br label %ifcont

else:                                             ; preds = %entry
  %load27 = load %string*, %string** %content, align 8
  %call = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load27)
  %7 = load %File*, %File** %file, align 8
  %memberptr28 = getelementptr inbounds %File, %File* %7, i32 0, i32 0
  %load29 = load i8*, i8** %memberptr28, align 8
  %call30 = call i64 @fputs(i8* %call, i8* %load29)
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  %load31 = load %File*, %File** %file, align 8
  %load32 = load %string*, %string** %error, align 8
  %call33 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* %load31, %string* %load32)
  ret %FileResult* %call33
}

declare i64 @fputs(i8*, i8*)

define %FileResult* @stark.functions.fs.closeFile(%File* %file1) {
entry:
  %file = alloca %File*, align 8
  store %File* null, %File** %file, align 8
  store %File* %file1, %File** %file, align 8
  %error = alloca %string*, align 8
  store %string* null, %string** %error, align 8
  %0 = load %File*, %File** %file, align 8
  %memberptr = getelementptr inbounds %File, %File* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %cmp = icmp eq i8* %load, null
  br i1 %cmp, label %if, label %else

if:                                               ; preds = %entry
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([19 x i8]* getelementptr ([19 x i8], [19 x i8]* null, i32 1) to i64))
  %1 = bitcast i8* %alloc to [19 x i8]*
  %dataptr = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 0
  store i8 102, i8* %dataptr, align 1
  %dataptr2 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 1
  store i8 105, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 2
  store i8 108, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 3
  store i8 101, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 4
  store i8 32, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 5
  store i8 105, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 6
  store i8 115, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 7
  store i8 32, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 8
  store i8 110, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 9
  store i8 111, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 10
  store i8 116, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 11
  store i8 32, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 12
  store i8 111, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 13
  store i8 112, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 14
  store i8 101, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 15
  store i8 110, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 16
  store i8 101, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 17
  store i8 100, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [19 x i8], [19 x i8]* %1, i32 0, i32 18
  store i8 0, i8* %dataptr19, align 1
  %alloc20 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %2 = bitcast i8* %alloc20 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %2, i32 0, i32 1
  store i64 18, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %2, i32 0, i32 0
  %3 = bitcast [19 x i8]* %1 to i8*
  store i8* %3, i8** %stringdatainit, align 8
  store %string* %2, %string** %error, align 8
  br label %ifcont50

else:                                             ; preds = %entry
  %4 = load %File*, %File** %file, align 8
  %memberptr21 = getelementptr inbounds %File, %File* %4, i32 0, i32 0
  %load22 = load i8*, i8** %memberptr21, align 8
  %call = call i64 @fclose(i8* %load22)
  %closeRes = alloca i64, align 8
  store i64 %call, i64* %closeRes, align 4
  %load23 = load i64, i64* %closeRes, align 4
  %cmp24 = icmp ne i64 %load23, 0
  br i1 %cmp24, label %if25, label %else48

if25:                                             ; preds = %else
  %alloc26 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([18 x i8]* getelementptr ([18 x i8], [18 x i8]* null, i32 1) to i64))
  %5 = bitcast i8* %alloc26 to [18 x i8]*
  %dataptr27 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 0
  store i8 99, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 1
  store i8 97, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 2
  store i8 110, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 3
  store i8 110, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 4
  store i8 111, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 5
  store i8 116, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 6
  store i8 32, i8* %dataptr33, align 1
  %dataptr34 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 7
  store i8 99, i8* %dataptr34, align 1
  %dataptr35 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 8
  store i8 108, i8* %dataptr35, align 1
  %dataptr36 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 9
  store i8 111, i8* %dataptr36, align 1
  %dataptr37 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 10
  store i8 115, i8* %dataptr37, align 1
  %dataptr38 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 11
  store i8 101, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 12
  store i8 32, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 13
  store i8 102, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 14
  store i8 105, i8* %dataptr41, align 1
  %dataptr42 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 15
  store i8 108, i8* %dataptr42, align 1
  %dataptr43 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 16
  store i8 101, i8* %dataptr43, align 1
  %dataptr44 = getelementptr inbounds [18 x i8], [18 x i8]* %5, i32 0, i32 17
  store i8 0, i8* %dataptr44, align 1
  %alloc45 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %6 = bitcast i8* %alloc45 to %string*
  %stringleninit46 = getelementptr inbounds %string, %string* %6, i32 0, i32 1
  store i64 17, i64* %stringleninit46, align 4
  %stringdatainit47 = getelementptr inbounds %string, %string* %6, i32 0, i32 0
  %7 = bitcast [18 x i8]* %5 to i8*
  store i8* %7, i8** %stringdatainit47, align 8
  store %string* %6, %string** %error, align 8
  br label %ifcont

else48:                                           ; preds = %else
  %8 = load %File*, %File** %file, align 8
  %memberptr49 = getelementptr inbounds %File, %File* %8, i32 0, i32 0
  store i8* null, i8** %memberptr49, align 8
  br label %ifcont

ifcont:                                           ; preds = %else48, %if25
  br label %ifcont50

ifcont50:                                         ; preds = %ifcont, %if
  %load51 = load %File*, %File** %file, align 8
  %load52 = load %string*, %string** %error, align 8
  %call53 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* %load51, %string* %load52)
  ret %FileResult* %call53
}

declare i64 @fclose(i8*)

define i1 @stark.functions.fs.deleteFile(%string* %filename2) {
entry:
  %filename = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %filename, align 8
  store %string* %filename2, %string** %filename, align 8
  %load = load %string*, %string** %filename, align 8
  %call = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load)
  %call3 = call i1 @remove(i8* %call)
  ret i1 %call3
}

declare i1 @remove(i8*)

define %FileResult* @stark.functions.fs.createDirectory(%string* %path2) {
entry:
  %path = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %path, align 8
  store %string* %path2, %string** %path, align 8
  %error = alloca %string*, align 8
  store %string* null, %string** %error, align 8
  %load = load %string*, %string** %path, align 8
  %call = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load)
  %call3 = call i64 @mkdir(i8* %call, i64 9223372036854775807)
  %cmp = icmp ne i64 %call3, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %alloc4 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([26 x i8]* getelementptr ([26 x i8], [26 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc4 to [26 x i8]*
  %dataptr5 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 0
  store i8 68, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 1
  store i8 105, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 2
  store i8 114, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 3
  store i8 101, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 4
  store i8 99, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 5
  store i8 116, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 6
  store i8 111, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 7
  store i8 114, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 8
  store i8 121, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 9
  store i8 32, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 10
  store i8 99, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 11
  store i8 114, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 12
  store i8 101, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 13
  store i8 97, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 14
  store i8 116, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 15
  store i8 105, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 16
  store i8 111, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 17
  store i8 110, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 18
  store i8 32, i8* %dataptr23, align 1
  %dataptr24 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 19
  store i8 102, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 20
  store i8 97, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 21
  store i8 105, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 22
  store i8 108, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 23
  store i8 101, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 24
  store i8 100, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [26 x i8], [26 x i8]* %3, i32 0, i32 25
  store i8 0, i8* %dataptr30, align 1
  %alloc31 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc31 to %string*
  %stringleninit32 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 25, i64* %stringleninit32, align 4
  %stringdatainit33 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [26 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit33, align 8
  store %string* %4, %string** %error, align 8
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  %load34 = load %string*, %string** %error, align 8
  %call35 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* null, %string* %load34)
  ret %FileResult* %call35
}

declare i64 @mkdir(i8*, i64)

define i1 @stark.functions.fs.fileExists(%string* %filename2) {
entry:
  %filename = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %filename, align 8
  store %string* %filename2, %string** %filename, align 8
  %load = load %string*, %string** %filename, align 8
  %call = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load)
  %call3 = call i1 @access(i8* %call, i64 0)
  %cmp = icmp eq i1 %call3, false
  ret i1 %cmp
}

declare i1 @access(i8*, i64)

define i1 @stark.functions.fs.fileIsEOF(%File* %file1) {
entry:
  %file = alloca %File*, align 8
  store %File* null, %File** %file, align 8
  store %File* %file1, %File** %file, align 8
  %0 = load %File*, %File** %file, align 8
  %memberptr = getelementptr inbounds %File, %File* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %call = call i1 @feof(i8* %load)
  ret i1 %call
}

declare i1 @feof(i8*)

define %FileResult* @stark.functions.fs.writeFileWithContent(%string* %filename2, %string* %content8) {
entry:
  %filename = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %filename, align 8
  store %string* %filename2, %string** %filename, align 8
  %content = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %content, align 8
  store %string* %content8, %string** %content, align 8
  %load = load %string*, %string** %filename, align 8
  %alloc9 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc9 to [2 x i8]*
  %dataptr10 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 0
  store i8 119, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [2 x i8], [2 x i8]* %6, i32 0, i32 1
  store i8 0, i8* %dataptr11, align 1
  %alloc12 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc12 to %string*
  %stringleninit13 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 1, i64* %stringleninit13, align 4
  %stringdatainit14 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [2 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit14, align 8
  %call = call %FileResult* @stark.functions.fs.openFile(%string* %load, %string* %7)
  %fr = alloca %FileResult*, align 8
  store %FileResult* %call, %FileResult** %fr, align 8
  %9 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr = getelementptr inbounds %FileResult, %FileResult* %9, i32 0, i32 1
  %load15 = load %string*, %string** %memberptr, align 8
  %10 = ptrtoint %string* %load15 to i64
  %cmp = icmp ne i64 %10, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %11 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr16 = getelementptr inbounds %FileResult, %FileResult* %11, i32 0, i32 1
  %load17 = load %string*, %string** %memberptr16, align 8
  %call18 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* null, %string* %load17)
  ret %FileResult* %call18

ifcont:                                           ; preds = %entry
  %12 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr19 = getelementptr inbounds %FileResult, %FileResult* %12, i32 0, i32 0
  %load20 = load %File*, %File** %memberptr19, align 8
  %load21 = load %string*, %string** %content, align 8
  %call22 = call %FileResult* @stark.functions.fs.writeToFile(%File* %load20, %string* %load21)
  store %FileResult* %call22, %FileResult** %fr, align 8
  %13 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr23 = getelementptr inbounds %FileResult, %FileResult* %13, i32 0, i32 1
  %load24 = load %string*, %string** %memberptr23, align 8
  %14 = ptrtoint %string* %load24 to i64
  %cmp25 = icmp ne i64 %14, 0
  br i1 %cmp25, label %if26, label %ifcont30

if26:                                             ; preds = %ifcont
  %15 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr27 = getelementptr inbounds %FileResult, %FileResult* %15, i32 0, i32 1
  %load28 = load %string*, %string** %memberptr27, align 8
  %call29 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* null, %string* %load28)
  ret %FileResult* %call29

ifcont30:                                         ; preds = %ifcont
  %16 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr31 = getelementptr inbounds %FileResult, %FileResult* %16, i32 0, i32 0
  %load32 = load %File*, %File** %memberptr31, align 8
  %call33 = call %FileResult* @stark.functions.fs.closeFile(%File* %load32)
  store %FileResult* %call33, %FileResult** %fr, align 8
  %17 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr34 = getelementptr inbounds %FileResult, %FileResult* %17, i32 0, i32 1
  %load35 = load %string*, %string** %memberptr34, align 8
  %18 = ptrtoint %string* %load35 to i64
  %cmp36 = icmp ne i64 %18, 0
  br i1 %cmp36, label %if37, label %ifcont41

if37:                                             ; preds = %ifcont30
  %19 = load %FileResult*, %FileResult** %fr, align 8
  %memberptr38 = getelementptr inbounds %FileResult, %FileResult* %19, i32 0, i32 1
  %load39 = load %string*, %string** %memberptr38, align 8
  %call40 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* null, %string* %load39)
  ret %FileResult* %call40

ifcont41:                                         ; preds = %ifcont30
  %call42 = call %FileResult* @stark.structs.fs.FileResult.constructor(%File* null, %string* null)
  ret %FileResult* %call42
}

define %HttpResult* @stark.functions.http.downloadFile(%string* %url2, %fs.File* %file3) {
entry:
  %url = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %url, align 8
  store %string* %url2, %string** %url, align 8
  %file = alloca %fs.File*, align 8
  store %fs.File* null, %fs.File** %file, align 8
  store %fs.File* %file3, %fs.File** %file, align 8
  %call = call %HttpResult* @stark.structs.http.HttpResult.constructor(%string* null)
  %result = alloca %HttpResult*, align 8
  store %HttpResult* %call, %HttpResult** %result, align 8
  %call4 = call i8* @curl_easy_init()
  %session = alloca i8*, align 8
  store i8* %call4, i8** %session, align 8
  %load = load i8*, i8** %session, align 8
  %load5 = load %string*, %string** %url, align 8
  %call6 = call i8* bitcast (i8* (%string*)* @stark_runtime_pub_toCString to i8* (%string*)*)(%string* %load5)
  call void @curl_easy_setopt(i8* %load, i64 10002, i8* %call6)
  %load7 = load i8*, i8** %session, align 8
  %3 = load %fs.File*, %fs.File** %file, align 8
  %memberptr = getelementptr inbounds %fs.File, %fs.File* %3, i32 0, i32 0
  %load8 = load i8*, i8** %memberptr, align 8
  call void @curl_easy_setopt(i8* %load7, i64 10001, i8* %load8)
  %load9 = load i8*, i8** %session, align 8
  %call10 = call i64 @curl_easy_perform(i8* %load9)
  %res = alloca i64, align 8
  store i64 %call10, i64* %res, align 4
  %load11 = load i64, i64* %res, align 4
  %cmp = icmp sgt i64 %load11, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %load12 = load i64, i64* %res, align 4
  %call13 = call i8* @curl_easy_strerror(i64 %load12)
  %call14 = call %string* bitcast (%string* (i8*)* @stark_runtime_pub_fromCString to %string* (i8*)*)(i8* %call13)
  %4 = load %HttpResult*, %HttpResult** %result, align 8
  %memberptr15 = getelementptr inbounds %HttpResult, %HttpResult* %4, i32 0, i32 0
  store %string* %call14, %string** %memberptr15, align 8
  br label %ifcont

ifcont:                                           ; preds = %if, %entry
  %load16 = load i8*, i8** %session, align 8
  call void @curl_easy_cleanup(i8* %load16)
  %load17 = load %HttpResult*, %HttpResult** %result, align 8
  ret %HttpResult* %load17
}

define internal %HttpResult* @stark.structs.http.HttpResult.constructor(%string* %error) {
entry:
  %error1 = alloca %string*, align 8
  store %string* %error, %string** %error1, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%HttpResult* getelementptr (%HttpResult, %HttpResult* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %HttpResult*
  %structmemberinit = getelementptr inbounds %HttpResult, %HttpResult* %0, i32 0, i32 0
  %1 = load %string*, %string** %error1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  ret %HttpResult* %0
}

declare i8* @curl_easy_init()

declare void @curl_easy_setopt(i8*, i64, i8*)

declare i64 @curl_easy_perform(i8*)

declare i8* @curl_easy_strerror(i64)

declare void @curl_easy_cleanup(i8*)

define %JSONResult* @stark.functions.json.parse(%string* %value2) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %call = call %JSONResult* @stark.structs.json.JSONResult.constructor(%JSONValue* null, %string* null)
  %result = alloca %JSONResult*, align 8
  store %JSONResult* %call, %JSONResult** %result, align 8
  %load = load %string*, %string** %value, align 8
  %call3 = call %string* bitcast (%string* (%string*)* @stark.functions.str.trim to %string* (%string*)*)(%string* %load)
  %cleanedValue = alloca %string*, align 8
  store %string* %call3, %string** %cleanedValue, align 8
  %load4 = load %string*, %string** %cleanedValue, align 8
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([5 x i8]* getelementptr ([5 x i8], [5 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc5 to [5 x i8]*
  %dataptr6 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i32 0, i32 0
  store i8 110, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i32 0, i32 1
  store i8 117, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i32 0, i32 2
  store i8 108, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i32 0, i32 3
  store i8 108, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [5 x i8], [5 x i8]* %3, i32 0, i32 4
  store i8 0, i8* %dataptr10, align 1
  %alloc11 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc11 to %string*
  %stringleninit12 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 4, i64* %stringleninit12, align 4
  %stringdatainit13 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [5 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit13, align 8
  %comp = call i1 @stark_runtime_priv_eq_string(%string* %load4, %string* %4)
  br i1 %comp, label %if, label %ifcont

if:                                               ; preds = %entry
  %alloc14 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([5 x i8]* getelementptr ([5 x i8], [5 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc14 to [5 x i8]*
  %dataptr15 = getelementptr inbounds [5 x i8], [5 x i8]* %6, i32 0, i32 0
  store i8 110, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [5 x i8], [5 x i8]* %6, i32 0, i32 1
  store i8 117, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [5 x i8], [5 x i8]* %6, i32 0, i32 2
  store i8 108, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [5 x i8], [5 x i8]* %6, i32 0, i32 3
  store i8 108, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [5 x i8], [5 x i8]* %6, i32 0, i32 4
  store i8 0, i8* %dataptr19, align 1
  %alloc20 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc20 to %string*
  %stringleninit21 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 4, i64* %stringleninit21, align 4
  %stringdatainit22 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [5 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit22, align 8
  %call23 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %7, %string* null, i64 0, double 0.000000e+00, i1 false, %array.JSONValue* null, %array.JSONProperty* null)
  %9 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr = getelementptr inbounds %JSONResult, %JSONResult* %9, i32 0, i32 0
  store %JSONValue* %call23, %JSONValue** %memberptr, align 8
  %load24 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load24

ifcont:                                           ; preds = %entry
  %load25 = load %string*, %string** %cleanedValue, align 8
  %alloc26 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([5 x i8]* getelementptr ([5 x i8], [5 x i8]* null, i32 1) to i64))
  %10 = bitcast i8* %alloc26 to [5 x i8]*
  %dataptr27 = getelementptr inbounds [5 x i8], [5 x i8]* %10, i32 0, i32 0
  store i8 116, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [5 x i8], [5 x i8]* %10, i32 0, i32 1
  store i8 114, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [5 x i8], [5 x i8]* %10, i32 0, i32 2
  store i8 117, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [5 x i8], [5 x i8]* %10, i32 0, i32 3
  store i8 101, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [5 x i8], [5 x i8]* %10, i32 0, i32 4
  store i8 0, i8* %dataptr31, align 1
  %alloc32 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %11 = bitcast i8* %alloc32 to %string*
  %stringleninit33 = getelementptr inbounds %string, %string* %11, i32 0, i32 1
  store i64 4, i64* %stringleninit33, align 4
  %stringdatainit34 = getelementptr inbounds %string, %string* %11, i32 0, i32 0
  %12 = bitcast [5 x i8]* %10 to i8*
  store i8* %12, i8** %stringdatainit34, align 8
  %comp35 = call i1 @stark_runtime_priv_eq_string(%string* %load25, %string* %11)
  %load36 = load %string*, %string** %cleanedValue, align 8
  %alloc37 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([6 x i8]* getelementptr ([6 x i8], [6 x i8]* null, i32 1) to i64))
  %13 = bitcast i8* %alloc37 to [6 x i8]*
  %dataptr38 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 0
  store i8 102, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 1
  store i8 97, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 2
  store i8 108, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 3
  store i8 115, i8* %dataptr41, align 1
  %dataptr42 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 4
  store i8 101, i8* %dataptr42, align 1
  %dataptr43 = getelementptr inbounds [6 x i8], [6 x i8]* %13, i32 0, i32 5
  store i8 0, i8* %dataptr43, align 1
  %alloc44 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %14 = bitcast i8* %alloc44 to %string*
  %stringleninit45 = getelementptr inbounds %string, %string* %14, i32 0, i32 1
  store i64 5, i64* %stringleninit45, align 4
  %stringdatainit46 = getelementptr inbounds %string, %string* %14, i32 0, i32 0
  %15 = bitcast [6 x i8]* %13 to i8*
  store i8* %15, i8** %stringdatainit46, align 8
  %comp47 = call i1 @stark_runtime_priv_eq_string(%string* %load36, %string* %14)
  %binop = or i1 %comp35, %comp47
  br i1 %binop, label %if48, label %ifcont62

if48:                                             ; preds = %ifcont
  %alloc49 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([5 x i8]* getelementptr ([5 x i8], [5 x i8]* null, i32 1) to i64))
  %16 = bitcast i8* %alloc49 to [5 x i8]*
  %dataptr50 = getelementptr inbounds [5 x i8], [5 x i8]* %16, i32 0, i32 0
  store i8 98, i8* %dataptr50, align 1
  %dataptr51 = getelementptr inbounds [5 x i8], [5 x i8]* %16, i32 0, i32 1
  store i8 111, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [5 x i8], [5 x i8]* %16, i32 0, i32 2
  store i8 111, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [5 x i8], [5 x i8]* %16, i32 0, i32 3
  store i8 108, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [5 x i8], [5 x i8]* %16, i32 0, i32 4
  store i8 0, i8* %dataptr54, align 1
  %alloc55 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %17 = bitcast i8* %alloc55 to %string*
  %stringleninit56 = getelementptr inbounds %string, %string* %17, i32 0, i32 1
  store i64 4, i64* %stringleninit56, align 4
  %stringdatainit57 = getelementptr inbounds %string, %string* %17, i32 0, i32 0
  %18 = bitcast [5 x i8]* %16 to i8*
  store i8* %18, i8** %stringdatainit57, align 8
  %load58 = load %string*, %string** %cleanedValue, align 8
  %conv = call i1 @stark_runtime_priv_conv_string_bool(%string* %load58)
  %call59 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %17, %string* null, i64 0, double 0.000000e+00, i1 %conv, %array.JSONValue* null, %array.JSONProperty* null)
  %19 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr60 = getelementptr inbounds %JSONResult, %JSONResult* %19, i32 0, i32 0
  store %JSONValue* %call59, %JSONValue** %memberptr60, align 8
  %load61 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load61

ifcont62:                                         ; preds = %ifcont
  %load63 = load %string*, %string** %cleanedValue, align 8
  %conv64 = call double @stark_runtime_priv_conv_string_double(%string* %load63)
  %doubleValue = alloca double, align 8
  store double %conv64, double* %doubleValue, align 8
  %load65 = load %string*, %string** %cleanedValue, align 8
  %conv66 = call i64 @stark_runtime_priv_conv_string_int(%string* %load65)
  %intValue = alloca i64, align 8
  store i64 %conv66, i64* %intValue, align 4
  %isDouble = alloca i1, align 1
  store i1 false, i1* %isDouble, align 1
  %load67 = load %string*, %string** %cleanedValue, align 8
  %alloc68 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %20 = bitcast i8* %alloc68 to [2 x i8]*
  %dataptr69 = getelementptr inbounds [2 x i8], [2 x i8]* %20, i32 0, i32 0
  store i8 48, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [2 x i8], [2 x i8]* %20, i32 0, i32 1
  store i8 0, i8* %dataptr70, align 1
  %alloc71 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %21 = bitcast i8* %alloc71 to %string*
  %stringleninit72 = getelementptr inbounds %string, %string* %21, i32 0, i32 1
  store i64 1, i64* %stringleninit72, align 4
  %stringdatainit73 = getelementptr inbounds %string, %string* %21, i32 0, i32 0
  %22 = bitcast [2 x i8]* %20 to i8*
  store i8* %22, i8** %stringdatainit73, align 8
  %call74 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.startsWith to i1 (%string*, %string*)*)(%string* %load67, %string* %21)
  %load75 = load %string*, %string** %cleanedValue, align 8
  %alloc76 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %23 = bitcast i8* %alloc76 to [3 x i8]*
  %dataptr77 = getelementptr inbounds [3 x i8], [3 x i8]* %23, i32 0, i32 0
  store i8 45, i8* %dataptr77, align 1
  %dataptr78 = getelementptr inbounds [3 x i8], [3 x i8]* %23, i32 0, i32 1
  store i8 48, i8* %dataptr78, align 1
  %dataptr79 = getelementptr inbounds [3 x i8], [3 x i8]* %23, i32 0, i32 2
  store i8 0, i8* %dataptr79, align 1
  %alloc80 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %24 = bitcast i8* %alloc80 to %string*
  %stringleninit81 = getelementptr inbounds %string, %string* %24, i32 0, i32 1
  store i64 2, i64* %stringleninit81, align 4
  %stringdatainit82 = getelementptr inbounds %string, %string* %24, i32 0, i32 0
  %25 = bitcast [3 x i8]* %23 to i8*
  store i8* %25, i8** %stringdatainit82, align 8
  %call83 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.startsWith to i1 (%string*, %string*)*)(%string* %load75, %string* %24)
  %binop84 = or i1 %call74, %call83
  %load85 = load i64, i64* %intValue, align 4
  %cmp = icmp ne i64 %load85, 0
  %binop86 = or i1 %binop84, %cmp
  br i1 %binop86, label %if87, label %ifcont118

if87:                                             ; preds = %ifcont62
  %load88 = load %string*, %string** %cleanedValue, align 8
  %alloc89 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %26 = bitcast i8* %alloc89 to [2 x i8]*
  %dataptr90 = getelementptr inbounds [2 x i8], [2 x i8]* %26, i32 0, i32 0
  store i8 46, i8* %dataptr90, align 1
  %dataptr91 = getelementptr inbounds [2 x i8], [2 x i8]* %26, i32 0, i32 1
  store i8 0, i8* %dataptr91, align 1
  %alloc92 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %27 = bitcast i8* %alloc92 to %string*
  %stringleninit93 = getelementptr inbounds %string, %string* %27, i32 0, i32 1
  store i64 1, i64* %stringleninit93, align 4
  %stringdatainit94 = getelementptr inbounds %string, %string* %27, i32 0, i32 0
  %28 = bitcast [2 x i8]* %26 to i8*
  store i8* %28, i8** %stringdatainit94, align 8
  %call95 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.contains to i1 (%string*, %string*)*)(%string* %load88, %string* %27)
  br i1 %call95, label %if96, label %ifcont117

if96:                                             ; preds = %if87
  %load97 = load double, double* %doubleValue, align 8
  %cmp98 = fcmp one double %load97, 0.000000e+00
  br i1 %cmp98, label %if99, label %else

if99:                                             ; preds = %if96
  store i1 true, i1* %isDouble, align 1
  br label %ifcont116

else:                                             ; preds = %if96
  %load100 = load %string*, %string** %cleanedValue, align 8
  %alloc101 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %29 = bitcast i8* %alloc101 to [2 x i8]*
  %dataptr102 = getelementptr inbounds [2 x i8], [2 x i8]* %29, i32 0, i32 0
  store i8 48, i8* %dataptr102, align 1
  %dataptr103 = getelementptr inbounds [2 x i8], [2 x i8]* %29, i32 0, i32 1
  store i8 0, i8* %dataptr103, align 1
  %alloc104 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %30 = bitcast i8* %alloc104 to %string*
  %stringleninit105 = getelementptr inbounds %string, %string* %30, i32 0, i32 1
  store i64 1, i64* %stringleninit105, align 4
  %stringdatainit106 = getelementptr inbounds %string, %string* %30, i32 0, i32 0
  %31 = bitcast [2 x i8]* %29 to i8*
  store i8* %31, i8** %stringdatainit106, align 8
  %alloc107 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %32 = bitcast i8* %alloc107 to [1 x i8]*
  %dataptr108 = getelementptr inbounds [1 x i8], [1 x i8]* %32, i32 0, i32 0
  store i8 0, i8* %dataptr108, align 1
  %alloc109 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %33 = bitcast i8* %alloc109 to %string*
  %stringleninit110 = getelementptr inbounds %string, %string* %33, i32 0, i32 1
  store i64 0, i64* %stringleninit110, align 4
  %stringdatainit111 = getelementptr inbounds %string, %string* %33, i32 0, i32 0
  %34 = bitcast [1 x i8]* %32 to i8*
  store i8* %34, i8** %stringdatainit111, align 8
  %call112 = call %string* bitcast (%string* (%string*, %string*, %string*)* @stark.functions.str.replace to %string* (%string*, %string*, %string*)*)(%string* %load100, %string* %30, %string* %33)
  %test = alloca %string*, align 8
  store %string* %call112, %string** %test, align 8
  %35 = load %string*, %string** %test, align 8
  %memberptr113 = getelementptr inbounds %string, %string* %35, i32 0, i32 1
  %load114 = load i64, i64* %memberptr113, align 4
  %cmp115 = icmp eq i64 %load114, 1
  store i1 %cmp115, i1* %isDouble, align 1
  br label %ifcont116

ifcont116:                                        ; preds = %else, %if99
  br label %ifcont117

ifcont117:                                        ; preds = %ifcont116, %if87
  br label %ifcont118

ifcont118:                                        ; preds = %ifcont117, %ifcont62
  %load119 = load i1, i1* %isDouble, align 1
  br i1 %load119, label %if120, label %else136

if120:                                            ; preds = %ifcont118
  %alloc121 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([7 x i8]* getelementptr ([7 x i8], [7 x i8]* null, i32 1) to i64))
  %36 = bitcast i8* %alloc121 to [7 x i8]*
  %dataptr122 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 0
  store i8 100, i8* %dataptr122, align 1
  %dataptr123 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 1
  store i8 111, i8* %dataptr123, align 1
  %dataptr124 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 2
  store i8 117, i8* %dataptr124, align 1
  %dataptr125 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 3
  store i8 98, i8* %dataptr125, align 1
  %dataptr126 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 4
  store i8 108, i8* %dataptr126, align 1
  %dataptr127 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 5
  store i8 101, i8* %dataptr127, align 1
  %dataptr128 = getelementptr inbounds [7 x i8], [7 x i8]* %36, i32 0, i32 6
  store i8 0, i8* %dataptr128, align 1
  %alloc129 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %37 = bitcast i8* %alloc129 to %string*
  %stringleninit130 = getelementptr inbounds %string, %string* %37, i32 0, i32 1
  store i64 6, i64* %stringleninit130, align 4
  %stringdatainit131 = getelementptr inbounds %string, %string* %37, i32 0, i32 0
  %38 = bitcast [7 x i8]* %36 to i8*
  store i8* %38, i8** %stringdatainit131, align 8
  %load132 = load double, double* %doubleValue, align 8
  %call133 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %37, %string* null, i64 0, double %load132, i1 false, %array.JSONValue* null, %array.JSONProperty* null)
  %39 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr134 = getelementptr inbounds %JSONResult, %JSONResult* %39, i32 0, i32 0
  store %JSONValue* %call133, %JSONValue** %memberptr134, align 8
  %load135 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load135

else136:                                          ; preds = %ifcont118
  %load137 = load i64, i64* %intValue, align 4
  %cmp138 = icmp ne i64 %load137, 0
  %load139 = load %string*, %string** %cleanedValue, align 8
  %alloc140 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %40 = bitcast i8* %alloc140 to [2 x i8]*
  %dataptr141 = getelementptr inbounds [2 x i8], [2 x i8]* %40, i32 0, i32 0
  store i8 48, i8* %dataptr141, align 1
  %dataptr142 = getelementptr inbounds [2 x i8], [2 x i8]* %40, i32 0, i32 1
  store i8 0, i8* %dataptr142, align 1
  %alloc143 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %41 = bitcast i8* %alloc143 to %string*
  %stringleninit144 = getelementptr inbounds %string, %string* %41, i32 0, i32 1
  store i64 1, i64* %stringleninit144, align 4
  %stringdatainit145 = getelementptr inbounds %string, %string* %41, i32 0, i32 0
  %42 = bitcast [2 x i8]* %40 to i8*
  store i8* %42, i8** %stringdatainit145, align 8
  %comp146 = call i1 @stark_runtime_priv_eq_string(%string* %load139, %string* %41)
  %binop147 = or i1 %cmp138, %comp146
  br i1 %binop147, label %if148, label %ifcont161

if148:                                            ; preds = %else136
  %alloc149 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([4 x i8]* getelementptr ([4 x i8], [4 x i8]* null, i32 1) to i64))
  %43 = bitcast i8* %alloc149 to [4 x i8]*
  %dataptr150 = getelementptr inbounds [4 x i8], [4 x i8]* %43, i32 0, i32 0
  store i8 105, i8* %dataptr150, align 1
  %dataptr151 = getelementptr inbounds [4 x i8], [4 x i8]* %43, i32 0, i32 1
  store i8 110, i8* %dataptr151, align 1
  %dataptr152 = getelementptr inbounds [4 x i8], [4 x i8]* %43, i32 0, i32 2
  store i8 116, i8* %dataptr152, align 1
  %dataptr153 = getelementptr inbounds [4 x i8], [4 x i8]* %43, i32 0, i32 3
  store i8 0, i8* %dataptr153, align 1
  %alloc154 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %44 = bitcast i8* %alloc154 to %string*
  %stringleninit155 = getelementptr inbounds %string, %string* %44, i32 0, i32 1
  store i64 3, i64* %stringleninit155, align 4
  %stringdatainit156 = getelementptr inbounds %string, %string* %44, i32 0, i32 0
  %45 = bitcast [4 x i8]* %43 to i8*
  store i8* %45, i8** %stringdatainit156, align 8
  %load157 = load i64, i64* %intValue, align 4
  %call158 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %44, %string* null, i64 %load157, double 0.000000e+00, i1 false, %array.JSONValue* null, %array.JSONProperty* null)
  %46 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr159 = getelementptr inbounds %JSONResult, %JSONResult* %46, i32 0, i32 0
  store %JSONValue* %call158, %JSONValue** %memberptr159, align 8
  %load160 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load160

ifcont161:                                        ; preds = %else136
  br label %ifcont162

ifcont162:                                        ; preds = %ifcont161
  %load163 = load %string*, %string** %cleanedValue, align 8
  %alloc164 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %47 = bitcast i8* %alloc164 to [2 x i8]*
  %dataptr165 = getelementptr inbounds [2 x i8], [2 x i8]* %47, i32 0, i32 0
  store i8 34, i8* %dataptr165, align 1
  %dataptr166 = getelementptr inbounds [2 x i8], [2 x i8]* %47, i32 0, i32 1
  store i8 0, i8* %dataptr166, align 1
  %alloc167 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %48 = bitcast i8* %alloc167 to %string*
  %stringleninit168 = getelementptr inbounds %string, %string* %48, i32 0, i32 1
  store i64 1, i64* %stringleninit168, align 4
  %stringdatainit169 = getelementptr inbounds %string, %string* %48, i32 0, i32 0
  %49 = bitcast [2 x i8]* %47 to i8*
  store i8* %49, i8** %stringdatainit169, align 8
  %call170 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.startsWith to i1 (%string*, %string*)*)(%string* %load163, %string* %48)
  %load171 = load %string*, %string** %cleanedValue, align 8
  %alloc172 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %50 = bitcast i8* %alloc172 to [2 x i8]*
  %dataptr173 = getelementptr inbounds [2 x i8], [2 x i8]* %50, i32 0, i32 0
  store i8 34, i8* %dataptr173, align 1
  %dataptr174 = getelementptr inbounds [2 x i8], [2 x i8]* %50, i32 0, i32 1
  store i8 0, i8* %dataptr174, align 1
  %alloc175 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %51 = bitcast i8* %alloc175 to %string*
  %stringleninit176 = getelementptr inbounds %string, %string* %51, i32 0, i32 1
  store i64 1, i64* %stringleninit176, align 4
  %stringdatainit177 = getelementptr inbounds %string, %string* %51, i32 0, i32 0
  %52 = bitcast [2 x i8]* %50 to i8*
  store i8* %52, i8** %stringdatainit177, align 8
  %call178 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.endsWith to i1 (%string*, %string*)*)(%string* %load171, %string* %51)
  %binop179 = and i1 %call170, %call178
  br i1 %binop179, label %if180, label %ifcont256

if180:                                            ; preds = %ifcont162
  %alloc181 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %53 = bitcast i8* %alloc181 to [1 x i8]*
  %dataptr182 = getelementptr inbounds [1 x i8], [1 x i8]* %53, i32 0, i32 0
  store i8 0, i8* %dataptr182, align 1
  %alloc183 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %54 = bitcast i8* %alloc183 to %string*
  %stringleninit184 = getelementptr inbounds %string, %string* %54, i32 0, i32 1
  store i64 0, i64* %stringleninit184, align 4
  %stringdatainit185 = getelementptr inbounds %string, %string* %54, i32 0, i32 0
  %55 = bitcast [1 x i8]* %53 to i8*
  store i8* %55, i8** %stringdatainit185, align 8
  %stringValue = alloca %string*, align 8
  store %string* %54, %string** %stringValue, align 8
  %56 = load %string*, %string** %cleanedValue, align 8
  %memberptr186 = getelementptr inbounds %string, %string* %56, i32 0, i32 1
  %load187 = load i64, i64* %memberptr186, align 4
  %cmp188 = icmp sgt i64 %load187, 0
  br i1 %cmp188, label %if189, label %ifcont240

if189:                                            ; preds = %if180
  %load190 = load %string*, %string** %cleanedValue, align 8
  %57 = load %string*, %string** %cleanedValue, align 8
  %memberptr191 = getelementptr inbounds %string, %string* %57, i32 0, i32 1
  %load192 = load i64, i64* %memberptr191, align 4
  %binop193 = sub i64 %load192, 1
  %call194 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.subString to %string* (%string*, i64, i64)*)(%string* %load190, i64 1, i64 %binop193)
  store %string* %call194, %string** %stringValue, align 8
  %load195 = load %string*, %string** %stringValue, align 8
  %alloc196 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %58 = bitcast i8* %alloc196 to [3 x i8]*
  %dataptr197 = getelementptr inbounds [3 x i8], [3 x i8]* %58, i32 0, i32 0
  store i8 92, i8* %dataptr197, align 1
  %dataptr198 = getelementptr inbounds [3 x i8], [3 x i8]* %58, i32 0, i32 1
  store i8 13, i8* %dataptr198, align 1
  %dataptr199 = getelementptr inbounds [3 x i8], [3 x i8]* %58, i32 0, i32 2
  store i8 0, i8* %dataptr199, align 1
  %alloc200 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %59 = bitcast i8* %alloc200 to %string*
  %stringleninit201 = getelementptr inbounds %string, %string* %59, i32 0, i32 1
  store i64 2, i64* %stringleninit201, align 4
  %stringdatainit202 = getelementptr inbounds %string, %string* %59, i32 0, i32 0
  %60 = bitcast [3 x i8]* %58 to i8*
  store i8* %60, i8** %stringdatainit202, align 8
  %alloc203 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %61 = bitcast i8* %alloc203 to [2 x i8]*
  %dataptr204 = getelementptr inbounds [2 x i8], [2 x i8]* %61, i32 0, i32 0
  store i8 13, i8* %dataptr204, align 1
  %dataptr205 = getelementptr inbounds [2 x i8], [2 x i8]* %61, i32 0, i32 1
  store i8 0, i8* %dataptr205, align 1
  %alloc206 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %62 = bitcast i8* %alloc206 to %string*
  %stringleninit207 = getelementptr inbounds %string, %string* %62, i32 0, i32 1
  store i64 1, i64* %stringleninit207, align 4
  %stringdatainit208 = getelementptr inbounds %string, %string* %62, i32 0, i32 0
  %63 = bitcast [2 x i8]* %61 to i8*
  store i8* %63, i8** %stringdatainit208, align 8
  %call209 = call %string* bitcast (%string* (%string*, %string*, %string*)* @stark.functions.str.replace to %string* (%string*, %string*, %string*)*)(%string* %load195, %string* %59, %string* %62)
  store %string* %call209, %string** %stringValue, align 8
  %load210 = load %string*, %string** %stringValue, align 8
  %alloc211 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %64 = bitcast i8* %alloc211 to [3 x i8]*
  %dataptr212 = getelementptr inbounds [3 x i8], [3 x i8]* %64, i32 0, i32 0
  store i8 92, i8* %dataptr212, align 1
  %dataptr213 = getelementptr inbounds [3 x i8], [3 x i8]* %64, i32 0, i32 1
  store i8 10, i8* %dataptr213, align 1
  %dataptr214 = getelementptr inbounds [3 x i8], [3 x i8]* %64, i32 0, i32 2
  store i8 0, i8* %dataptr214, align 1
  %alloc215 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %65 = bitcast i8* %alloc215 to %string*
  %stringleninit216 = getelementptr inbounds %string, %string* %65, i32 0, i32 1
  store i64 2, i64* %stringleninit216, align 4
  %stringdatainit217 = getelementptr inbounds %string, %string* %65, i32 0, i32 0
  %66 = bitcast [3 x i8]* %64 to i8*
  store i8* %66, i8** %stringdatainit217, align 8
  %alloc218 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %67 = bitcast i8* %alloc218 to [2 x i8]*
  %dataptr219 = getelementptr inbounds [2 x i8], [2 x i8]* %67, i32 0, i32 0
  store i8 10, i8* %dataptr219, align 1
  %dataptr220 = getelementptr inbounds [2 x i8], [2 x i8]* %67, i32 0, i32 1
  store i8 0, i8* %dataptr220, align 1
  %alloc221 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %68 = bitcast i8* %alloc221 to %string*
  %stringleninit222 = getelementptr inbounds %string, %string* %68, i32 0, i32 1
  store i64 1, i64* %stringleninit222, align 4
  %stringdatainit223 = getelementptr inbounds %string, %string* %68, i32 0, i32 0
  %69 = bitcast [2 x i8]* %67 to i8*
  store i8* %69, i8** %stringdatainit223, align 8
  %call224 = call %string* bitcast (%string* (%string*, %string*, %string*)* @stark.functions.str.replace to %string* (%string*, %string*, %string*)*)(%string* %load210, %string* %65, %string* %68)
  store %string* %call224, %string** %stringValue, align 8
  %load225 = load %string*, %string** %stringValue, align 8
  %alloc226 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([3 x i8]* getelementptr ([3 x i8], [3 x i8]* null, i32 1) to i64))
  %70 = bitcast i8* %alloc226 to [3 x i8]*
  %dataptr227 = getelementptr inbounds [3 x i8], [3 x i8]* %70, i32 0, i32 0
  store i8 92, i8* %dataptr227, align 1
  %dataptr228 = getelementptr inbounds [3 x i8], [3 x i8]* %70, i32 0, i32 1
  store i8 9, i8* %dataptr228, align 1
  %dataptr229 = getelementptr inbounds [3 x i8], [3 x i8]* %70, i32 0, i32 2
  store i8 0, i8* %dataptr229, align 1
  %alloc230 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %71 = bitcast i8* %alloc230 to %string*
  %stringleninit231 = getelementptr inbounds %string, %string* %71, i32 0, i32 1
  store i64 2, i64* %stringleninit231, align 4
  %stringdatainit232 = getelementptr inbounds %string, %string* %71, i32 0, i32 0
  %72 = bitcast [3 x i8]* %70 to i8*
  store i8* %72, i8** %stringdatainit232, align 8
  %alloc233 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %73 = bitcast i8* %alloc233 to [2 x i8]*
  %dataptr234 = getelementptr inbounds [2 x i8], [2 x i8]* %73, i32 0, i32 0
  store i8 9, i8* %dataptr234, align 1
  %dataptr235 = getelementptr inbounds [2 x i8], [2 x i8]* %73, i32 0, i32 1
  store i8 0, i8* %dataptr235, align 1
  %alloc236 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %74 = bitcast i8* %alloc236 to %string*
  %stringleninit237 = getelementptr inbounds %string, %string* %74, i32 0, i32 1
  store i64 1, i64* %stringleninit237, align 4
  %stringdatainit238 = getelementptr inbounds %string, %string* %74, i32 0, i32 0
  %75 = bitcast [2 x i8]* %73 to i8*
  store i8* %75, i8** %stringdatainit238, align 8
  %call239 = call %string* bitcast (%string* (%string*, %string*, %string*)* @stark.functions.str.replace to %string* (%string*, %string*, %string*)*)(%string* %load225, %string* %71, %string* %74)
  store %string* %call239, %string** %stringValue, align 8
  br label %ifcont240

ifcont240:                                        ; preds = %if189, %if180
  %alloc241 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([7 x i8]* getelementptr ([7 x i8], [7 x i8]* null, i32 1) to i64))
  %76 = bitcast i8* %alloc241 to [7 x i8]*
  %dataptr242 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 0
  store i8 115, i8* %dataptr242, align 1
  %dataptr243 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 1
  store i8 116, i8* %dataptr243, align 1
  %dataptr244 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 2
  store i8 114, i8* %dataptr244, align 1
  %dataptr245 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 3
  store i8 105, i8* %dataptr245, align 1
  %dataptr246 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 4
  store i8 110, i8* %dataptr246, align 1
  %dataptr247 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 5
  store i8 103, i8* %dataptr247, align 1
  %dataptr248 = getelementptr inbounds [7 x i8], [7 x i8]* %76, i32 0, i32 6
  store i8 0, i8* %dataptr248, align 1
  %alloc249 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %77 = bitcast i8* %alloc249 to %string*
  %stringleninit250 = getelementptr inbounds %string, %string* %77, i32 0, i32 1
  store i64 6, i64* %stringleninit250, align 4
  %stringdatainit251 = getelementptr inbounds %string, %string* %77, i32 0, i32 0
  %78 = bitcast [7 x i8]* %76 to i8*
  store i8* %78, i8** %stringdatainit251, align 8
  %load252 = load %string*, %string** %stringValue, align 8
  %call253 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %77, %string* %load252, i64 0, double 0.000000e+00, i1 false, %array.JSONValue* null, %array.JSONProperty* null)
  %79 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr254 = getelementptr inbounds %JSONResult, %JSONResult* %79, i32 0, i32 0
  store %JSONValue* %call253, %JSONValue** %memberptr254, align 8
  %load255 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load255

ifcont256:                                        ; preds = %ifcont162
  %load257 = load %string*, %string** %cleanedValue, align 8
  %alloc258 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %80 = bitcast i8* %alloc258 to [2 x i8]*
  %dataptr259 = getelementptr inbounds [2 x i8], [2 x i8]* %80, i32 0, i32 0
  store i8 123, i8* %dataptr259, align 1
  %dataptr260 = getelementptr inbounds [2 x i8], [2 x i8]* %80, i32 0, i32 1
  store i8 0, i8* %dataptr260, align 1
  %alloc261 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %81 = bitcast i8* %alloc261 to %string*
  %stringleninit262 = getelementptr inbounds %string, %string* %81, i32 0, i32 1
  store i64 1, i64* %stringleninit262, align 4
  %stringdatainit263 = getelementptr inbounds %string, %string* %81, i32 0, i32 0
  %82 = bitcast [2 x i8]* %80 to i8*
  store i8* %82, i8** %stringdatainit263, align 8
  %call264 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.startsWith to i1 (%string*, %string*)*)(%string* %load257, %string* %81)
  %load265 = load %string*, %string** %cleanedValue, align 8
  %alloc266 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %83 = bitcast i8* %alloc266 to [2 x i8]*
  %dataptr267 = getelementptr inbounds [2 x i8], [2 x i8]* %83, i32 0, i32 0
  store i8 125, i8* %dataptr267, align 1
  %dataptr268 = getelementptr inbounds [2 x i8], [2 x i8]* %83, i32 0, i32 1
  store i8 0, i8* %dataptr268, align 1
  %alloc269 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %84 = bitcast i8* %alloc269 to %string*
  %stringleninit270 = getelementptr inbounds %string, %string* %84, i32 0, i32 1
  store i64 1, i64* %stringleninit270, align 4
  %stringdatainit271 = getelementptr inbounds %string, %string* %84, i32 0, i32 0
  %85 = bitcast [2 x i8]* %83 to i8*
  store i8* %85, i8** %stringdatainit271, align 8
  %call272 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.endsWith to i1 (%string*, %string*)*)(%string* %load265, %string* %84)
  %binop273 = and i1 %call264, %call272
  br i1 %binop273, label %if274, label %ifcont534

if274:                                            ; preds = %ifcont256
  %load275 = load %string*, %string** %cleanedValue, align 8
  %86 = load %string*, %string** %cleanedValue, align 8
  %memberptr276 = getelementptr inbounds %string, %string* %86, i32 0, i32 1
  %load277 = load i64, i64* %memberptr276, align 4
  %binop278 = sub i64 %load277, 1
  %call279 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.slice to %string* (%string*, i64, i64)*)(%string* %load275, i64 1, i64 %binop278)
  %call280 = call %string* bitcast (%string* (%string*)* @stark.functions.str.trim to %string* (%string*)*)(%string* %call279)
  %objectString = alloca %string*, align 8
  store %string* %call280, %string** %objectString, align 8
  %objectProperties = alloca %array.JSONProperty*, align 8
  %alloc281 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([0 x %JSONProperty*]* getelementptr ([0 x %JSONProperty*], [0 x %JSONProperty*]* null, i32 1) to i64))
  %87 = bitcast i8* %alloc281 to [0 x %JSONProperty*]*
  %alloc282 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.JSONProperty* getelementptr (%array.JSONProperty, %array.JSONProperty* null, i32 1) to i64))
  %88 = bitcast i8* %alloc282 to %array.JSONProperty*
  %arrayleninit = getelementptr inbounds %array.JSONProperty, %array.JSONProperty* %88, i32 0, i32 1
  store i64 0, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.JSONProperty, %array.JSONProperty* %88, i32 0, i32 0
  %89 = bitcast [0 x %JSONProperty*]* %87 to %JSONProperty**
  store %JSONProperty** %89, %JSONProperty*** %arrayeleminit, align 8
  store %array.JSONProperty* %88, %array.JSONProperty** %objectProperties, align 8
  %90 = load %string*, %string** %objectString, align 8
  %memberptr283 = getelementptr inbounds %string, %string* %90, i32 0, i32 1
  %load284 = load i64, i64* %memberptr283, align 4
  %cmp285 = icmp eq i64 %load284, 0
  br i1 %cmp285, label %if286, label %ifcont302

if286:                                            ; preds = %if274
  %alloc287 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([7 x i8]* getelementptr ([7 x i8], [7 x i8]* null, i32 1) to i64))
  %91 = bitcast i8* %alloc287 to [7 x i8]*
  %dataptr288 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 0
  store i8 111, i8* %dataptr288, align 1
  %dataptr289 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 1
  store i8 98, i8* %dataptr289, align 1
  %dataptr290 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 2
  store i8 106, i8* %dataptr290, align 1
  %dataptr291 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 3
  store i8 101, i8* %dataptr291, align 1
  %dataptr292 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 4
  store i8 99, i8* %dataptr292, align 1
  %dataptr293 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 5
  store i8 116, i8* %dataptr293, align 1
  %dataptr294 = getelementptr inbounds [7 x i8], [7 x i8]* %91, i32 0, i32 6
  store i8 0, i8* %dataptr294, align 1
  %alloc295 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %92 = bitcast i8* %alloc295 to %string*
  %stringleninit296 = getelementptr inbounds %string, %string* %92, i32 0, i32 1
  store i64 6, i64* %stringleninit296, align 4
  %stringdatainit297 = getelementptr inbounds %string, %string* %92, i32 0, i32 0
  %93 = bitcast [7 x i8]* %91 to i8*
  store i8* %93, i8** %stringdatainit297, align 8
  %load298 = load %array.JSONProperty*, %array.JSONProperty** %objectProperties, align 8
  %call299 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %92, %string* null, i64 0, double 0.000000e+00, i1 false, %array.JSONValue* null, %array.JSONProperty* %load298)
  %94 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr300 = getelementptr inbounds %JSONResult, %JSONResult* %94, i32 0, i32 0
  store %JSONValue* %call299, %JSONValue** %memberptr300, align 8
  %load301 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load301

ifcont302:                                        ; preds = %if274
  %alloc303 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %95 = bitcast i8* %alloc303 to [1 x i8]*
  %dataptr304 = getelementptr inbounds [1 x i8], [1 x i8]* %95, i32 0, i32 0
  store i8 0, i8* %dataptr304, align 1
  %alloc305 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %96 = bitcast i8* %alloc305 to %string*
  %stringleninit306 = getelementptr inbounds %string, %string* %96, i32 0, i32 1
  store i64 0, i64* %stringleninit306, align 4
  %stringdatainit307 = getelementptr inbounds %string, %string* %96, i32 0, i32 0
  %97 = bitcast [1 x i8]* %95 to i8*
  store i8* %97, i8** %stringdatainit307, align 8
  %propertyValue = alloca %string*, align 8
  store %string* %96, %string** %propertyValue, align 8
  %alloc308 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %98 = bitcast i8* %alloc308 to [1 x i8]*
  %dataptr309 = getelementptr inbounds [1 x i8], [1 x i8]* %98, i32 0, i32 0
  store i8 0, i8* %dataptr309, align 1
  %alloc310 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %99 = bitcast i8* %alloc310 to %string*
  %stringleninit311 = getelementptr inbounds %string, %string* %99, i32 0, i32 1
  store i64 0, i64* %stringleninit311, align 4
  %stringdatainit312 = getelementptr inbounds %string, %string* %99, i32 0, i32 0
  %100 = bitcast [1 x i8]* %98 to i8*
  store i8* %100, i8** %stringdatainit312, align 8
  %propertyName = alloca %string*, align 8
  store %string* %99, %string** %propertyName, align 8
  %insideQuotes = alloca i1, align 1
  store i1 false, i1* %insideQuotes, align 1
  %objectDepth = alloca i64, align 8
  store i64 0, i64* %objectDepth, align 4
  %arrayDepth = alloca i64, align 8
  store i64 0, i64* %arrayDepth, align 4
  %call313 = call %JSONProperty* @stark.structs.json.JSONProperty.constructor(%string* null, %JSONValue* null)
  %currentProperty = alloca %JSONProperty*, align 8
  store %JSONProperty* %call313, %JSONProperty** %currentProperty, align 8
  %hasError = alloca i1, align 1
  store i1 false, i1* %hasError, align 1
  %oi = alloca i64, align 8
  store i64 0, i64* %oi, align 4
  %alloc314 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %101 = bitcast i8* %alloc314 to [1 x i8]*
  %dataptr315 = getelementptr inbounds [1 x i8], [1 x i8]* %101, i32 0, i32 0
  store i8 0, i8* %dataptr315, align 1
  %alloc316 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %102 = bitcast i8* %alloc316 to %string*
  %stringleninit317 = getelementptr inbounds %string, %string* %102, i32 0, i32 1
  store i64 0, i64* %stringleninit317, align 4
  %stringdatainit318 = getelementptr inbounds %string, %string* %102, i32 0, i32 0
  %103 = bitcast [1 x i8]* %101 to i8*
  store i8* %103, i8** %stringdatainit318, align 8
  %previousChar = alloca %string*, align 8
  store %string* %102, %string** %previousChar, align 8
  br label %whiletest

whiletest:                                        ; preds = %ifcont511, %ifcont302
  %load319 = load i64, i64* %oi, align 4
  %104 = load %string*, %string** %objectString, align 8
  %memberptr320 = getelementptr inbounds %string, %string* %104, i32 0, i32 1
  %load321 = load i64, i64* %memberptr320, align 4
  %cmp322 = icmp slt i64 %load319, %load321
  %load323 = load i1, i1* %hasError, align 1
  %cmp324 = icmp eq i1 %load323, false
  %binop325 = and i1 %cmp322, %cmp324
  br i1 %binop325, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load326 = load %string*, %string** %objectString, align 8
  %load327 = load i64, i64* %oi, align 4
  %load328 = load i64, i64* %oi, align 4
  %binop329 = add i64 %load328, 1
  %call330 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.slice to %string* (%string*, i64, i64)*)(%string* %load326, i64 %load327, i64 %binop329)
  %currentChar = alloca %string*, align 8
  store %string* %call330, %string** %currentChar, align 8
  %load331 = load %string*, %string** %currentChar, align 8
  %alloc332 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %105 = bitcast i8* %alloc332 to [2 x i8]*
  %dataptr333 = getelementptr inbounds [2 x i8], [2 x i8]* %105, i32 0, i32 0
  store i8 34, i8* %dataptr333, align 1
  %dataptr334 = getelementptr inbounds [2 x i8], [2 x i8]* %105, i32 0, i32 1
  store i8 0, i8* %dataptr334, align 1
  %alloc335 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %106 = bitcast i8* %alloc335 to %string*
  %stringleninit336 = getelementptr inbounds %string, %string* %106, i32 0, i32 1
  store i64 1, i64* %stringleninit336, align 4
  %stringdatainit337 = getelementptr inbounds %string, %string* %106, i32 0, i32 0
  %107 = bitcast [2 x i8]* %105 to i8*
  store i8* %107, i8** %stringdatainit337, align 8
  %comp338 = call i1 @stark_runtime_priv_eq_string(%string* %load331, %string* %106)
  %load339 = load %string*, %string** %previousChar, align 8
  %alloc340 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %108 = bitcast i8* %alloc340 to [2 x i8]*
  %dataptr341 = getelementptr inbounds [2 x i8], [2 x i8]* %108, i32 0, i32 0
  store i8 92, i8* %dataptr341, align 1
  %dataptr342 = getelementptr inbounds [2 x i8], [2 x i8]* %108, i32 0, i32 1
  store i8 0, i8* %dataptr342, align 1
  %alloc343 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %109 = bitcast i8* %alloc343 to %string*
  %stringleninit344 = getelementptr inbounds %string, %string* %109, i32 0, i32 1
  store i64 1, i64* %stringleninit344, align 4
  %stringdatainit345 = getelementptr inbounds %string, %string* %109, i32 0, i32 0
  %110 = bitcast [2 x i8]* %108 to i8*
  store i8* %110, i8** %stringdatainit345, align 8
  %comp346 = call i1 @stark_runtime_priv_neq_string(%string* %load339, %string* %109)
  %binop347 = and i1 %comp338, %comp346
  br i1 %binop347, label %if348, label %ifcont351

if348:                                            ; preds = %while
  %load349 = load i1, i1* %insideQuotes, align 1
  %cmp350 = icmp eq i1 %load349, false
  store i1 %cmp350, i1* %insideQuotes, align 1
  br label %ifcont351

ifcont351:                                        ; preds = %if348, %while
  %load352 = load %string*, %string** %currentChar, align 8
  %alloc353 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %111 = bitcast i8* %alloc353 to [2 x i8]*
  %dataptr354 = getelementptr inbounds [2 x i8], [2 x i8]* %111, i32 0, i32 0
  store i8 123, i8* %dataptr354, align 1
  %dataptr355 = getelementptr inbounds [2 x i8], [2 x i8]* %111, i32 0, i32 1
  store i8 0, i8* %dataptr355, align 1
  %alloc356 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %112 = bitcast i8* %alloc356 to %string*
  %stringleninit357 = getelementptr inbounds %string, %string* %112, i32 0, i32 1
  store i64 1, i64* %stringleninit357, align 4
  %stringdatainit358 = getelementptr inbounds %string, %string* %112, i32 0, i32 0
  %113 = bitcast [2 x i8]* %111 to i8*
  store i8* %113, i8** %stringdatainit358, align 8
  %comp359 = call i1 @stark_runtime_priv_eq_string(%string* %load352, %string* %112)
  br i1 %comp359, label %if360, label %ifcont363

if360:                                            ; preds = %ifcont351
  %load361 = load i64, i64* %objectDepth, align 4
  %binop362 = add i64 %load361, 1
  store i64 %binop362, i64* %objectDepth, align 4
  br label %ifcont363

ifcont363:                                        ; preds = %if360, %ifcont351
  %load364 = load %string*, %string** %currentChar, align 8
  %alloc365 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %114 = bitcast i8* %alloc365 to [2 x i8]*
  %dataptr366 = getelementptr inbounds [2 x i8], [2 x i8]* %114, i32 0, i32 0
  store i8 125, i8* %dataptr366, align 1
  %dataptr367 = getelementptr inbounds [2 x i8], [2 x i8]* %114, i32 0, i32 1
  store i8 0, i8* %dataptr367, align 1
  %alloc368 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %115 = bitcast i8* %alloc368 to %string*
  %stringleninit369 = getelementptr inbounds %string, %string* %115, i32 0, i32 1
  store i64 1, i64* %stringleninit369, align 4
  %stringdatainit370 = getelementptr inbounds %string, %string* %115, i32 0, i32 0
  %116 = bitcast [2 x i8]* %114 to i8*
  store i8* %116, i8** %stringdatainit370, align 8
  %comp371 = call i1 @stark_runtime_priv_eq_string(%string* %load364, %string* %115)
  br i1 %comp371, label %if372, label %ifcont375

if372:                                            ; preds = %ifcont363
  %load373 = load i64, i64* %objectDepth, align 4
  %binop374 = sub i64 %load373, 1
  store i64 %binop374, i64* %objectDepth, align 4
  br label %ifcont375

ifcont375:                                        ; preds = %if372, %ifcont363
  %load376 = load %string*, %string** %currentChar, align 8
  %alloc377 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %117 = bitcast i8* %alloc377 to [2 x i8]*
  %dataptr378 = getelementptr inbounds [2 x i8], [2 x i8]* %117, i32 0, i32 0
  store i8 91, i8* %dataptr378, align 1
  %dataptr379 = getelementptr inbounds [2 x i8], [2 x i8]* %117, i32 0, i32 1
  store i8 0, i8* %dataptr379, align 1
  %alloc380 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %118 = bitcast i8* %alloc380 to %string*
  %stringleninit381 = getelementptr inbounds %string, %string* %118, i32 0, i32 1
  store i64 1, i64* %stringleninit381, align 4
  %stringdatainit382 = getelementptr inbounds %string, %string* %118, i32 0, i32 0
  %119 = bitcast [2 x i8]* %117 to i8*
  store i8* %119, i8** %stringdatainit382, align 8
  %comp383 = call i1 @stark_runtime_priv_eq_string(%string* %load376, %string* %118)
  br i1 %comp383, label %if384, label %ifcont387

if384:                                            ; preds = %ifcont375
  %load385 = load i64, i64* %arrayDepth, align 4
  %binop386 = add i64 %load385, 1
  store i64 %binop386, i64* %arrayDepth, align 4
  br label %ifcont387

ifcont387:                                        ; preds = %if384, %ifcont375
  %load388 = load %string*, %string** %currentChar, align 8
  %alloc389 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %120 = bitcast i8* %alloc389 to [2 x i8]*
  %dataptr390 = getelementptr inbounds [2 x i8], [2 x i8]* %120, i32 0, i32 0
  store i8 93, i8* %dataptr390, align 1
  %dataptr391 = getelementptr inbounds [2 x i8], [2 x i8]* %120, i32 0, i32 1
  store i8 0, i8* %dataptr391, align 1
  %alloc392 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %121 = bitcast i8* %alloc392 to %string*
  %stringleninit393 = getelementptr inbounds %string, %string* %121, i32 0, i32 1
  store i64 1, i64* %stringleninit393, align 4
  %stringdatainit394 = getelementptr inbounds %string, %string* %121, i32 0, i32 0
  %122 = bitcast [2 x i8]* %120 to i8*
  store i8* %122, i8** %stringdatainit394, align 8
  %comp395 = call i1 @stark_runtime_priv_eq_string(%string* %load388, %string* %121)
  br i1 %comp395, label %if396, label %ifcont399

if396:                                            ; preds = %ifcont387
  %load397 = load i64, i64* %arrayDepth, align 4
  %binop398 = sub i64 %load397, 1
  store i64 %binop398, i64* %arrayDepth, align 4
  br label %ifcont399

ifcont399:                                        ; preds = %if396, %ifcont387
  %123 = load %JSONProperty*, %JSONProperty** %currentProperty, align 8
  %memberptr400 = getelementptr inbounds %JSONProperty, %JSONProperty* %123, i32 0, i32 0
  %load401 = load %string*, %string** %memberptr400, align 8
  %124 = ptrtoint %string* %load401 to i64
  %cmp402 = icmp eq i64 %124, 0
  %load403 = load i1, i1* %insideQuotes, align 1
  %binop404 = and i1 %cmp402, %load403
  br i1 %binop404, label %if405, label %ifcont408

if405:                                            ; preds = %ifcont399
  %load406 = load %string*, %string** %propertyName, align 8
  %load407 = load %string*, %string** %currentChar, align 8
  %concat = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load406, %string* %load407)
  store %string* %concat, %string** %propertyName, align 8
  br label %ifcont408

ifcont408:                                        ; preds = %if405, %ifcont399
  %125 = load %JSONProperty*, %JSONProperty** %currentProperty, align 8
  %memberptr409 = getelementptr inbounds %JSONProperty, %JSONProperty* %125, i32 0, i32 0
  %load410 = load %string*, %string** %memberptr409, align 8
  %126 = ptrtoint %string* %load410 to i64
  %cmp411 = icmp ne i64 %126, 0
  br i1 %cmp411, label %if412, label %ifcont416

if412:                                            ; preds = %ifcont408
  %load413 = load %string*, %string** %propertyValue, align 8
  %load414 = load %string*, %string** %currentChar, align 8
  %concat415 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load413, %string* %load414)
  store %string* %concat415, %string** %propertyValue, align 8
  br label %ifcont416

ifcont416:                                        ; preds = %if412, %ifcont408
  %load417 = load %string*, %string** %currentChar, align 8
  %alloc418 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %127 = bitcast i8* %alloc418 to [2 x i8]*
  %dataptr419 = getelementptr inbounds [2 x i8], [2 x i8]* %127, i32 0, i32 0
  store i8 58, i8* %dataptr419, align 1
  %dataptr420 = getelementptr inbounds [2 x i8], [2 x i8]* %127, i32 0, i32 1
  store i8 0, i8* %dataptr420, align 1
  %alloc421 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %128 = bitcast i8* %alloc421 to %string*
  %stringleninit422 = getelementptr inbounds %string, %string* %128, i32 0, i32 1
  store i64 1, i64* %stringleninit422, align 4
  %stringdatainit423 = getelementptr inbounds %string, %string* %128, i32 0, i32 0
  %129 = bitcast [2 x i8]* %127 to i8*
  store i8* %129, i8** %stringdatainit423, align 8
  %comp424 = call i1 @stark_runtime_priv_eq_string(%string* %load417, %string* %128)
  %load425 = load i1, i1* %insideQuotes, align 1
  %cmp426 = icmp eq i1 %load425, false
  %binop427 = and i1 %comp424, %cmp426
  br i1 %binop427, label %if428, label %ifcont444

if428:                                            ; preds = %ifcont416
  %130 = load %string*, %string** %propertyName, align 8
  %memberptr429 = getelementptr inbounds %string, %string* %130, i32 0, i32 1
  %load430 = load i64, i64* %memberptr429, align 4
  %cmp431 = icmp sgt i64 %load430, 0
  br i1 %cmp431, label %if432, label %ifcont443

if432:                                            ; preds = %if428
  %load433 = load %string*, %string** %propertyName, align 8
  %131 = load %string*, %string** %propertyName, align 8
  %memberptr434 = getelementptr inbounds %string, %string* %131, i32 0, i32 1
  %load435 = load i64, i64* %memberptr434, align 4
  %call436 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.subString to %string* (%string*, i64, i64)*)(%string* %load433, i64 1, i64 %load435)
  %132 = load %JSONProperty*, %JSONProperty** %currentProperty, align 8
  %memberptr437 = getelementptr inbounds %JSONProperty, %JSONProperty* %132, i32 0, i32 0
  store %string* %call436, %string** %memberptr437, align 8
  %alloc438 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %133 = bitcast i8* %alloc438 to [1 x i8]*
  %dataptr439 = getelementptr inbounds [1 x i8], [1 x i8]* %133, i32 0, i32 0
  store i8 0, i8* %dataptr439, align 1
  %alloc440 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %134 = bitcast i8* %alloc440 to %string*
  %stringleninit441 = getelementptr inbounds %string, %string* %134, i32 0, i32 1
  store i64 0, i64* %stringleninit441, align 4
  %stringdatainit442 = getelementptr inbounds %string, %string* %134, i32 0, i32 0
  %135 = bitcast [1 x i8]* %133 to i8*
  store i8* %135, i8** %stringdatainit442, align 8
  store %string* %134, %string** %propertyName, align 8
  br label %ifcont443

ifcont443:                                        ; preds = %if432, %if428
  br label %ifcont444

ifcont444:                                        ; preds = %ifcont443, %ifcont416
  %load445 = load %string*, %string** %currentChar, align 8
  %alloc446 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %136 = bitcast i8* %alloc446 to [2 x i8]*
  %dataptr447 = getelementptr inbounds [2 x i8], [2 x i8]* %136, i32 0, i32 0
  store i8 44, i8* %dataptr447, align 1
  %dataptr448 = getelementptr inbounds [2 x i8], [2 x i8]* %136, i32 0, i32 1
  store i8 0, i8* %dataptr448, align 1
  %alloc449 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %137 = bitcast i8* %alloc449 to %string*
  %stringleninit450 = getelementptr inbounds %string, %string* %137, i32 0, i32 1
  store i64 1, i64* %stringleninit450, align 4
  %stringdatainit451 = getelementptr inbounds %string, %string* %137, i32 0, i32 0
  %138 = bitcast [2 x i8]* %136 to i8*
  store i8* %138, i8** %stringdatainit451, align 8
  %comp452 = call i1 @stark_runtime_priv_eq_string(%string* %load445, %string* %137)
  %load453 = load i64, i64* %oi, align 4
  %binop454 = add i64 %load453, 1
  %139 = load %string*, %string** %objectString, align 8
  %memberptr455 = getelementptr inbounds %string, %string* %139, i32 0, i32 1
  %load456 = load i64, i64* %memberptr455, align 4
  %cmp457 = icmp eq i64 %binop454, %load456
  %binop458 = or i1 %comp452, %cmp457
  %load459 = load i1, i1* %insideQuotes, align 1
  %cmp460 = icmp eq i1 %load459, false
  %binop461 = and i1 %binop458, %cmp460
  %load462 = load i64, i64* %objectDepth, align 4
  %cmp463 = icmp eq i64 %load462, 0
  %binop464 = and i1 %binop461, %cmp463
  %load465 = load i64, i64* %arrayDepth, align 4
  %cmp466 = icmp eq i64 %load465, 0
  %binop467 = and i1 %binop464, %cmp466
  br i1 %binop467, label %if468, label %ifcont511

if468:                                            ; preds = %ifcont444
  %load469 = load %string*, %string** %propertyValue, align 8
  %alloc470 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %140 = bitcast i8* %alloc470 to [2 x i8]*
  %dataptr471 = getelementptr inbounds [2 x i8], [2 x i8]* %140, i32 0, i32 0
  store i8 44, i8* %dataptr471, align 1
  %dataptr472 = getelementptr inbounds [2 x i8], [2 x i8]* %140, i32 0, i32 1
  store i8 0, i8* %dataptr472, align 1
  %alloc473 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %141 = bitcast i8* %alloc473 to %string*
  %stringleninit474 = getelementptr inbounds %string, %string* %141, i32 0, i32 1
  store i64 1, i64* %stringleninit474, align 4
  %stringdatainit475 = getelementptr inbounds %string, %string* %141, i32 0, i32 0
  %142 = bitcast [2 x i8]* %140 to i8*
  store i8* %142, i8** %stringdatainit475, align 8
  %call476 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.endsWith to i1 (%string*, %string*)*)(%string* %load469, %string* %141)
  br i1 %call476, label %if477, label %ifcont483

if477:                                            ; preds = %if468
  %load478 = load %string*, %string** %propertyValue, align 8
  %143 = load %string*, %string** %propertyValue, align 8
  %memberptr479 = getelementptr inbounds %string, %string* %143, i32 0, i32 1
  %load480 = load i64, i64* %memberptr479, align 4
  %binop481 = sub i64 %load480, 1
  %call482 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.subString to %string* (%string*, i64, i64)*)(%string* %load478, i64 0, i64 %binop481)
  store %string* %call482, %string** %propertyValue, align 8
  br label %ifcont483

ifcont483:                                        ; preds = %if477, %if468
  %load484 = load %string*, %string** %propertyValue, align 8
  %call485 = call %JSONResult* @stark.functions.json.parse(%string* %load484)
  %pr = alloca %JSONResult*, align 8
  store %JSONResult* %call485, %JSONResult** %pr, align 8
  %144 = load %JSONResult*, %JSONResult** %pr, align 8
  %memberptr486 = getelementptr inbounds %JSONResult, %JSONResult* %144, i32 0, i32 1
  %load487 = load %string*, %string** %memberptr486, align 8
  %145 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr488 = getelementptr inbounds %JSONResult, %JSONResult* %145, i32 0, i32 1
  store %string* %load487, %string** %memberptr488, align 8
  %146 = load %JSONResult*, %JSONResult** %pr, align 8
  %memberptr489 = getelementptr inbounds %JSONResult, %JSONResult* %146, i32 0, i32 1
  %load490 = load %string*, %string** %memberptr489, align 8
  %147 = ptrtoint %string* %load490 to i64
  %cmp491 = icmp eq i64 %147, 0
  br i1 %cmp491, label %if492, label %else509

if492:                                            ; preds = %ifcont483
  %148 = load %JSONResult*, %JSONResult** %pr, align 8
  %memberptr493 = getelementptr inbounds %JSONResult, %JSONResult* %148, i32 0, i32 0
  %load494 = load %JSONValue*, %JSONValue** %memberptr493, align 8
  %149 = load %JSONProperty*, %JSONProperty** %currentProperty, align 8
  %memberptr495 = getelementptr inbounds %JSONProperty, %JSONProperty* %149, i32 0, i32 1
  store %JSONValue* %load494, %JSONValue** %memberptr495, align 8
  %alloc496 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %150 = bitcast i8* %alloc496 to [1 x i8]*
  %dataptr497 = getelementptr inbounds [1 x i8], [1 x i8]* %150, i32 0, i32 0
  store i8 0, i8* %dataptr497, align 1
  %alloc498 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %151 = bitcast i8* %alloc498 to %string*
  %stringleninit499 = getelementptr inbounds %string, %string* %151, i32 0, i32 1
  store i64 0, i64* %stringleninit499, align 4
  %stringdatainit500 = getelementptr inbounds %string, %string* %151, i32 0, i32 0
  %152 = bitcast [1 x i8]* %150 to i8*
  store i8* %152, i8** %stringdatainit500, align 8
  store %string* %151, %string** %propertyValue, align 8
  %load501 = load %array.JSONProperty*, %array.JSONProperty** %objectProperties, align 8
  %load502 = load %JSONProperty*, %JSONProperty** %currentProperty, align 8
  %alloc503 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %JSONProperty*]* getelementptr ([1 x %JSONProperty*], [1 x %JSONProperty*]* null, i32 1) to i64))
  %153 = bitcast i8* %alloc503 to [1 x %JSONProperty*]*
  %elementptr = getelementptr inbounds [1 x %JSONProperty*], [1 x %JSONProperty*]* %153, i32 0, i32 0
  store %JSONProperty* %load502, %JSONProperty** %elementptr, align 8
  %alloc504 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.JSONProperty* getelementptr (%array.JSONProperty, %array.JSONProperty* null, i32 1) to i64))
  %154 = bitcast i8* %alloc504 to %array.JSONProperty*
  %arrayleninit505 = getelementptr inbounds %array.JSONProperty, %array.JSONProperty* %154, i32 0, i32 1
  store i64 1, i64* %arrayleninit505, align 4
  %arrayeleminit506 = getelementptr inbounds %array.JSONProperty, %array.JSONProperty* %154, i32 0, i32 0
  %155 = bitcast [1 x %JSONProperty*]* %153 to %JSONProperty**
  store %JSONProperty** %155, %JSONProperty*** %arrayeleminit506, align 8
  %156 = bitcast %array.JSONProperty* %load501 to i8*
  %157 = bitcast %array.JSONProperty* %154 to i8*
  %concat507 = call i8* bitcast (i8* (i8*, i8*, i64)* @stark_runtime_priv_concat_array to i8* (i8*, i8*, i64)*)(i8* %156, i8* %157, i64 ptrtoint (%JSONProperty*** getelementptr (%JSONProperty**, %JSONProperty*** null, i32 1) to i64))
  %158 = bitcast i8* %concat507 to %array.JSONProperty*
  store %array.JSONProperty* %158, %array.JSONProperty** %objectProperties, align 8
  %call508 = call %JSONProperty* @stark.structs.json.JSONProperty.constructor(%string* null, %JSONValue* null)
  store %JSONProperty* %call508, %JSONProperty** %currentProperty, align 8
  br label %ifcont510

else509:                                          ; preds = %ifcont483
  store i1 true, i1* %hasError, align 1
  br label %ifcont510

ifcont510:                                        ; preds = %else509, %if492
  br label %ifcont511

ifcont511:                                        ; preds = %ifcont510, %ifcont444
  %load512 = load %string*, %string** %currentChar, align 8
  store %string* %load512, %string** %previousChar, align 8
  %load513 = load i64, i64* %oi, align 4
  %binop514 = add i64 %load513, 1
  store i64 %binop514, i64* %oi, align 4
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %load515 = load i1, i1* %hasError, align 1
  %cmp516 = icmp eq i1 %load515, false
  br i1 %cmp516, label %if517, label %ifcont533

if517:                                            ; preds = %whilecont
  %alloc518 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([7 x i8]* getelementptr ([7 x i8], [7 x i8]* null, i32 1) to i64))
  %159 = bitcast i8* %alloc518 to [7 x i8]*
  %dataptr519 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 0
  store i8 111, i8* %dataptr519, align 1
  %dataptr520 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 1
  store i8 98, i8* %dataptr520, align 1
  %dataptr521 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 2
  store i8 106, i8* %dataptr521, align 1
  %dataptr522 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 3
  store i8 101, i8* %dataptr522, align 1
  %dataptr523 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 4
  store i8 99, i8* %dataptr523, align 1
  %dataptr524 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 5
  store i8 116, i8* %dataptr524, align 1
  %dataptr525 = getelementptr inbounds [7 x i8], [7 x i8]* %159, i32 0, i32 6
  store i8 0, i8* %dataptr525, align 1
  %alloc526 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %160 = bitcast i8* %alloc526 to %string*
  %stringleninit527 = getelementptr inbounds %string, %string* %160, i32 0, i32 1
  store i64 6, i64* %stringleninit527, align 4
  %stringdatainit528 = getelementptr inbounds %string, %string* %160, i32 0, i32 0
  %161 = bitcast [7 x i8]* %159 to i8*
  store i8* %161, i8** %stringdatainit528, align 8
  %load529 = load %array.JSONProperty*, %array.JSONProperty** %objectProperties, align 8
  %call530 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %160, %string* null, i64 0, double 0.000000e+00, i1 false, %array.JSONValue* null, %array.JSONProperty* %load529)
  %162 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr531 = getelementptr inbounds %JSONResult, %JSONResult* %162, i32 0, i32 0
  store %JSONValue* %call530, %JSONValue** %memberptr531, align 8
  %load532 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load532

ifcont533:                                        ; preds = %whilecont
  br label %ifcont534

ifcont534:                                        ; preds = %ifcont533, %ifcont256
  %load535 = load %string*, %string** %cleanedValue, align 8
  %alloc536 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %163 = bitcast i8* %alloc536 to [2 x i8]*
  %dataptr537 = getelementptr inbounds [2 x i8], [2 x i8]* %163, i32 0, i32 0
  store i8 91, i8* %dataptr537, align 1
  %dataptr538 = getelementptr inbounds [2 x i8], [2 x i8]* %163, i32 0, i32 1
  store i8 0, i8* %dataptr538, align 1
  %alloc539 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %164 = bitcast i8* %alloc539 to %string*
  %stringleninit540 = getelementptr inbounds %string, %string* %164, i32 0, i32 1
  store i64 1, i64* %stringleninit540, align 4
  %stringdatainit541 = getelementptr inbounds %string, %string* %164, i32 0, i32 0
  %165 = bitcast [2 x i8]* %163 to i8*
  store i8* %165, i8** %stringdatainit541, align 8
  %call542 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.startsWith to i1 (%string*, %string*)*)(%string* %load535, %string* %164)
  %load543 = load %string*, %string** %cleanedValue, align 8
  %alloc544 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %166 = bitcast i8* %alloc544 to [2 x i8]*
  %dataptr545 = getelementptr inbounds [2 x i8], [2 x i8]* %166, i32 0, i32 0
  store i8 93, i8* %dataptr545, align 1
  %dataptr546 = getelementptr inbounds [2 x i8], [2 x i8]* %166, i32 0, i32 1
  store i8 0, i8* %dataptr546, align 1
  %alloc547 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %167 = bitcast i8* %alloc547 to %string*
  %stringleninit548 = getelementptr inbounds %string, %string* %167, i32 0, i32 1
  store i64 1, i64* %stringleninit548, align 4
  %stringdatainit549 = getelementptr inbounds %string, %string* %167, i32 0, i32 0
  %168 = bitcast [2 x i8]* %166 to i8*
  store i8* %168, i8** %stringdatainit549, align 8
  %call550 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.endsWith to i1 (%string*, %string*)*)(%string* %load543, %string* %167)
  %binop551 = and i1 %call542, %call550
  br i1 %binop551, label %if552, label %ifcont754

if552:                                            ; preds = %ifcont534
  %load553 = load %string*, %string** %cleanedValue, align 8
  %169 = load %string*, %string** %cleanedValue, align 8
  %memberptr554 = getelementptr inbounds %string, %string* %169, i32 0, i32 1
  %load555 = load i64, i64* %memberptr554, align 4
  %binop556 = sub i64 %load555, 1
  %call557 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.slice to %string* (%string*, i64, i64)*)(%string* %load553, i64 1, i64 %binop556)
  %call558 = call %string* bitcast (%string* (%string*)* @stark.functions.str.trim to %string* (%string*)*)(%string* %call557)
  %arrayString = alloca %string*, align 8
  store %string* %call558, %string** %arrayString, align 8
  %entries = alloca %array.JSONValue*, align 8
  %alloc559 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([0 x %JSONValue*]* getelementptr ([0 x %JSONValue*], [0 x %JSONValue*]* null, i32 1) to i64))
  %170 = bitcast i8* %alloc559 to [0 x %JSONValue*]*
  %alloc560 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.JSONValue* getelementptr (%array.JSONValue, %array.JSONValue* null, i32 1) to i64))
  %171 = bitcast i8* %alloc560 to %array.JSONValue*
  %arrayleninit561 = getelementptr inbounds %array.JSONValue, %array.JSONValue* %171, i32 0, i32 1
  store i64 0, i64* %arrayleninit561, align 4
  %arrayeleminit562 = getelementptr inbounds %array.JSONValue, %array.JSONValue* %171, i32 0, i32 0
  %172 = bitcast [0 x %JSONValue*]* %170 to %JSONValue**
  store %JSONValue** %172, %JSONValue*** %arrayeleminit562, align 8
  store %array.JSONValue* %171, %array.JSONValue** %entries, align 8
  %objectDepth563 = alloca i64, align 8
  store i64 0, i64* %objectDepth563, align 4
  %arrayDepth564 = alloca i64, align 8
  store i64 0, i64* %arrayDepth564, align 4
  %alloc565 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %173 = bitcast i8* %alloc565 to [1 x i8]*
  %dataptr566 = getelementptr inbounds [1 x i8], [1 x i8]* %173, i32 0, i32 0
  store i8 0, i8* %dataptr566, align 1
  %alloc567 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %174 = bitcast i8* %alloc567 to %string*
  %stringleninit568 = getelementptr inbounds %string, %string* %174, i32 0, i32 1
  store i64 0, i64* %stringleninit568, align 4
  %stringdatainit569 = getelementptr inbounds %string, %string* %174, i32 0, i32 0
  %175 = bitcast [1 x i8]* %173 to i8*
  store i8* %175, i8** %stringdatainit569, align 8
  %entryValue = alloca %string*, align 8
  store %string* %174, %string** %entryValue, align 8
  %insideQuotes570 = alloca i1, align 1
  store i1 false, i1* %insideQuotes570, align 1
  %hasError571 = alloca i1, align 1
  store i1 false, i1* %hasError571, align 1
  %alloc572 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %176 = bitcast i8* %alloc572 to [1 x i8]*
  %dataptr573 = getelementptr inbounds [1 x i8], [1 x i8]* %176, i32 0, i32 0
  store i8 0, i8* %dataptr573, align 1
  %alloc574 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %177 = bitcast i8* %alloc574 to %string*
  %stringleninit575 = getelementptr inbounds %string, %string* %177, i32 0, i32 1
  store i64 0, i64* %stringleninit575, align 4
  %stringdatainit576 = getelementptr inbounds %string, %string* %177, i32 0, i32 0
  %178 = bitcast [1 x i8]* %176 to i8*
  store i8* %178, i8** %stringdatainit576, align 8
  %previousChar577 = alloca %string*, align 8
  store %string* %177, %string** %previousChar577, align 8
  %oi578 = alloca i64, align 8
  store i64 0, i64* %oi578, align 4
  br label %whiletest579

whiletest579:                                     ; preds = %ifcont731, %if552
  %load580 = load i64, i64* %oi578, align 4
  %179 = load %string*, %string** %arrayString, align 8
  %memberptr581 = getelementptr inbounds %string, %string* %179, i32 0, i32 1
  %load582 = load i64, i64* %memberptr581, align 4
  %cmp583 = icmp slt i64 %load580, %load582
  %load584 = load i1, i1* %hasError571, align 1
  %cmp585 = icmp eq i1 %load584, false
  %binop586 = and i1 %cmp583, %cmp585
  br i1 %binop586, label %while587, label %whilecont735

while587:                                         ; preds = %whiletest579
  %load588 = load %string*, %string** %arrayString, align 8
  %load589 = load i64, i64* %oi578, align 4
  %load590 = load i64, i64* %oi578, align 4
  %binop591 = add i64 %load590, 1
  %call592 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.slice to %string* (%string*, i64, i64)*)(%string* %load588, i64 %load589, i64 %binop591)
  %currentChar593 = alloca %string*, align 8
  store %string* %call592, %string** %currentChar593, align 8
  %load594 = load %string*, %string** %currentChar593, align 8
  %alloc595 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %180 = bitcast i8* %alloc595 to [2 x i8]*
  %dataptr596 = getelementptr inbounds [2 x i8], [2 x i8]* %180, i32 0, i32 0
  store i8 34, i8* %dataptr596, align 1
  %dataptr597 = getelementptr inbounds [2 x i8], [2 x i8]* %180, i32 0, i32 1
  store i8 0, i8* %dataptr597, align 1
  %alloc598 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %181 = bitcast i8* %alloc598 to %string*
  %stringleninit599 = getelementptr inbounds %string, %string* %181, i32 0, i32 1
  store i64 1, i64* %stringleninit599, align 4
  %stringdatainit600 = getelementptr inbounds %string, %string* %181, i32 0, i32 0
  %182 = bitcast [2 x i8]* %180 to i8*
  store i8* %182, i8** %stringdatainit600, align 8
  %comp601 = call i1 @stark_runtime_priv_eq_string(%string* %load594, %string* %181)
  %load602 = load %string*, %string** %previousChar577, align 8
  %alloc603 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %183 = bitcast i8* %alloc603 to [2 x i8]*
  %dataptr604 = getelementptr inbounds [2 x i8], [2 x i8]* %183, i32 0, i32 0
  store i8 92, i8* %dataptr604, align 1
  %dataptr605 = getelementptr inbounds [2 x i8], [2 x i8]* %183, i32 0, i32 1
  store i8 0, i8* %dataptr605, align 1
  %alloc606 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %184 = bitcast i8* %alloc606 to %string*
  %stringleninit607 = getelementptr inbounds %string, %string* %184, i32 0, i32 1
  store i64 1, i64* %stringleninit607, align 4
  %stringdatainit608 = getelementptr inbounds %string, %string* %184, i32 0, i32 0
  %185 = bitcast [2 x i8]* %183 to i8*
  store i8* %185, i8** %stringdatainit608, align 8
  %comp609 = call i1 @stark_runtime_priv_neq_string(%string* %load602, %string* %184)
  %binop610 = and i1 %comp601, %comp609
  br i1 %binop610, label %if611, label %ifcont614

if611:                                            ; preds = %while587
  %load612 = load i1, i1* %insideQuotes570, align 1
  %cmp613 = icmp eq i1 %load612, false
  store i1 %cmp613, i1* %insideQuotes570, align 1
  br label %ifcont614

ifcont614:                                        ; preds = %if611, %while587
  %load615 = load %string*, %string** %currentChar593, align 8
  %alloc616 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %186 = bitcast i8* %alloc616 to [2 x i8]*
  %dataptr617 = getelementptr inbounds [2 x i8], [2 x i8]* %186, i32 0, i32 0
  store i8 123, i8* %dataptr617, align 1
  %dataptr618 = getelementptr inbounds [2 x i8], [2 x i8]* %186, i32 0, i32 1
  store i8 0, i8* %dataptr618, align 1
  %alloc619 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %187 = bitcast i8* %alloc619 to %string*
  %stringleninit620 = getelementptr inbounds %string, %string* %187, i32 0, i32 1
  store i64 1, i64* %stringleninit620, align 4
  %stringdatainit621 = getelementptr inbounds %string, %string* %187, i32 0, i32 0
  %188 = bitcast [2 x i8]* %186 to i8*
  store i8* %188, i8** %stringdatainit621, align 8
  %comp622 = call i1 @stark_runtime_priv_eq_string(%string* %load615, %string* %187)
  br i1 %comp622, label %if623, label %ifcont626

if623:                                            ; preds = %ifcont614
  %load624 = load i64, i64* %objectDepth563, align 4
  %binop625 = add i64 %load624, 1
  store i64 %binop625, i64* %objectDepth563, align 4
  br label %ifcont626

ifcont626:                                        ; preds = %if623, %ifcont614
  %load627 = load %string*, %string** %currentChar593, align 8
  %alloc628 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %189 = bitcast i8* %alloc628 to [2 x i8]*
  %dataptr629 = getelementptr inbounds [2 x i8], [2 x i8]* %189, i32 0, i32 0
  store i8 125, i8* %dataptr629, align 1
  %dataptr630 = getelementptr inbounds [2 x i8], [2 x i8]* %189, i32 0, i32 1
  store i8 0, i8* %dataptr630, align 1
  %alloc631 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %190 = bitcast i8* %alloc631 to %string*
  %stringleninit632 = getelementptr inbounds %string, %string* %190, i32 0, i32 1
  store i64 1, i64* %stringleninit632, align 4
  %stringdatainit633 = getelementptr inbounds %string, %string* %190, i32 0, i32 0
  %191 = bitcast [2 x i8]* %189 to i8*
  store i8* %191, i8** %stringdatainit633, align 8
  %comp634 = call i1 @stark_runtime_priv_eq_string(%string* %load627, %string* %190)
  br i1 %comp634, label %if635, label %ifcont638

if635:                                            ; preds = %ifcont626
  %load636 = load i64, i64* %objectDepth563, align 4
  %binop637 = sub i64 %load636, 1
  store i64 %binop637, i64* %objectDepth563, align 4
  br label %ifcont638

ifcont638:                                        ; preds = %if635, %ifcont626
  %load639 = load %string*, %string** %currentChar593, align 8
  %alloc640 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %192 = bitcast i8* %alloc640 to [2 x i8]*
  %dataptr641 = getelementptr inbounds [2 x i8], [2 x i8]* %192, i32 0, i32 0
  store i8 91, i8* %dataptr641, align 1
  %dataptr642 = getelementptr inbounds [2 x i8], [2 x i8]* %192, i32 0, i32 1
  store i8 0, i8* %dataptr642, align 1
  %alloc643 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %193 = bitcast i8* %alloc643 to %string*
  %stringleninit644 = getelementptr inbounds %string, %string* %193, i32 0, i32 1
  store i64 1, i64* %stringleninit644, align 4
  %stringdatainit645 = getelementptr inbounds %string, %string* %193, i32 0, i32 0
  %194 = bitcast [2 x i8]* %192 to i8*
  store i8* %194, i8** %stringdatainit645, align 8
  %comp646 = call i1 @stark_runtime_priv_eq_string(%string* %load639, %string* %193)
  br i1 %comp646, label %if647, label %ifcont650

if647:                                            ; preds = %ifcont638
  %load648 = load i64, i64* %arrayDepth564, align 4
  %binop649 = add i64 %load648, 1
  store i64 %binop649, i64* %arrayDepth564, align 4
  br label %ifcont650

ifcont650:                                        ; preds = %if647, %ifcont638
  %load651 = load %string*, %string** %currentChar593, align 8
  %alloc652 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %195 = bitcast i8* %alloc652 to [2 x i8]*
  %dataptr653 = getelementptr inbounds [2 x i8], [2 x i8]* %195, i32 0, i32 0
  store i8 93, i8* %dataptr653, align 1
  %dataptr654 = getelementptr inbounds [2 x i8], [2 x i8]* %195, i32 0, i32 1
  store i8 0, i8* %dataptr654, align 1
  %alloc655 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %196 = bitcast i8* %alloc655 to %string*
  %stringleninit656 = getelementptr inbounds %string, %string* %196, i32 0, i32 1
  store i64 1, i64* %stringleninit656, align 4
  %stringdatainit657 = getelementptr inbounds %string, %string* %196, i32 0, i32 0
  %197 = bitcast [2 x i8]* %195 to i8*
  store i8* %197, i8** %stringdatainit657, align 8
  %comp658 = call i1 @stark_runtime_priv_eq_string(%string* %load651, %string* %196)
  br i1 %comp658, label %if659, label %ifcont662

if659:                                            ; preds = %ifcont650
  %load660 = load i64, i64* %arrayDepth564, align 4
  %binop661 = sub i64 %load660, 1
  store i64 %binop661, i64* %arrayDepth564, align 4
  br label %ifcont662

ifcont662:                                        ; preds = %if659, %ifcont650
  %load663 = load %string*, %string** %entryValue, align 8
  %load664 = load %string*, %string** %currentChar593, align 8
  %concat665 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load663, %string* %load664)
  store %string* %concat665, %string** %entryValue, align 8
  %load666 = load %string*, %string** %currentChar593, align 8
  %alloc667 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %198 = bitcast i8* %alloc667 to [2 x i8]*
  %dataptr668 = getelementptr inbounds [2 x i8], [2 x i8]* %198, i32 0, i32 0
  store i8 44, i8* %dataptr668, align 1
  %dataptr669 = getelementptr inbounds [2 x i8], [2 x i8]* %198, i32 0, i32 1
  store i8 0, i8* %dataptr669, align 1
  %alloc670 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %199 = bitcast i8* %alloc670 to %string*
  %stringleninit671 = getelementptr inbounds %string, %string* %199, i32 0, i32 1
  store i64 1, i64* %stringleninit671, align 4
  %stringdatainit672 = getelementptr inbounds %string, %string* %199, i32 0, i32 0
  %200 = bitcast [2 x i8]* %198 to i8*
  store i8* %200, i8** %stringdatainit672, align 8
  %comp673 = call i1 @stark_runtime_priv_eq_string(%string* %load666, %string* %199)
  %load674 = load i64, i64* %oi578, align 4
  %binop675 = add i64 %load674, 1
  %201 = load %string*, %string** %arrayString, align 8
  %memberptr676 = getelementptr inbounds %string, %string* %201, i32 0, i32 1
  %load677 = load i64, i64* %memberptr676, align 4
  %cmp678 = icmp eq i64 %binop675, %load677
  %binop679 = or i1 %comp673, %cmp678
  %load680 = load i1, i1* %insideQuotes570, align 1
  %cmp681 = icmp eq i1 %load680, false
  %binop682 = and i1 %binop679, %cmp681
  %load683 = load i64, i64* %objectDepth563, align 4
  %cmp684 = icmp eq i64 %load683, 0
  %binop685 = and i1 %binop682, %cmp684
  %load686 = load i64, i64* %arrayDepth564, align 4
  %cmp687 = icmp eq i64 %load686, 0
  %binop688 = and i1 %binop685, %cmp687
  br i1 %binop688, label %if689, label %ifcont731

if689:                                            ; preds = %ifcont662
  %load690 = load %string*, %string** %entryValue, align 8
  %alloc691 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %202 = bitcast i8* %alloc691 to [2 x i8]*
  %dataptr692 = getelementptr inbounds [2 x i8], [2 x i8]* %202, i32 0, i32 0
  store i8 44, i8* %dataptr692, align 1
  %dataptr693 = getelementptr inbounds [2 x i8], [2 x i8]* %202, i32 0, i32 1
  store i8 0, i8* %dataptr693, align 1
  %alloc694 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %203 = bitcast i8* %alloc694 to %string*
  %stringleninit695 = getelementptr inbounds %string, %string* %203, i32 0, i32 1
  store i64 1, i64* %stringleninit695, align 4
  %stringdatainit696 = getelementptr inbounds %string, %string* %203, i32 0, i32 0
  %204 = bitcast [2 x i8]* %202 to i8*
  store i8* %204, i8** %stringdatainit696, align 8
  %call697 = call i1 bitcast (i1 (%string*, %string*)* @stark.functions.str.endsWith to i1 (%string*, %string*)*)(%string* %load690, %string* %203)
  br i1 %call697, label %if698, label %ifcont704

if698:                                            ; preds = %if689
  %load699 = load %string*, %string** %entryValue, align 8
  %205 = load %string*, %string** %entryValue, align 8
  %memberptr700 = getelementptr inbounds %string, %string* %205, i32 0, i32 1
  %load701 = load i64, i64* %memberptr700, align 4
  %binop702 = sub i64 %load701, 1
  %call703 = call %string* bitcast (%string* (%string*, i64, i64)* @stark.functions.str.slice to %string* (%string*, i64, i64)*)(%string* %load699, i64 0, i64 %binop702)
  store %string* %call703, %string** %entryValue, align 8
  br label %ifcont704

ifcont704:                                        ; preds = %if698, %if689
  %load705 = load %string*, %string** %entryValue, align 8
  %call706 = call %JSONResult* @stark.functions.json.parse(%string* %load705)
  %pr707 = alloca %JSONResult*, align 8
  store %JSONResult* %call706, %JSONResult** %pr707, align 8
  %206 = load %JSONResult*, %JSONResult** %pr707, align 8
  %memberptr708 = getelementptr inbounds %JSONResult, %JSONResult* %206, i32 0, i32 1
  %load709 = load %string*, %string** %memberptr708, align 8
  %207 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr710 = getelementptr inbounds %JSONResult, %JSONResult* %207, i32 0, i32 1
  store %string* %load709, %string** %memberptr710, align 8
  %208 = load %JSONResult*, %JSONResult** %pr707, align 8
  %memberptr711 = getelementptr inbounds %JSONResult, %JSONResult* %208, i32 0, i32 1
  %load712 = load %string*, %string** %memberptr711, align 8
  %209 = ptrtoint %string* %load712 to i64
  %cmp713 = icmp eq i64 %209, 0
  br i1 %cmp713, label %if714, label %else729

if714:                                            ; preds = %ifcont704
  %load715 = load %array.JSONValue*, %array.JSONValue** %entries, align 8
  %210 = load %JSONResult*, %JSONResult** %pr707, align 8
  %memberptr716 = getelementptr inbounds %JSONResult, %JSONResult* %210, i32 0, i32 0
  %load717 = load %JSONValue*, %JSONValue** %memberptr716, align 8
  %alloc718 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %JSONValue*]* getelementptr ([1 x %JSONValue*], [1 x %JSONValue*]* null, i32 1) to i64))
  %211 = bitcast i8* %alloc718 to [1 x %JSONValue*]*
  %elementptr719 = getelementptr inbounds [1 x %JSONValue*], [1 x %JSONValue*]* %211, i32 0, i32 0
  store %JSONValue* %load717, %JSONValue** %elementptr719, align 8
  %alloc720 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.JSONValue* getelementptr (%array.JSONValue, %array.JSONValue* null, i32 1) to i64))
  %212 = bitcast i8* %alloc720 to %array.JSONValue*
  %arrayleninit721 = getelementptr inbounds %array.JSONValue, %array.JSONValue* %212, i32 0, i32 1
  store i64 1, i64* %arrayleninit721, align 4
  %arrayeleminit722 = getelementptr inbounds %array.JSONValue, %array.JSONValue* %212, i32 0, i32 0
  %213 = bitcast [1 x %JSONValue*]* %211 to %JSONValue**
  store %JSONValue** %213, %JSONValue*** %arrayeleminit722, align 8
  %214 = bitcast %array.JSONValue* %load715 to i8*
  %215 = bitcast %array.JSONValue* %212 to i8*
  %concat723 = call i8* bitcast (i8* (i8*, i8*, i64)* @stark_runtime_priv_concat_array to i8* (i8*, i8*, i64)*)(i8* %214, i8* %215, i64 ptrtoint (%JSONValue*** getelementptr (%JSONValue**, %JSONValue*** null, i32 1) to i64))
  %216 = bitcast i8* %concat723 to %array.JSONValue*
  store %array.JSONValue* %216, %array.JSONValue** %entries, align 8
  %alloc724 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %217 = bitcast i8* %alloc724 to [1 x i8]*
  %dataptr725 = getelementptr inbounds [1 x i8], [1 x i8]* %217, i32 0, i32 0
  store i8 0, i8* %dataptr725, align 1
  %alloc726 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %218 = bitcast i8* %alloc726 to %string*
  %stringleninit727 = getelementptr inbounds %string, %string* %218, i32 0, i32 1
  store i64 0, i64* %stringleninit727, align 4
  %stringdatainit728 = getelementptr inbounds %string, %string* %218, i32 0, i32 0
  %219 = bitcast [1 x i8]* %217 to i8*
  store i8* %219, i8** %stringdatainit728, align 8
  store %string* %218, %string** %entryValue, align 8
  br label %ifcont730

else729:                                          ; preds = %ifcont704
  store i1 true, i1* %hasError571, align 1
  br label %ifcont730

ifcont730:                                        ; preds = %else729, %if714
  br label %ifcont731

ifcont731:                                        ; preds = %ifcont730, %ifcont662
  %load732 = load %string*, %string** %currentChar593, align 8
  store %string* %load732, %string** %previousChar577, align 8
  %load733 = load i64, i64* %oi578, align 4
  %binop734 = add i64 %load733, 1
  store i64 %binop734, i64* %oi578, align 4
  br label %whiletest579

whilecont735:                                     ; preds = %whiletest579
  %load736 = load i1, i1* %hasError571, align 1
  %cmp737 = icmp eq i1 %load736, false
  br i1 %cmp737, label %if738, label %ifcont753

if738:                                            ; preds = %whilecont735
  %alloc739 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([6 x i8]* getelementptr ([6 x i8], [6 x i8]* null, i32 1) to i64))
  %220 = bitcast i8* %alloc739 to [6 x i8]*
  %dataptr740 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 0
  store i8 97, i8* %dataptr740, align 1
  %dataptr741 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 1
  store i8 114, i8* %dataptr741, align 1
  %dataptr742 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 2
  store i8 114, i8* %dataptr742, align 1
  %dataptr743 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 3
  store i8 97, i8* %dataptr743, align 1
  %dataptr744 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 4
  store i8 121, i8* %dataptr744, align 1
  %dataptr745 = getelementptr inbounds [6 x i8], [6 x i8]* %220, i32 0, i32 5
  store i8 0, i8* %dataptr745, align 1
  %alloc746 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %221 = bitcast i8* %alloc746 to %string*
  %stringleninit747 = getelementptr inbounds %string, %string* %221, i32 0, i32 1
  store i64 5, i64* %stringleninit747, align 4
  %stringdatainit748 = getelementptr inbounds %string, %string* %221, i32 0, i32 0
  %222 = bitcast [6 x i8]* %220 to i8*
  store i8* %222, i8** %stringdatainit748, align 8
  %load749 = load %array.JSONValue*, %array.JSONValue** %entries, align 8
  %call750 = call %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %221, %string* null, i64 0, double 0.000000e+00, i1 false, %array.JSONValue* %load749, %array.JSONProperty* null)
  %223 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr751 = getelementptr inbounds %JSONResult, %JSONResult* %223, i32 0, i32 0
  store %JSONValue* %call750, %JSONValue** %memberptr751, align 8
  %load752 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load752

ifcont753:                                        ; preds = %whilecont735
  br label %ifcont754

ifcont754:                                        ; preds = %ifcont753, %ifcont534
  %224 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr755 = getelementptr inbounds %JSONResult, %JSONResult* %224, i32 0, i32 0
  %load756 = load %JSONValue*, %JSONValue** %memberptr755, align 8
  %225 = ptrtoint %JSONValue* %load756 to i64
  %cmp757 = icmp eq i64 %225, 0
  %226 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr758 = getelementptr inbounds %JSONResult, %JSONResult* %226, i32 0, i32 1
  %load759 = load %string*, %string** %memberptr758, align 8
  %227 = ptrtoint %string* %load759 to i64
  %cmp760 = icmp eq i64 %227, 0
  %binop761 = and i1 %cmp757, %cmp760
  br i1 %binop761, label %if762, label %ifcont794

if762:                                            ; preds = %ifcont754
  %alloc763 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([24 x i8]* getelementptr ([24 x i8], [24 x i8]* null, i32 1) to i64))
  %228 = bitcast i8* %alloc763 to [24 x i8]*
  %dataptr764 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 0
  store i8 99, i8* %dataptr764, align 1
  %dataptr765 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 1
  store i8 97, i8* %dataptr765, align 1
  %dataptr766 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 2
  store i8 110, i8* %dataptr766, align 1
  %dataptr767 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 3
  store i8 110, i8* %dataptr767, align 1
  %dataptr768 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 4
  store i8 111, i8* %dataptr768, align 1
  %dataptr769 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 5
  store i8 116, i8* %dataptr769, align 1
  %dataptr770 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 6
  store i8 32, i8* %dataptr770, align 1
  %dataptr771 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 7
  store i8 112, i8* %dataptr771, align 1
  %dataptr772 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 8
  store i8 97, i8* %dataptr772, align 1
  %dataptr773 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 9
  store i8 114, i8* %dataptr773, align 1
  %dataptr774 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 10
  store i8 115, i8* %dataptr774, align 1
  %dataptr775 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 11
  store i8 101, i8* %dataptr775, align 1
  %dataptr776 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 12
  store i8 32, i8* %dataptr776, align 1
  %dataptr777 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 13
  store i8 74, i8* %dataptr777, align 1
  %dataptr778 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 14
  store i8 83, i8* %dataptr778, align 1
  %dataptr779 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 15
  store i8 79, i8* %dataptr779, align 1
  %dataptr780 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 16
  store i8 78, i8* %dataptr780, align 1
  %dataptr781 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 17
  store i8 32, i8* %dataptr781, align 1
  %dataptr782 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 18
  store i8 102, i8* %dataptr782, align 1
  %dataptr783 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 19
  store i8 114, i8* %dataptr783, align 1
  %dataptr784 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 20
  store i8 111, i8* %dataptr784, align 1
  %dataptr785 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 21
  store i8 109, i8* %dataptr785, align 1
  %dataptr786 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 22
  store i8 32, i8* %dataptr786, align 1
  %dataptr787 = getelementptr inbounds [24 x i8], [24 x i8]* %228, i32 0, i32 23
  store i8 0, i8* %dataptr787, align 1
  %alloc788 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %229 = bitcast i8* %alloc788 to %string*
  %stringleninit789 = getelementptr inbounds %string, %string* %229, i32 0, i32 1
  store i64 23, i64* %stringleninit789, align 4
  %stringdatainit790 = getelementptr inbounds %string, %string* %229, i32 0, i32 0
  %230 = bitcast [24 x i8]* %228 to i8*
  store i8* %230, i8** %stringdatainit790, align 8
  %load791 = load %string*, %string** %cleanedValue, align 8
  %concat792 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %229, %string* %load791)
  %231 = load %JSONResult*, %JSONResult** %result, align 8
  %memberptr793 = getelementptr inbounds %JSONResult, %JSONResult* %231, i32 0, i32 1
  store %string* %concat792, %string** %memberptr793, align 8
  br label %ifcont794

ifcont794:                                        ; preds = %if762, %ifcont754
  %load795 = load %JSONResult*, %JSONResult** %result, align 8
  ret %JSONResult* %load795
}

define internal %JSONResult* @stark.structs.json.JSONResult.constructor(%JSONValue* %value, %string* %error) {
entry:
  %value1 = alloca %JSONValue*, align 8
  store %JSONValue* %value, %JSONValue** %value1, align 8
  %error2 = alloca %string*, align 8
  store %string* %error, %string** %error2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%JSONResult* getelementptr (%JSONResult, %JSONResult* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %JSONResult*
  %structmemberinit = getelementptr inbounds %JSONResult, %JSONResult* %0, i32 0, i32 0
  %1 = load %JSONValue*, %JSONValue** %value1, align 8
  store %JSONValue* %1, %JSONValue** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %JSONResult, %JSONResult* %0, i32 0, i32 1
  %2 = load %string*, %string** %error2, align 8
  store %string* %2, %string** %structmemberinit3, align 8
  ret %JSONResult* %0
}

declare i1 @stark_runtime_priv_eq_string(%string*, %string*)

define internal %JSONValue* @stark.structs.json.JSONValue.constructor(%string* %type, %string* %stringValue, i64 %intValue, double %doubleValue, i1 %boolValue, %array.JSONValue* %arrayValue, %array.JSONProperty* %objectValue) {
entry:
  %type1 = alloca %string*, align 8
  store %string* %type, %string** %type1, align 8
  %stringValue2 = alloca %string*, align 8
  store %string* %stringValue, %string** %stringValue2, align 8
  %intValue3 = alloca i64, align 8
  store i64 %intValue, i64* %intValue3, align 4
  %doubleValue4 = alloca double, align 8
  store double %doubleValue, double* %doubleValue4, align 8
  %boolValue5 = alloca i1, align 1
  store i1 %boolValue, i1* %boolValue5, align 1
  %arrayValue6 = alloca %array.JSONValue*, align 8
  store %array.JSONValue* %arrayValue, %array.JSONValue** %arrayValue6, align 8
  %objectValue7 = alloca %array.JSONProperty*, align 8
  store %array.JSONProperty* %objectValue, %array.JSONProperty** %objectValue7, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%JSONValue* getelementptr (%JSONValue, %JSONValue* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %JSONValue*
  %structmemberinit = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 0
  %1 = load %string*, %string** %type1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  %structmemberinit8 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 1
  %2 = load %string*, %string** %stringValue2, align 8
  store %string* %2, %string** %structmemberinit8, align 8
  %structmemberinit9 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 2
  %3 = load i64, i64* %intValue3, align 4
  store i64 %3, i64* %structmemberinit9, align 4
  %structmemberinit10 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 3
  %4 = load double, double* %doubleValue4, align 8
  store double %4, double* %structmemberinit10, align 8
  %structmemberinit11 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 4
  %5 = load i1, i1* %boolValue5, align 1
  store i1 %5, i1* %structmemberinit11, align 1
  %structmemberinit12 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 5
  %6 = load %array.JSONValue*, %array.JSONValue** %arrayValue6, align 8
  store %array.JSONValue* %6, %array.JSONValue** %structmemberinit12, align 8
  %structmemberinit13 = getelementptr inbounds %JSONValue, %JSONValue* %0, i32 0, i32 6
  %7 = load %array.JSONProperty*, %array.JSONProperty** %objectValue7, align 8
  store %array.JSONProperty* %7, %array.JSONProperty** %structmemberinit13, align 8
  ret %JSONValue* %0
}

declare i1 @stark_runtime_priv_conv_string_bool(%string*)

declare double @stark_runtime_priv_conv_string_double(%string*)

declare i64 @stark_runtime_priv_conv_string_int(%string*)

define internal %JSONProperty* @stark.structs.json.JSONProperty.constructor(%string* %name, %JSONValue* %value) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %value2 = alloca %JSONValue*, align 8
  store %JSONValue* %value, %JSONValue** %value2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%JSONProperty* getelementptr (%JSONProperty, %JSONProperty* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %JSONProperty*
  %structmemberinit = getelementptr inbounds %JSONProperty, %JSONProperty* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %JSONProperty, %JSONProperty* %0, i32 0, i32 1
  %2 = load %JSONValue*, %JSONValue** %value2, align 8
  store %JSONValue* %2, %JSONValue** %structmemberinit3, align 8
  ret %JSONProperty* %0
}

declare i1 @stark_runtime_priv_neq_string(%string*, %string*)

define %string* @stark.functions.str.subString(%string* %value2, i64 %start3, i64 %end4) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 4
  store i64 %start3, i64* %start, align 4
  %end = alloca i64, align 8
  store i64 0, i64* %end, align 4
  store i64 %end4, i64* %end, align 4
  %3 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %3, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %load5 = load i64, i64* %start, align 4
  %load6 = load i64, i64* %end, align 4
  %call = call %string* @stark_runtime_pub_fromCSubString(i8* %load, i64 %load5, i64 %load6)
  ret %string* %call
}

declare %string* @stark_runtime_pub_fromCSubString(i8*, i64, i64)

define %string* @stark.functions.str.slice(%string* %value2, i64 %start3, i64 %end4) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 4
  store i64 %start3, i64* %start, align 4
  %end = alloca i64, align 8
  store i64 0, i64* %end, align 4
  store i64 %end4, i64* %end, align 4
  %slice = alloca %string*, align 8
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc5 to [1 x i8]*
  %dataptr6 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr6, align 1
  %alloc7 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc7 to %string*
  %stringleninit8 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit8, align 4
  %stringdatainit9 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit9, align 8
  store %string* %4, %string** %slice, align 8
  %6 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %6, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %load10 = load i64, i64* %start, align 4
  %call = call i8* @stark_runtime_pub_offsetCharPointer(i8* %load, i64 %load10)
  %7 = load %string*, %string** %slice, align 8
  %memberptr11 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  store i8* %call, i8** %memberptr11, align 8
  %load12 = load i64, i64* %end, align 4
  %load13 = load i64, i64* %start, align 4
  %binop = sub i64 %load12, %load13
  %8 = load %string*, %string** %slice, align 8
  %memberptr14 = getelementptr inbounds %string, %string* %8, i32 0, i32 1
  store i64 %binop, i64* %memberptr14, align 4
  %load15 = load %string*, %string** %slice, align 8
  ret %string* %load15
}

declare i8* @stark_runtime_pub_offsetCharPointer(i8*, i64)

define %string* @stark.functions.str.trim(%string* %value2) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %3 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %3, i32 0, i32 1
  %load = load i64, i64* %memberptr, align 4
  %cmp = icmp eq i64 %load, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %4 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %4, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %5 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %5, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %5, i32 0, i32 0
  %6 = bitcast [1 x i8]* %4 to i8*
  store i8* %6, i8** %stringdatainit7, align 8
  ret %string* %5

ifcont:                                           ; preds = %entry
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 4
  %7 = load %string*, %string** %value, align 8
  %memberptr8 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  %load9 = load i64, i64* %memberptr8, align 4
  %end = alloca i64, align 8
  store i64 %load9, i64* %end, align 4
  %load10 = load %string*, %string** %value, align 8
  %load11 = load i64, i64* %start, align 4
  %load12 = load i64, i64* %start, align 4
  %binop = add i64 %load12, 1
  %call = call %string* @stark.functions.str.slice(%string* %load10, i64 %load11, i64 %binop)
  %test = alloca %string*, align 8
  store %string* %call, %string** %test, align 8
  br label %whiletest

whiletest:                                        ; preds = %while, %ifcont
  %load13 = load %string*, %string** %test, align 8
  %alloc14 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %8 = bitcast i8* %alloc14 to [2 x i8]*
  %dataptr15 = getelementptr inbounds [2 x i8], [2 x i8]* %8, i32 0, i32 0
  store i8 32, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [2 x i8], [2 x i8]* %8, i32 0, i32 1
  store i8 0, i8* %dataptr16, align 1
  %alloc17 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %9 = bitcast i8* %alloc17 to %string*
  %stringleninit18 = getelementptr inbounds %string, %string* %9, i32 0, i32 1
  store i64 1, i64* %stringleninit18, align 4
  %stringdatainit19 = getelementptr inbounds %string, %string* %9, i32 0, i32 0
  %10 = bitcast [2 x i8]* %8 to i8*
  store i8* %10, i8** %stringdatainit19, align 8
  %comp = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load13, %string* %9)
  %load20 = load %string*, %string** %test, align 8
  %alloc21 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %11 = bitcast i8* %alloc21 to [2 x i8]*
  %dataptr22 = getelementptr inbounds [2 x i8], [2 x i8]* %11, i32 0, i32 0
  store i8 9, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [2 x i8], [2 x i8]* %11, i32 0, i32 1
  store i8 0, i8* %dataptr23, align 1
  %alloc24 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %12 = bitcast i8* %alloc24 to %string*
  %stringleninit25 = getelementptr inbounds %string, %string* %12, i32 0, i32 1
  store i64 1, i64* %stringleninit25, align 4
  %stringdatainit26 = getelementptr inbounds %string, %string* %12, i32 0, i32 0
  %13 = bitcast [2 x i8]* %11 to i8*
  store i8* %13, i8** %stringdatainit26, align 8
  %comp27 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load20, %string* %12)
  %binop28 = or i1 %comp, %comp27
  %load29 = load %string*, %string** %test, align 8
  %alloc30 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %14 = bitcast i8* %alloc30 to [2 x i8]*
  %dataptr31 = getelementptr inbounds [2 x i8], [2 x i8]* %14, i32 0, i32 0
  store i8 13, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [2 x i8], [2 x i8]* %14, i32 0, i32 1
  store i8 0, i8* %dataptr32, align 1
  %alloc33 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %15 = bitcast i8* %alloc33 to %string*
  %stringleninit34 = getelementptr inbounds %string, %string* %15, i32 0, i32 1
  store i64 1, i64* %stringleninit34, align 4
  %stringdatainit35 = getelementptr inbounds %string, %string* %15, i32 0, i32 0
  %16 = bitcast [2 x i8]* %14 to i8*
  store i8* %16, i8** %stringdatainit35, align 8
  %comp36 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load29, %string* %15)
  %binop37 = or i1 %binop28, %comp36
  %load38 = load %string*, %string** %test, align 8
  %alloc39 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %17 = bitcast i8* %alloc39 to [2 x i8]*
  %dataptr40 = getelementptr inbounds [2 x i8], [2 x i8]* %17, i32 0, i32 0
  store i8 10, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [2 x i8], [2 x i8]* %17, i32 0, i32 1
  store i8 0, i8* %dataptr41, align 1
  %alloc42 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %18 = bitcast i8* %alloc42 to %string*
  %stringleninit43 = getelementptr inbounds %string, %string* %18, i32 0, i32 1
  store i64 1, i64* %stringleninit43, align 4
  %stringdatainit44 = getelementptr inbounds %string, %string* %18, i32 0, i32 0
  %19 = bitcast [2 x i8]* %17 to i8*
  store i8* %19, i8** %stringdatainit44, align 8
  %comp45 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load38, %string* %18)
  %binop46 = or i1 %binop37, %comp45
  br i1 %binop46, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load47 = load i64, i64* %start, align 4
  %binop48 = add i64 %load47, 1
  store i64 %binop48, i64* %start, align 4
  %load49 = load %string*, %string** %value, align 8
  %load50 = load i64, i64* %start, align 4
  %load51 = load i64, i64* %start, align 4
  %binop52 = add i64 %load51, 1
  %call53 = call %string* @stark.functions.str.slice(%string* %load49, i64 %load50, i64 %binop52)
  store %string* %call53, %string** %test, align 8
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %load54 = load %string*, %string** %value, align 8
  %load55 = load i64, i64* %end, align 4
  %binop56 = sub i64 %load55, 1
  %load57 = load i64, i64* %end, align 4
  %call58 = call %string* @stark.functions.str.slice(%string* %load54, i64 %binop56, i64 %load57)
  store %string* %call58, %string** %test, align 8
  br label %whiletest59

whiletest59:                                      ; preds = %while95, %whilecont
  %load60 = load %string*, %string** %test, align 8
  %alloc61 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %20 = bitcast i8* %alloc61 to [2 x i8]*
  %dataptr62 = getelementptr inbounds [2 x i8], [2 x i8]* %20, i32 0, i32 0
  store i8 32, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [2 x i8], [2 x i8]* %20, i32 0, i32 1
  store i8 0, i8* %dataptr63, align 1
  %alloc64 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %21 = bitcast i8* %alloc64 to %string*
  %stringleninit65 = getelementptr inbounds %string, %string* %21, i32 0, i32 1
  store i64 1, i64* %stringleninit65, align 4
  %stringdatainit66 = getelementptr inbounds %string, %string* %21, i32 0, i32 0
  %22 = bitcast [2 x i8]* %20 to i8*
  store i8* %22, i8** %stringdatainit66, align 8
  %comp67 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load60, %string* %21)
  %load68 = load %string*, %string** %test, align 8
  %alloc69 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %23 = bitcast i8* %alloc69 to [2 x i8]*
  %dataptr70 = getelementptr inbounds [2 x i8], [2 x i8]* %23, i32 0, i32 0
  store i8 9, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [2 x i8], [2 x i8]* %23, i32 0, i32 1
  store i8 0, i8* %dataptr71, align 1
  %alloc72 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %24 = bitcast i8* %alloc72 to %string*
  %stringleninit73 = getelementptr inbounds %string, %string* %24, i32 0, i32 1
  store i64 1, i64* %stringleninit73, align 4
  %stringdatainit74 = getelementptr inbounds %string, %string* %24, i32 0, i32 0
  %25 = bitcast [2 x i8]* %23 to i8*
  store i8* %25, i8** %stringdatainit74, align 8
  %comp75 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load68, %string* %24)
  %binop76 = or i1 %comp67, %comp75
  %load77 = load %string*, %string** %test, align 8
  %alloc78 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %26 = bitcast i8* %alloc78 to [2 x i8]*
  %dataptr79 = getelementptr inbounds [2 x i8], [2 x i8]* %26, i32 0, i32 0
  store i8 13, i8* %dataptr79, align 1
  %dataptr80 = getelementptr inbounds [2 x i8], [2 x i8]* %26, i32 0, i32 1
  store i8 0, i8* %dataptr80, align 1
  %alloc81 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %27 = bitcast i8* %alloc81 to %string*
  %stringleninit82 = getelementptr inbounds %string, %string* %27, i32 0, i32 1
  store i64 1, i64* %stringleninit82, align 4
  %stringdatainit83 = getelementptr inbounds %string, %string* %27, i32 0, i32 0
  %28 = bitcast [2 x i8]* %26 to i8*
  store i8* %28, i8** %stringdatainit83, align 8
  %comp84 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load77, %string* %27)
  %binop85 = or i1 %binop76, %comp84
  %load86 = load %string*, %string** %test, align 8
  %alloc87 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([2 x i8]* getelementptr ([2 x i8], [2 x i8]* null, i32 1) to i64))
  %29 = bitcast i8* %alloc87 to [2 x i8]*
  %dataptr88 = getelementptr inbounds [2 x i8], [2 x i8]* %29, i32 0, i32 0
  store i8 10, i8* %dataptr88, align 1
  %dataptr89 = getelementptr inbounds [2 x i8], [2 x i8]* %29, i32 0, i32 1
  store i8 0, i8* %dataptr89, align 1
  %alloc90 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %30 = bitcast i8* %alloc90 to %string*
  %stringleninit91 = getelementptr inbounds %string, %string* %30, i32 0, i32 1
  store i64 1, i64* %stringleninit91, align 4
  %stringdatainit92 = getelementptr inbounds %string, %string* %30, i32 0, i32 0
  %31 = bitcast [2 x i8]* %29 to i8*
  store i8* %31, i8** %stringdatainit92, align 8
  %comp93 = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %load86, %string* %30)
  %binop94 = or i1 %binop85, %comp93
  br i1 %binop94, label %while95, label %whilecont103

while95:                                          ; preds = %whiletest59
  %load96 = load i64, i64* %end, align 4
  %binop97 = sub i64 %load96, 1
  store i64 %binop97, i64* %end, align 4
  %load98 = load %string*, %string** %value, align 8
  %load99 = load i64, i64* %end, align 4
  %binop100 = sub i64 %load99, 1
  %load101 = load i64, i64* %end, align 4
  %call102 = call %string* @stark.functions.str.slice(%string* %load98, i64 %binop100, i64 %load101)
  store %string* %call102, %string** %test, align 8
  br label %whiletest59

whilecont103:                                     ; preds = %whiletest59
  %load104 = load i64, i64* %start, align 4
  %load105 = load i64, i64* %end, align 4
  %cmp106 = icmp slt i64 %load104, %load105
  br i1 %cmp106, label %if107, label %else

if107:                                            ; preds = %whilecont103
  %load108 = load %string*, %string** %value, align 8
  %load109 = load i64, i64* %start, align 4
  %load110 = load i64, i64* %end, align 4
  %call111 = call %string* @stark.functions.str.subString(%string* %load108, i64 %load109, i64 %load110)
  ret %string* %call111

else:                                             ; preds = %whilecont103
  %alloc112 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %32 = bitcast i8* %alloc112 to [1 x i8]*
  %dataptr113 = getelementptr inbounds [1 x i8], [1 x i8]* %32, i32 0, i32 0
  store i8 0, i8* %dataptr113, align 1
  %alloc114 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %33 = bitcast i8* %alloc114 to %string*
  %stringleninit115 = getelementptr inbounds %string, %string* %33, i32 0, i32 1
  store i64 0, i64* %stringleninit115, align 4
  %stringdatainit116 = getelementptr inbounds %string, %string* %33, i32 0, i32 0
  %34 = bitcast [1 x i8]* %32 to i8*
  store i8* %34, i8** %stringdatainit116, align 8
  ret %string* %33

ifcont117:                                        ; No predecessors!
  ret %string* %33
}

define i1 @stark.functions.str.startsWith(%string* %value2, %string* %test8) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %test = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %test, align 8
  store %string* %test8, %string** %test, align 8
  %load = load %string*, %string** %value, align 8
  %6 = load %string*, %string** %test, align 8
  %memberptr = getelementptr inbounds %string, %string* %6, i32 0, i32 1
  %load9 = load i64, i64* %memberptr, align 4
  %call = call %string* @stark.functions.str.slice(%string* %load, i64 0, i64 %load9)
  %load10 = load %string*, %string** %test, align 8
  %comp = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %call, %string* %load10)
  ret i1 %comp
}

define i1 @stark.functions.str.endsWith(%string* %value2, %string* %test8) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %test = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %test, align 8
  store %string* %test8, %string** %test, align 8
  %load = load %string*, %string** %value, align 8
  %6 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %6, i32 0, i32 1
  %load9 = load i64, i64* %memberptr, align 4
  %7 = load %string*, %string** %test, align 8
  %memberptr10 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  %load11 = load i64, i64* %memberptr10, align 4
  %binop = sub i64 %load9, %load11
  %8 = load %string*, %string** %value, align 8
  %memberptr12 = getelementptr inbounds %string, %string* %8, i32 0, i32 1
  %load13 = load i64, i64* %memberptr12, align 4
  %call = call %string* @stark.functions.str.slice(%string* %load, i64 %binop, i64 %load13)
  %load14 = load %string*, %string** %test, align 8
  %comp = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_eq_string to i1 (%string*, %string*)*)(%string* %call, %string* %load14)
  ret i1 %comp
}

define %array.string* @stark.functions.str.split(%string* %value2, %string* %separator8) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %separator = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %separator, align 8
  store %string* %separator8, %string** %separator, align 8
  %result = alloca %array.string*, align 8
  %alloc9 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([0 x %string*]* getelementptr ([0 x %string*], [0 x %string*]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc9 to [0 x %string*]*
  %alloc10 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc10 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %7, i32 0, i32 1
  store i64 0, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %7, i32 0, i32 0
  %8 = bitcast [0 x %string*]* %6 to %string**
  store %string** %8, %string*** %arrayeleminit, align 8
  store %array.string* %7, %array.string** %result, align 8
  %9 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %9, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %10 = load %string*, %string** %separator, align 8
  %memberptr11 = getelementptr inbounds %string, %string* %10, i32 0, i32 0
  %load12 = load i8*, i8** %memberptr11, align 8
  %call = call i8* @strstr(i8* %load, i8* %load12)
  %ptr = alloca i8*, align 8
  store i8* %call, i8** %ptr, align 8
  %11 = load %string*, %string** %value, align 8
  %memberptr13 = getelementptr inbounds %string, %string* %11, i32 0, i32 0
  %load14 = load i8*, i8** %memberptr13, align 8
  %startPtr = alloca i8*, align 8
  store i8* %load14, i8** %startPtr, align 8
  %12 = load %string*, %string** %value, align 8
  %memberptr15 = getelementptr inbounds %string, %string* %12, i32 0, i32 1
  %load16 = load i64, i64* %memberptr15, align 4
  %previousLen = alloca i64, align 8
  store i64 %load16, i64* %previousLen, align 4
  %len = alloca i64, align 8
  store i64 0, i64* %len, align 4
  %slice = alloca %string*, align 8
  %alloc17 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %13 = bitcast i8* %alloc17 to [1 x i8]*
  %dataptr18 = getelementptr inbounds [1 x i8], [1 x i8]* %13, i32 0, i32 0
  store i8 0, i8* %dataptr18, align 1
  %alloc19 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %14 = bitcast i8* %alloc19 to %string*
  %stringleninit20 = getelementptr inbounds %string, %string* %14, i32 0, i32 1
  store i64 0, i64* %stringleninit20, align 4
  %stringdatainit21 = getelementptr inbounds %string, %string* %14, i32 0, i32 0
  %15 = bitcast [1 x i8]* %13 to i8*
  store i8* %15, i8** %stringdatainit21, align 8
  store %string* %14, %string** %slice, align 8
  br label %whiletest

whiletest:                                        ; preds = %ifcont, %entry
  %load22 = load i8*, i8** %ptr, align 8
  %cmp = icmp ne i8* %load22, null
  br i1 %cmp, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load23 = load i8*, i8** %ptr, align 8
  %call24 = call i64 @strlen(i8* %load23)
  store i64 %call24, i64* %len, align 4
  %load25 = load i8*, i8** %startPtr, align 8
  %16 = load %string*, %string** %slice, align 8
  %memberptr26 = getelementptr inbounds %string, %string* %16, i32 0, i32 0
  store i8* %load25, i8** %memberptr26, align 8
  %load27 = load i64, i64* %previousLen, align 4
  %load28 = load i64, i64* %len, align 4
  %binop = sub i64 %load27, %load28
  %17 = load %string*, %string** %slice, align 8
  %memberptr29 = getelementptr inbounds %string, %string* %17, i32 0, i32 1
  store i64 %binop, i64* %memberptr29, align 4
  %18 = load %string*, %string** %slice, align 8
  %memberptr30 = getelementptr inbounds %string, %string* %18, i32 0, i32 1
  %load31 = load i64, i64* %memberptr30, align 4
  %cmp32 = icmp sgt i64 %load31, 0
  br i1 %cmp32, label %if, label %ifcont

if:                                               ; preds = %while
  %load33 = load %array.string*, %array.string** %result, align 8
  %load34 = load %string*, %string** %slice, align 8
  %19 = load %string*, %string** %slice, align 8
  %memberptr35 = getelementptr inbounds %string, %string* %19, i32 0, i32 1
  %load36 = load i64, i64* %memberptr35, align 4
  %call37 = call %string* @stark.functions.str.subString(%string* %load34, i64 0, i64 %load36)
  %alloc38 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %string*]* getelementptr ([1 x %string*], [1 x %string*]* null, i32 1) to i64))
  %20 = bitcast i8* %alloc38 to [1 x %string*]*
  %elementptr = getelementptr inbounds [1 x %string*], [1 x %string*]* %20, i32 0, i32 0
  store %string* %call37, %string** %elementptr, align 8
  %alloc39 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %21 = bitcast i8* %alloc39 to %array.string*
  %arrayleninit40 = getelementptr inbounds %array.string, %array.string* %21, i32 0, i32 1
  store i64 1, i64* %arrayleninit40, align 4
  %arrayeleminit41 = getelementptr inbounds %array.string, %array.string* %21, i32 0, i32 0
  %22 = bitcast [1 x %string*]* %20 to %string**
  store %string** %22, %string*** %arrayeleminit41, align 8
  %23 = bitcast %array.string* %load33 to i8*
  %24 = bitcast %array.string* %21 to i8*
  %concat = call i8* bitcast (i8* (i8*, i8*, i64)* @stark_runtime_priv_concat_array to i8* (i8*, i8*, i64)*)(i8* %23, i8* %24, i64 ptrtoint (%string*** getelementptr (%string**, %string*** null, i32 1) to i64))
  %25 = bitcast i8* %concat to %array.string*
  store %array.string* %25, %array.string** %result, align 8
  br label %ifcont

ifcont:                                           ; preds = %if, %while
  %load42 = load i8*, i8** %ptr, align 8
  %26 = load %string*, %string** %separator, align 8
  %memberptr43 = getelementptr inbounds %string, %string* %26, i32 0, i32 1
  %load44 = load i64, i64* %memberptr43, align 4
  %call45 = call i8* @stark_runtime_pub_offsetCharPointer(i8* %load42, i64 %load44)
  store i8* %call45, i8** %startPtr, align 8
  %load46 = load i64, i64* %len, align 4
  %27 = load %string*, %string** %separator, align 8
  %memberptr47 = getelementptr inbounds %string, %string* %27, i32 0, i32 1
  %load48 = load i64, i64* %memberptr47, align 4
  %binop49 = sub i64 %load46, %load48
  store i64 %binop49, i64* %previousLen, align 4
  %load50 = load i8*, i8** %startPtr, align 8
  %28 = load %string*, %string** %separator, align 8
  %memberptr51 = getelementptr inbounds %string, %string* %28, i32 0, i32 0
  %load52 = load i8*, i8** %memberptr51, align 8
  %call53 = call i8* @strstr(i8* %load50, i8* %load52)
  store i8* %call53, i8** %ptr, align 8
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %load54 = load i64, i64* %previousLen, align 4
  %cmp55 = icmp sgt i64 %load54, 0
  br i1 %cmp55, label %if56, label %ifcont79

if56:                                             ; preds = %whilecont
  %load57 = load i8*, i8** %startPtr, align 8
  %29 = load %string*, %string** %slice, align 8
  %memberptr58 = getelementptr inbounds %string, %string* %29, i32 0, i32 0
  store i8* %load57, i8** %memberptr58, align 8
  %30 = load %string*, %string** %value, align 8
  %memberptr59 = getelementptr inbounds %string, %string* %30, i32 0, i32 1
  %load60 = load i64, i64* %memberptr59, align 4
  %load61 = load i64, i64* %len, align 4
  %binop62 = sub i64 %load60, %load61
  %31 = load %string*, %string** %slice, align 8
  %memberptr63 = getelementptr inbounds %string, %string* %31, i32 0, i32 1
  store i64 %binop62, i64* %memberptr63, align 4
  %load64 = load %string*, %string** %slice, align 8
  %load65 = load %string*, %string** %separator, align 8
  %comp = call i1 bitcast (i1 (%string*, %string*)* @stark_runtime_priv_neq_string to i1 (%string*, %string*)*)(%string* %load64, %string* %load65)
  br i1 %comp, label %if66, label %ifcont78

if66:                                             ; preds = %if56
  %load67 = load %array.string*, %array.string** %result, align 8
  %load68 = load %string*, %string** %slice, align 8
  %32 = load %string*, %string** %slice, align 8
  %memberptr69 = getelementptr inbounds %string, %string* %32, i32 0, i32 1
  %load70 = load i64, i64* %memberptr69, align 4
  %call71 = call %string* @stark.functions.str.subString(%string* %load68, i64 0, i64 %load70)
  %alloc72 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %string*]* getelementptr ([1 x %string*], [1 x %string*]* null, i32 1) to i64))
  %33 = bitcast i8* %alloc72 to [1 x %string*]*
  %elementptr73 = getelementptr inbounds [1 x %string*], [1 x %string*]* %33, i32 0, i32 0
  store %string* %call71, %string** %elementptr73, align 8
  %alloc74 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %34 = bitcast i8* %alloc74 to %array.string*
  %arrayleninit75 = getelementptr inbounds %array.string, %array.string* %34, i32 0, i32 1
  store i64 1, i64* %arrayleninit75, align 4
  %arrayeleminit76 = getelementptr inbounds %array.string, %array.string* %34, i32 0, i32 0
  %35 = bitcast [1 x %string*]* %33 to %string**
  store %string** %35, %string*** %arrayeleminit76, align 8
  %36 = bitcast %array.string* %load67 to i8*
  %37 = bitcast %array.string* %34 to i8*
  %concat77 = call i8* bitcast (i8* (i8*, i8*, i64)* @stark_runtime_priv_concat_array to i8* (i8*, i8*, i64)*)(i8* %36, i8* %37, i64 ptrtoint (%string*** getelementptr (%string**, %string*** null, i32 1) to i64))
  %38 = bitcast i8* %concat77 to %array.string*
  store %array.string* %38, %array.string** %result, align 8
  br label %ifcont78

ifcont78:                                         ; preds = %if66, %if56
  br label %ifcont79

ifcont79:                                         ; preds = %ifcont78, %whilecont
  %load80 = load %array.string*, %array.string** %result, align 8
  ret %array.string* %load80
}

declare i8* @strstr(i8*, i8*)

declare i64 @strlen(i8*)

define i1 @stark.functions.str.contains(%string* %value2, %string* %subString8) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %subString = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %subString, align 8
  store %string* %subString8, %string** %subString, align 8
  %6 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %6, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %7 = load %string*, %string** %subString, align 8
  %memberptr9 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %load10 = load i8*, i8** %memberptr9, align 8
  %call = call i8* @strstr(i8* %load, i8* %load10)
  %cmp = icmp ne i8* %call, null
  ret i1 %cmp
}

define %string* @stark.functions.str.join(%array.string* %parts2, %string* %separator5) {
entry:
  %parts = alloca %array.string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([0 x %string*]* getelementptr ([0 x %string*], [0 x %string*]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [0 x %string*]*
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.string* getelementptr (%array.string, %array.string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %array.string*
  %arrayleninit = getelementptr inbounds %array.string, %array.string* %1, i32 0, i32 1
  store i64 0, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.string, %array.string* %1, i32 0, i32 0
  %2 = bitcast [0 x %string*]* %0 to %string**
  store %string** %2, %string*** %arrayeleminit, align 8
  store %array.string* %1, %array.string** %parts, align 8
  store %array.string* %parts2, %array.string** %parts, align 8
  %separator = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc4 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc4 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit, align 8
  store %string* %4, %string** %separator, align 8
  store %string* %separator5, %string** %separator, align 8
  %alloc6 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc6 to [1 x i8]*
  %dataptr7 = getelementptr inbounds [1 x i8], [1 x i8]* %6, i32 0, i32 0
  store i8 0, i8* %dataptr7, align 1
  %alloc8 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc8 to %string*
  %stringleninit9 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 0, i64* %stringleninit9, align 4
  %stringdatainit10 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [1 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit10, align 8
  %result = alloca %string*, align 8
  store %string* %7, %string** %result, align 8
  %load = load %array.string*, %array.string** %parts, align 8
  %9 = ptrtoint %array.string* %load to i64
  %cmp = icmp ne i64 %9, 0
  br i1 %cmp, label %if, label %ifcont26

if:                                               ; preds = %entry
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 4
  br label %whiletest

whiletest:                                        ; preds = %ifcont, %if
  %load11 = load i64, i64* %i, align 4
  %10 = load %array.string*, %array.string** %parts, align 8
  %memberptr = getelementptr inbounds %array.string, %array.string* %10, i32 0, i32 1
  %load12 = load i64, i64* %memberptr, align 4
  %cmp13 = icmp slt i64 %load11, %load12
  br i1 %cmp13, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load14 = load %string*, %string** %result, align 8
  %load15 = load i64, i64* %i, align 4
  %11 = trunc i64 %load15 to i32
  %12 = load %array.string*, %array.string** %parts, align 8
  %elementptrs = getelementptr inbounds %array.string, %array.string* %12, i32 0, i32 0
  %13 = load %string**, %string*** %elementptrs, align 8
  %14 = getelementptr inbounds %string*, %string** %13, i32 %11
  %load16 = load %string*, %string** %14, align 8
  %concat = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load14, %string* %load16)
  store %string* %concat, %string** %result, align 8
  %load17 = load i64, i64* %i, align 4
  %binop = add i64 %load17, 1
  store i64 %binop, i64* %i, align 4
  %load18 = load i64, i64* %i, align 4
  %15 = load %array.string*, %array.string** %parts, align 8
  %memberptr19 = getelementptr inbounds %array.string, %array.string* %15, i32 0, i32 1
  %load20 = load i64, i64* %memberptr19, align 4
  %cmp21 = icmp ne i64 %load18, %load20
  br i1 %cmp21, label %if22, label %ifcont

if22:                                             ; preds = %while
  %load23 = load %string*, %string** %result, align 8
  %load24 = load %string*, %string** %separator, align 8
  %concat25 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load23, %string* %load24)
  store %string* %concat25, %string** %result, align 8
  br label %ifcont

ifcont:                                           ; preds = %if22, %while
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  br label %ifcont26

ifcont26:                                         ; preds = %whilecont, %entry
  %load27 = load %string*, %string** %result, align 8
  ret %string* %load27
}

define %string* @stark.functions.str.replace(%string* %value2, %string* %old8, %string* %new14) {
entry:
  %value = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc1 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc1 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %value, align 8
  store %string* %value2, %string** %value, align 8
  %old = alloca %string*, align 8
  %alloc3 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %3 = bitcast i8* %alloc3 to [1 x i8]*
  %dataptr4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i32 0, i32 0
  store i8 0, i8* %dataptr4, align 1
  %alloc5 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %4 = bitcast i8* %alloc5 to %string*
  %stringleninit6 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 0, i64* %stringleninit6, align 4
  %stringdatainit7 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [1 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit7, align 8
  store %string* %4, %string** %old, align 8
  store %string* %old8, %string** %old, align 8
  %new = alloca %string*, align 8
  %alloc9 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc9 to [1 x i8]*
  %dataptr10 = getelementptr inbounds [1 x i8], [1 x i8]* %6, i32 0, i32 0
  store i8 0, i8* %dataptr10, align 1
  %alloc11 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %7 = bitcast i8* %alloc11 to %string*
  %stringleninit12 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 0, i64* %stringleninit12, align 4
  %stringdatainit13 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [1 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit13, align 8
  store %string* %7, %string** %new, align 8
  store %string* %new14, %string** %new, align 8
  %load = load %string*, %string** %value, align 8
  %load15 = load %string*, %string** %old, align 8
  %call = call i1 @stark.functions.str.contains(%string* %load, %string* %load15)
  br i1 %call, label %if, label %else

if:                                               ; preds = %entry
  %load16 = load %string*, %string** %value, align 8
  %load17 = load %string*, %string** %old, align 8
  %call18 = call %array.string* @stark.functions.str.split(%string* %load16, %string* %load17)
  %parts = alloca %array.string*, align 8
  store %array.string* %call18, %array.string** %parts, align 8
  %alloc19 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %9 = bitcast i8* %alloc19 to [1 x i8]*
  %dataptr20 = getelementptr inbounds [1 x i8], [1 x i8]* %9, i32 0, i32 0
  store i8 0, i8* %dataptr20, align 1
  %alloc21 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %10 = bitcast i8* %alloc21 to %string*
  %stringleninit22 = getelementptr inbounds %string, %string* %10, i32 0, i32 1
  store i64 0, i64* %stringleninit22, align 4
  %stringdatainit23 = getelementptr inbounds %string, %string* %10, i32 0, i32 0
  %11 = bitcast [1 x i8]* %9 to i8*
  store i8* %11, i8** %stringdatainit23, align 8
  %result = alloca %string*, align 8
  store %string* %10, %string** %result, align 8
  %load24 = load %string*, %string** %value, align 8
  %load25 = load %string*, %string** %old, align 8
  %call26 = call i1 @stark.functions.str.startsWith(%string* %load24, %string* %load25)
  br i1 %call26, label %if27, label %ifcont

if27:                                             ; preds = %if
  %load28 = load %string*, %string** %result, align 8
  %load29 = load %string*, %string** %new, align 8
  %concat = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load28, %string* %load29)
  store %string* %concat, %string** %result, align 8
  br label %ifcont

ifcont:                                           ; preds = %if27, %if
  %load30 = load %string*, %string** %result, align 8
  %load31 = load %array.string*, %array.string** %parts, align 8
  %load32 = load %string*, %string** %new, align 8
  %call33 = call %string* @stark.functions.str.join(%array.string* %load31, %string* %load32)
  %concat34 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load30, %string* %call33)
  store %string* %concat34, %string** %result, align 8
  %load35 = load %string*, %string** %value, align 8
  %load36 = load %string*, %string** %old, align 8
  %call37 = call i1 @stark.functions.str.endsWith(%string* %load35, %string* %load36)
  br i1 %call37, label %if38, label %ifcont42

if38:                                             ; preds = %ifcont
  %load39 = load %string*, %string** %result, align 8
  %load40 = load %string*, %string** %new, align 8
  %concat41 = call %string* bitcast (%string* (%string*, %string*)* @stark_runtime_priv_concat_string to %string* (%string*, %string*)*)(%string* %load39, %string* %load40)
  store %string* %concat41, %string** %result, align 8
  br label %ifcont42

ifcont42:                                         ; preds = %if38, %ifcont
  %load43 = load %string*, %string** %result, align 8
  ret %string* %load43

else:                                             ; preds = %entry
  %12 = load %string*, %string** %value, align 8
  %memberptr = getelementptr inbounds %string, %string* %12, i32 0, i32 0
  %load44 = load i8*, i8** %memberptr, align 8
  %call45 = call %string* bitcast (%string* (i8*)* @stark_runtime_pub_fromCString to %string* (i8*)*)(i8* %load44)
  ret %string* %call45

ifcont46:                                         ; No predecessors!
  ret %string* %call45
}