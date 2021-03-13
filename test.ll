; ModuleID = 'main'
source_filename = "main"

%Employee = type { %string*, i64 }
%string = type { i8*, i64 }
%array.Employee = type { %Employee**, i64 }
%Company = type { %string*, %array.Employee* }

define %Employee @stark.functions.main.createEmployee(%string* %name1, i64 %age2) {
entry:
  %name = alloca %string*, align 8
  store %string* %name1, %string** %name, align 8
  %age = alloca i64, align 8
  store i64 %age2, i64* %age, align 4
  %load = load %string*, %string** %name, align 8
  %load3 = load i64, i64* %age, align 4
  %call = call %Employee* @stark.structs.main.Employee.constructor(%string* %load, i64 %load3)
  ret %Employee* %call
}

define internal %Employee* @stark.structs.main.Employee.constructor(%string* %name, i64 %age) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %age2 = alloca i64, align 8
  store i64 %age, i64* %age2, align 4
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %0 = bitcast i8* %alloc to %Employee*
  %structmemberinit = getelementptr inbounds %Employee, %Employee* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %Employee, %Employee* %0, i32 0, i32 1
  %2 = load i64, i64* %age2, align 4
  store i64 %2, i64* %structmemberinit3, align 4
  ret %Employee* %0
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  %tony = alloca %Employee*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 10))
  %0 = bitcast i8* %alloc to [10 x i8]*
  %dataptr = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 0
  store i8 84, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 1
  store i8 111, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 2
  store i8 110, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 3
  store i8 121, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 4
  store i8 32, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 5
  store i8 83, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 6
  store i8 116, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 7
  store i8 97, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 8
  store i8 114, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [10 x i8], [10 x i8]* %0, i32 0, i32 9
  store i8 107, i8* %dataptr9, align 1
  %alloc10 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %1 = bitcast i8* %alloc10 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 10, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [10 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %call = call %Employee* bitcast (%Employee (%string*, i64)* @stark.functions.main.createEmployee to %Employee* (%string*, i64)*)(%string* %1, i64 40)
  store %Employee* %call, %Employee** %tony, align 8
  %pepper = alloca %Employee*, align 8
  %alloc11 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 11))
  %3 = bitcast i8* %alloc11 to [11 x i8]*
  %dataptr12 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 0
  store i8 80, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 1
  store i8 101, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 2
  store i8 112, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 3
  store i8 112, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 4
  store i8 101, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 5
  store i8 114, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 6
  store i8 32, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 7
  store i8 80, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 8
  store i8 111, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 9
  store i8 116, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [11 x i8], [11 x i8]* %3, i32 0, i32 10
  store i8 115, i8* %dataptr22, align 1
  %alloc23 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %4 = bitcast i8* %alloc23 to %string*
  %stringleninit24 = getelementptr inbounds %string, %string* %4, i32 0, i32 1
  store i64 11, i64* %stringleninit24, align 4
  %stringdatainit25 = getelementptr inbounds %string, %string* %4, i32 0, i32 0
  %5 = bitcast [11 x i8]* %3 to i8*
  store i8* %5, i8** %stringdatainit25, align 8
  %call26 = call %Employee* bitcast (%Employee (%string*, i64)* @stark.functions.main.createEmployee to %Employee* (%string*, i64)*)(%string* %4, i64 38)
  store %Employee* %call26, %Employee** %pepper, align 8
  %alloc27 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 16))
  %6 = bitcast i8* %alloc27 to [16 x i8]*
  %dataptr28 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 0
  store i8 83, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 1
  store i8 116, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 2
  store i8 97, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 3
  store i8 114, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 4
  store i8 107, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 5
  store i8 32, i8* %dataptr33, align 1
  %dataptr34 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 6
  store i8 73, i8* %dataptr34, align 1
  %dataptr35 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 7
  store i8 110, i8* %dataptr35, align 1
  %dataptr36 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 8
  store i8 100, i8* %dataptr36, align 1
  %dataptr37 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 9
  store i8 117, i8* %dataptr37, align 1
  %dataptr38 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 10
  store i8 115, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 11
  store i8 116, i8* %dataptr39, align 1
  %dataptr40 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 12
  store i8 114, i8* %dataptr40, align 1
  %dataptr41 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 13
  store i8 105, i8* %dataptr41, align 1
  %dataptr42 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 14
  store i8 101, i8* %dataptr42, align 1
  %dataptr43 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i32 0, i32 15
  store i8 115, i8* %dataptr43, align 1
  %alloc44 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %7 = bitcast i8* %alloc44 to %string*
  %stringleninit45 = getelementptr inbounds %string, %string* %7, i32 0, i32 1
  store i64 16, i64* %stringleninit45, align 4
  %stringdatainit46 = getelementptr inbounds %string, %string* %7, i32 0, i32 0
  %8 = bitcast [16 x i8]* %6 to i8*
  store i8* %8, i8** %stringdatainit46, align 8
  %load = load %Employee*, %Employee** %tony, align 8
  %load47 = load %Employee*, %Employee** %pepper, align 8
  %alloc48 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64), i64 2))
  %9 = bitcast i8* %alloc48 to [2 x %Employee*]*
  %elementptr = getelementptr inbounds [2 x %Employee*], [2 x %Employee*]* %9, i32 0, i32 0
  store %Employee* %load, %Employee** %elementptr, align 8
  %elementptr49 = getelementptr inbounds [2 x %Employee*], [2 x %Employee*]* %9, i32 0, i32 1
  store %Employee* %load47, %Employee** %elementptr49, align 8
  %alloc50 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (i1** getelementptr (i1*, i1** null, i32 1) to i64))
  %10 = bitcast i8* %alloc50 to %array.Employee*
  %arrayleninit = getelementptr inbounds %array.Employee, %array.Employee* %10, i32 0, i32 1
  store i64 2, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.Employee, %array.Employee* %10, i32 0, i32 0
  %11 = bitcast [2 x %Employee*]* %9 to %Employee**
  store %Employee** %11, %Employee*** %arrayeleminit, align 8
  %call51 = call %Company* @stark.structs.main.Company.constructor(%string* %7, %array.Employee* %10)
  %starkIndustries = alloca %Company*, align 8
  store %Company* %call51, %Company** %starkIndustries, align 8
  %alloc52 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 9))
  %12 = bitcast i8* %alloc52 to [9 x i8]*
  %dataptr53 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 0
  store i8 67, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 1
  store i8 111, i8* %dataptr54, align 1
  %dataptr55 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 2
  store i8 109, i8* %dataptr55, align 1
  %dataptr56 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 3
  store i8 112, i8* %dataptr56, align 1
  %dataptr57 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 4
  store i8 97, i8* %dataptr57, align 1
  %dataptr58 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 5
  store i8 110, i8* %dataptr58, align 1
  %dataptr59 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 6
  store i8 121, i8* %dataptr59, align 1
  %dataptr60 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 7
  store i8 58, i8* %dataptr60, align 1
  %dataptr61 = getelementptr inbounds [9 x i8], [9 x i8]* %12, i32 0, i32 8
  store i8 32, i8* %dataptr61, align 1
  %alloc62 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %13 = bitcast i8* %alloc62 to %string*
  %stringleninit63 = getelementptr inbounds %string, %string* %13, i32 0, i32 1
  store i64 9, i64* %stringleninit63, align 4
  %stringdatainit64 = getelementptr inbounds %string, %string* %13, i32 0, i32 0
  %14 = bitcast [9 x i8]* %12 to i8*
  store i8* %14, i8** %stringdatainit64, align 8
  call void @stark_runtime_pub_print(%string* %13)
  %15 = load %Company*, %Company** %starkIndustries, align 8
  %memberptr = getelementptr inbounds %Company, %Company* %15, i32 0, i32 0
  %load65 = load %string*, %string** %memberptr, align 8
  call void @stark_runtime_pub_println(%string* %load65)
  %alloc66 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 21))
  %16 = bitcast i8* %alloc66 to [21 x i8]*
  %dataptr67 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 0
  store i8 78, i8* %dataptr67, align 1
  %dataptr68 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 1
  store i8 117, i8* %dataptr68, align 1
  %dataptr69 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 2
  store i8 109, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 3
  store i8 98, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 4
  store i8 101, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 5
  store i8 114, i8* %dataptr72, align 1
  %dataptr73 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 6
  store i8 32, i8* %dataptr73, align 1
  %dataptr74 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 7
  store i8 111, i8* %dataptr74, align 1
  %dataptr75 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 8
  store i8 102, i8* %dataptr75, align 1
  %dataptr76 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 9
  store i8 32, i8* %dataptr76, align 1
  %dataptr77 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 10
  store i8 101, i8* %dataptr77, align 1
  %dataptr78 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 11
  store i8 109, i8* %dataptr78, align 1
  %dataptr79 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 12
  store i8 112, i8* %dataptr79, align 1
  %dataptr80 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 13
  store i8 108, i8* %dataptr80, align 1
  %dataptr81 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 14
  store i8 111, i8* %dataptr81, align 1
  %dataptr82 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 15
  store i8 121, i8* %dataptr82, align 1
  %dataptr83 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 16
  store i8 101, i8* %dataptr83, align 1
  %dataptr84 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 17
  store i8 101, i8* %dataptr84, align 1
  %dataptr85 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 18
  store i8 115, i8* %dataptr85, align 1
  %dataptr86 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 19
  store i8 58, i8* %dataptr86, align 1
  %dataptr87 = getelementptr inbounds [21 x i8], [21 x i8]* %16, i32 0, i32 20
  store i8 32, i8* %dataptr87, align 1
  %alloc88 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %17 = bitcast i8* %alloc88 to %string*
  %stringleninit89 = getelementptr inbounds %string, %string* %17, i32 0, i32 1
  store i64 21, i64* %stringleninit89, align 4
  %stringdatainit90 = getelementptr inbounds %string, %string* %17, i32 0, i32 0
  %18 = bitcast [21 x i8]* %16 to i8*
  store i8* %18, i8** %stringdatainit90, align 8
  call void @stark_runtime_pub_print(%string* %17)
  %19 = load %Company*, %Company** %starkIndustries, align 8
  %memberptr91 = getelementptr inbounds %Company, %Company* %19, i32 0, i32 1
  %20 = load %array.Employee*, %array.Employee** %memberptr91, align 8
  %memberptr92 = getelementptr inbounds %array.Employee, %array.Employee* %20, i32 0, i32 1
  %load93 = load i64, i64* %memberptr92, align 4
  %conv = call %string* @stark_runtime_priv_conv_int_string(i64 %load93)
  call void @stark_runtime_pub_println(%string* %conv)
  %alloc94 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 14))
  %21 = bitcast i8* %alloc94 to [14 x i8]*
  %dataptr95 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 0
  store i8 69, i8* %dataptr95, align 1
  %dataptr96 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 1
  store i8 109, i8* %dataptr96, align 1
  %dataptr97 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 2
  store i8 112, i8* %dataptr97, align 1
  %dataptr98 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 3
  store i8 108, i8* %dataptr98, align 1
  %dataptr99 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 4
  store i8 111, i8* %dataptr99, align 1
  %dataptr100 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 5
  store i8 121, i8* %dataptr100, align 1
  %dataptr101 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 6
  store i8 101, i8* %dataptr101, align 1
  %dataptr102 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 7
  store i8 101, i8* %dataptr102, align 1
  %dataptr103 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 8
  store i8 115, i8* %dataptr103, align 1
  %dataptr104 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 9
  store i8 32, i8* %dataptr104, align 1
  %dataptr105 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 10
  store i8 97, i8* %dataptr105, align 1
  %dataptr106 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 11
  store i8 114, i8* %dataptr106, align 1
  %dataptr107 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 12
  store i8 101, i8* %dataptr107, align 1
  %dataptr108 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 13
  store i8 58, i8* %dataptr108, align 1
  %alloc109 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %22 = bitcast i8* %alloc109 to %string*
  %stringleninit110 = getelementptr inbounds %string, %string* %22, i32 0, i32 1
  store i64 14, i64* %stringleninit110, align 4
  %stringdatainit111 = getelementptr inbounds %string, %string* %22, i32 0, i32 0
  %23 = bitcast [14 x i8]* %21 to i8*
  store i8* %23, i8** %stringdatainit111, align 8
  call void @stark_runtime_pub_println(%string* %22)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 4
  br label %whiletest

