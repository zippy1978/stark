; ModuleID = 'main'
source_filename = "main"

%Shop = type { i64, %string* }
%string = type { i8*, i64 }
%ShopGroup = type { %array.Shop*, %string* }
%array.Shop = type { %Shop**, i64 }

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
  store %string* %2, %string** %structmemberinit3, align 8
  ret %Shop* %0
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

define %ShopGroup* @stark.structs.main.ShopGroup.constructor(%array.Shop* %shops, %string* %name) {
entry:
  %shops1 = alloca %array.Shop*, align 8
  store %array.Shop* %shops, %array.Shop** %shops1, align 8
  %name2 = alloca %string*, align 8
  store %string* %name, %string** %name2, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %0 = bitcast i8* %alloc to %ShopGroup*
  %structmemberinit = getelementptr inbounds %ShopGroup, %ShopGroup* %0, i32 0, i32 0
  %1 = load %array.Shop*, %array.Shop** %shops1, align 8
  store %array.Shop* %1, %array.Shop** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %ShopGroup, %ShopGroup* %0, i32 0, i32 1
  %2 = load %string*, %string** %name2, align 8
  store %string* %2, %string** %structmemberinit3, align 8
  ret %ShopGroup* %0
}

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  %s = alloca %Shop*, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 4))
  %0 = bitcast i8* %alloc to [4 x i8]*
  %dataptr = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 0
  store i8 116, i8* %dataptr, align 1
  %dataptr1 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 1
  store i8 101, i8* %dataptr1, align 1
  %dataptr2 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 2
  store i8 115, i8* %dataptr2, align 1
  %dataptr3 = getelementptr inbounds [4 x i8], [4 x i8]* %0, i32 0, i32 3
  store i8 116, i8* %dataptr3, align 1
  %alloc4 = call i8* @stark_runtime_priv_mm_alloc(i64 1)
  %1 = bitcast i8* %alloc4 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 4, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  ; fuck
  store [4 x i8]* %0, i8** %stringdatainit, align 8
  %call = call %Shop* @stark.structs.main.Shop.constructor(i64 1, %string* %1)
  store %Shop* %call, %Shop** %s, align 8
  %2 = load %Shop*, %Shop** %s, align 8
  %memberptr = getelementptr inbounds %Shop, %Shop* %2, i32 0, i32 1
  %load = load %string*, %string** %memberptr, align 8
  call void @stark_runtime_pub_println(%string* %load)
  ret i64 0
}

declare void @stark_runtime_priv_mm_init()

declare void @stark_runtime_pub_println(%string*)