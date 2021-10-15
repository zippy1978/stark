; ModuleID = 'time'
source_filename = "time"

%Time = type { i8* }
%string = type { i8*, i64 }

define %Time* @stark.functions.time.now() {
entry:
  %call = call i64 @time(i8* null)
  %call1 = call i8* @stark_runtime_pub_toIntPointer(i64 %call)
  %call2 = call i8* @localtime(i8* %call1)
  %call3 = call %Time* @stark.structs.time.Time.constructor(i8* %call2)
  ret %Time* %call3
}

declare i64 @time(i8*)

declare i8* @stark_runtime_pub_toIntPointer(i64)

declare i8* @localtime(i8*)

define internal %Time* @stark.structs.time.Time.constructor(i8* %timeInfo) {
entry:
  %timeInfo1 = alloca i8*, align 8
  store i8* %timeInfo, i8** %timeInfo1, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Time*
  %structmemberinit = getelementptr inbounds %Time, %Time* %0, i32 0, i32 0
  %1 = load i8*, i8** %timeInfo1, align 8
  store i8* %1, i8** %structmemberinit, align 8
  ret %Time* %0
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

define %string* @stark.functions.time.formatTime(%Time* %t1, %string* %format3) {
entry:
  %t = alloca %Time*, align 8
  store %Time zeroinitializer, %Time** %t, align 8
  store %Time* %t1, %Time** %t, align 8
  %format = alloca %string*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 0)
  %0 = bitcast i8* %alloc to [0 x i8]*
  %alloc2 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc2 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [0 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %format, align 8
  store %string* %format3, %string** %format, align 8
  %load = load %string*, %string** %format, align 8
  %call = call i8* @stark_runtime_pub_toCString(%string* %load)
  %cstr = alloca i8*, align 8
  store i8* %call, i8** %cstr, align 8
  %load4 = load i8*, i8** %cstr, align 8
  %3 = load %string*, %string** %format, align 8
  %memberptr = getelementptr inbounds %string, %string* %3, i32 0, i32 1
  %load5 = load i64, i64* %memberptr, align 4
  %load6 = load %string*, %string** %format, align 8
  %call7 = call i8* @stark_runtime_pub_toCString(%string* %load6)
  %4 = load %Time*, %Time** %t, align 8
  %memberptr8 = getelementptr inbounds %Time, %Time* %4, i32 0, i32 0
  %load9 = load i8*, i8** %memberptr8, align 8
  %call10 = call i64 @strftime(i8* %load4, i64 %load5, i8* %call7, i8* %load9)
  %load11 = load i8*, i8** %cstr, align 8
  %call12 = call %string* @stark_runtime_pub_fromCString(i8* %load11)
  ret %string* %call12
}

declare i8* @stark_runtime_pub_toCString(%string*)

declare i64 @strftime(i8*, i64, i8*, i8*)

declare %string* @stark_runtime_pub_fromCString(i8*)