whiletest:                                        ; preds = %while, %entry
  %load112 = load i64, i64* %i, align 4
  %24 = load %Company*, %Company** %starkIndustries, align 8
  %memberptr113 = getelementptr inbounds %Company, %Company* %24, i32 0, i32 1
  %25 = load %array.Employee*, %array.Employee** %memberptr113, align 8
  %memberptr114 = getelementptr inbounds %array.Employee, %array.Employee* %25, i32 0, i32 1
  %load115 = load i64, i64* %memberptr114, align 4
  %cmp = icmp slt i64 %load112, %load115
  br i1 %cmp, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %e = alloca %Employee*, align 8
  %26 = load %Company*, %Company** %starkIndustries, align 8
  %memberptr116 = getelementptr inbounds %Company, %Company* %26, i32 0, i32 1
  %load117 = load i64, i64* %i, align 4
  %27 = trunc i64 %load117 to i32
  %28 = load %array.Employee*, %array.Employee** %memberptr116, align 8
  %elementptrs = getelementptr inbounds %array.Employee, %array.Employee* %28, i32 0, i32 0
  %29 = load %Employee**, %Employee*** %elementptrs, align 8
  %30 = getelementptr inbounds %Employee*, %Employee** %29, i32 %27
  %load118 = load %Employee*, %Employee** %30, align 8
  store %Employee* %load118, %Employee** %e, align 8
  %alloc119 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 2))
  %31 = bitcast i8* %alloc119 to [2 x i8]*
  %dataptr120 = getelementptr inbounds [2 x i8], [2 x i8]* %31, i32 0, i32 0
  store i8 45, i8* %dataptr120, align 1
  %dataptr121 = getelementptr inbounds [2 x i8], [2 x i8]* %31, i32 0, i32 1
  store i8 32, i8* %dataptr121, align 1
  %alloc122 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %32 = bitcast i8* %alloc122 to %string*
  %stringleninit123 = getelementptr inbounds %string, %string* %32, i32 0, i32 1
  store i64 2, i64* %stringleninit123, align 4
  %stringdatainit124 = getelementptr inbounds %string, %string* %32, i32 0, i32 0
  %33 = bitcast [2 x i8]* %31 to i8*
  store i8* %33, i8** %stringdatainit124, align 8
  call void @stark_runtime_pub_print(%string* %32)
  %34 = load %Employee*, %Employee** %e, align 8
  %memberptr125 = getelementptr inbounds %Employee, %Employee* %34, i32 0, i32 0
  %load126 = load %string*, %string** %memberptr125, align 8
  call void @stark_runtime_pub_print(%string* %load126)
  %alloc127 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 6))
  %35 = bitcast i8* %alloc127 to [6 x i8]*
  %dataptr128 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 0
  store i8 32, i8* %dataptr128, align 1
  %dataptr129 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 1
  store i8 40, i8* %dataptr129, align 1
  %dataptr130 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 2
  store i8 97, i8* %dataptr130, align 1
  %dataptr131 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 3
  store i8 103, i8* %dataptr131, align 1
  %dataptr132 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 4
  store i8 101, i8* %dataptr132, align 1
  %dataptr133 = getelementptr inbounds [6 x i8], [6 x i8]* %35, i32 0, i32 5
  store i8 32, i8* %dataptr133, align 1
  %alloc134 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %36 = bitcast i8* %alloc134 to %string*
  %stringleninit135 = getelementptr inbounds %string, %string* %36, i32 0, i32 1
  store i64 6, i64* %stringleninit135, align 4
  %stringdatainit136 = getelementptr inbounds %string, %string* %36, i32 0, i32 0
  %37 = bitcast [6 x i8]* %35 to i8*
  store i8* %37, i8** %stringdatainit136, align 8
  call void @stark_runtime_pub_print(%string* %36)
  %38 = load %Employee*, %Employee** %e, align 8
  %memberptr137 = getelementptr inbounds %Employee, %Employee* %38, i32 0, i32 1
  %load138 = load i64, i64* %memberptr137, align 4
  %conv139 = call %string* @stark_runtime_priv_conv_int_string(i64 %load138)
  call void @stark_runtime_pub_print(%string* %conv139)
  %alloc140 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64))
  %39 = bitcast i8* %alloc140 to [1 x i8]*
  %dataptr141 = getelementptr inbounds [1 x i8], [1 x i8]* %39, i32 0, i32 0
  store i8 41, i8* %dataptr141, align 1
  %alloc142 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %40 = bitcast i8* %alloc142 to %string*
  %stringleninit143 = getelementptr inbounds %string, %string* %40, i32 0, i32 1
  store i64 1, i64* %stringleninit143, align 4
  %stringdatainit144 = getelementptr inbounds %string, %string* %40, i32 0, i32 0
  %41 = bitcast [1 x i8]* %39 to i8*
  store i8* %41, i8** %stringdatainit144, align 8
  call void @stark_runtime_pub_println(%string* %40)
  %load145 = load i64, i64* %i, align 4
  %binop = add i64 %load145, 1
  store i64 %binop, i64* %i, align 4
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  ret i64 0
}

declare void @stark_runtime_priv_mm_init()

define internal %Company* @stark.structs.main.Company.constructor(%string* %name, %array.Employee* %employees) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %employees2 = alloca %array.Employee*, align 8
  store %array.Employee* %employees, %array.Employee** %employees2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 1)
  %0 = bitcast i8* %alloc to %Company*
  %structmemberinit = getelementptr inbounds %Company, %Company* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %Company, %Company* %0, i32 0, i32 1
  %2 = load %array.Employee*, %array.Employee** %employees2, align 8
  store %array.Employee* %2, %array.Employee** %structmemberinit3, align 8
  ret %Company* %0
}

declare void @stark_runtime_pub_print(%string*)

declare void @stark_runtime_pub_println(%string*)

declare %string* @stark_runtime_priv_conv_int_string(i64)