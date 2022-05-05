; ModuleID = 'main'
source_filename = "main"
target triple = "x86_64-apple-macosx12.0.0"

%gfx.ContextResult = type { %gfx.Context*, %string* }
%gfx.Context = type { i8*, i8*, i8*, %array.gfx.Font*, %array.gfx.Bitmap*, i8* }
%array.gfx.Font = type { %gfx.Font**, i64 }
%gfx.Font = type { %string*, i8* }
%array.gfx.Bitmap = type { %gfx.Bitmap**, i64 }
%gfx.Bitmap = type { i8* }
%string = type { i8*, i64 }
%gfx.Color = type { double, double, double, double }
%gfx.Event = type { %string* }
%struct.string_t = type { i8*, i64 }
%struct.allegro_event_t = type { %struct.string_t* }
%struct.allegro_color_t = type { double, double, double, double }
%struct.ALLEGRO_FONT = type opaque
%struct.ALLEGRO_BITMAP = type opaque
%Bitmap = type { i8* }
%Context = type { i8*, i8*, i8*, %array.Font*, %array.Bitmap*, i8* }
%array.Font = type { %Font**, i64 }
%Font = type { %string*, i8* }
%array.Bitmap = type { %Bitmap**, i64 }
%ContextResult = type { %Context*, %string* }
%Event = type { %string* }
%Color = type { double, double, double, double }

@.str = private unnamed_addr constant [14 x i8] c"DISPLAY_CLOSE\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"TIMER\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"UNKOWN\00", align 1

define i64 @main() {
entry:
  call void @stark_runtime_priv_mm_init()
  %call = call i64 bitcast (i64 (i64 (i64, i8*)*)* @stark.functions.gfx.run to i64 (i64 (i64, i8*)*)*)(i64 (i64, i8*)* @stark.functions.main.stark.functions.main.gfxdemo.src.main.st.anon1)
  ret i64 %call
}

declare void @stark_runtime_priv_mm_init()

define internal i64 @stark.functions.main.stark.functions.main.gfxdemo.src.main.st.anon1(i64 %argc1, i8* %argv2) {
entry:
  %argc = alloca i64, align 8
  store i64 0, i64* %argc, align 4
  store i64 %argc1, i64* %argc, align 4
  %argv = alloca i8*, align 8
  store i8* null, i8** %argv, align 8
  store i8* %argv2, i8** %argv, align 8
  %call = call %gfx.ContextResult* bitcast (%ContextResult* (i64, i64)* @stark.functions.gfx.init to %gfx.ContextResult* (i64, i64)*)(i64 1024, i64 768)
  %cr = alloca %gfx.ContextResult*, align 8
  store %gfx.ContextResult* %call, %gfx.ContextResult** %cr, align 8
  %0 = load %gfx.ContextResult*, %gfx.ContextResult** %cr, align 8
  %memberptr = getelementptr inbounds %gfx.ContextResult, %gfx.ContextResult* %0, i32 0, i32 1
  %load = load %string*, %string** %memberptr, align 8
  %1 = ptrtoint %string* %load to i64
  %cmp = icmp ne i64 %1, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([19 x i8]* getelementptr ([19 x i8], [19 x i8]* null, i32 1) to i64))
  %2 = bitcast i8* %alloc to [19 x i8]*
  %dataptr = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 0
  store i8 97, i8* %dataptr, align 1
  %dataptr3 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 1
  store i8 110, i8* %dataptr3, align 1
  %dataptr4 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 2
  store i8 32, i8* %dataptr4, align 1
  %dataptr5 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 3
  store i8 101, i8* %dataptr5, align 1
  %dataptr6 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 4
  store i8 114, i8* %dataptr6, align 1
  %dataptr7 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 5
  store i8 114, i8* %dataptr7, align 1
  %dataptr8 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 6
  store i8 111, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 7
  store i8 114, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 8
  store i8 32, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 9
  store i8 111, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 10
  store i8 99, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 11
  store i8 99, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 12
  store i8 117, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 13
  store i8 114, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 14
  store i8 101, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 15
  store i8 100, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 16
  store i8 58, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 17
  store i8 32, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [19 x i8], [19 x i8]* %2, i32 0, i32 18
  store i8 0, i8* %dataptr20, align 1
  %alloc21 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %3 = bitcast i8* %alloc21 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %3, i32 0, i32 1
  store i64 18, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %3, i32 0, i32 0
  %4 = bitcast [19 x i8]* %2 to i8*
  store i8* %4, i8** %stringdatainit, align 8
  %5 = load %gfx.ContextResult*, %gfx.ContextResult** %cr, align 8
  %memberptr22 = getelementptr inbounds %gfx.ContextResult, %gfx.ContextResult* %5, i32 0, i32 1
  %load23 = load %string*, %string** %memberptr22, align 8
  %concat = call %string* @stark_runtime_priv_concat_string(%string* %3, %string* %load23)
  call void @stark_runtime_pub_println(%string* %concat)
  ret i64 1

ifcont:                                           ; preds = %entry
  %6 = load %gfx.ContextResult*, %gfx.ContextResult** %cr, align 8
  %memberptr24 = getelementptr inbounds %gfx.ContextResult, %gfx.ContextResult* %6, i32 0, i32 0
  %load25 = load %gfx.Context*, %gfx.Context** %memberptr24, align 8
  %context = alloca %gfx.Context*, align 8
  store %gfx.Context* %load25, %gfx.Context** %context, align 8
  %load26 = load %gfx.Context*, %gfx.Context** %context, align 8
  %alloc27 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([8 x i8]* getelementptr ([8 x i8], [8 x i8]* null, i32 1) to i64))
  %7 = bitcast i8* %alloc27 to [8 x i8]*
  %dataptr28 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 0
  store i8 98, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 1
  store i8 117, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 2
  store i8 105, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 3
  store i8 108, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 4
  store i8 116, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 5
  store i8 105, i8* %dataptr33, align 1
  %dataptr34 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 6
  store i8 110, i8* %dataptr34, align 1
  %dataptr35 = getelementptr inbounds [8 x i8], [8 x i8]* %7, i32 0, i32 7
  store i8 0, i8* %dataptr35, align 1
  %alloc36 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %8 = bitcast i8* %alloc36 to %string*
  %stringleninit37 = getelementptr inbounds %string, %string* %8, i32 0, i32 1
  store i64 7, i64* %stringleninit37, align 4
  %stringdatainit38 = getelementptr inbounds %string, %string* %8, i32 0, i32 0
  %9 = bitcast [8 x i8]* %7 to i8*
  store i8* %9, i8** %stringdatainit38, align 8
  %call39 = call %gfx.Font* bitcast (%Font* (%Context*, %string*)* @stark.functions.gfx.getFont to %gfx.Font* (%gfx.Context*, %string*)*)(%gfx.Context* %load26, %string* %8)
  %builtinFont = alloca %gfx.Font*, align 8
  store %gfx.Font* %call39, %gfx.Font** %builtinFont, align 8
  %call40 = call %gfx.Color* @stark.structs.gfx.Color.constructor(double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00)
  %whiteColor = alloca %gfx.Color*, align 8
  store %gfx.Color* %call40, %gfx.Color** %whiteColor, align 8
  %call41 = call %gfx.Color* @stark.structs.gfx.Color.constructor(double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double 1.000000e+00)
  %blackColor = alloca %gfx.Color*, align 8
  store %gfx.Color* %call41, %gfx.Color** %blackColor, align 8
  %call42 = call %gfx.Color* @stark.structs.gfx.Color.constructor(double 1.000000e+00, double 0.000000e+00, double 0.000000e+00, double 1.000000e+00)
  %redColor = alloca %gfx.Color*, align 8
  store %gfx.Color* %call42, %gfx.Color** %redColor, align 8
  %call43 = call %gfx.Color* @stark.structs.gfx.Color.constructor(double 0.000000e+00, double 1.000000e+00, double 0.000000e+00, double 1.000000e+00)
  %greenColor = alloca %gfx.Color*, align 8
  store %gfx.Color* %call43, %gfx.Color** %greenColor, align 8
  %call44 = call %gfx.Color* @stark.structs.gfx.Color.constructor(double 0.000000e+00, double 0.000000e+00, double 1.000000e+00, double 1.000000e+00)
  %blueColor = alloca %gfx.Color*, align 8
  store %gfx.Color* %call44, %gfx.Color** %blueColor, align 8
  %load45 = load %gfx.Context*, %gfx.Context** %context, align 8
  %alloc46 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([51 x i8]* getelementptr ([51 x i8], [51 x i8]* null, i32 1) to i64))
  %10 = bitcast i8* %alloc46 to [51 x i8]*
  %dataptr47 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 0
  store i8 47, i8* %dataptr47, align 1
  %dataptr48 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 1
  store i8 85, i8* %dataptr48, align 1
  %dataptr49 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 2
  store i8 115, i8* %dataptr49, align 1
  %dataptr50 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 3
  store i8 101, i8* %dataptr50, align 1
  %dataptr51 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 4
  store i8 114, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 5
  store i8 115, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 6
  store i8 47, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 7
  store i8 103, i8* %dataptr54, align 1
  %dataptr55 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 8
  store i8 103, i8* %dataptr55, align 1
  %dataptr56 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 9
  store i8 114, i8* %dataptr56, align 1
  %dataptr57 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 10
  store i8 111, i8* %dataptr57, align 1
  %dataptr58 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 11
  store i8 117, i8* %dataptr58, align 1
  %dataptr59 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 12
  store i8 115, i8* %dataptr59, align 1
  %dataptr60 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 13
  store i8 115, i8* %dataptr60, align 1
  %dataptr61 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 14
  store i8 101, i8* %dataptr61, align 1
  %dataptr62 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 15
  store i8 116, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 16
  store i8 47, i8* %dataptr63, align 1
  %dataptr64 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 17
  store i8 80, i8* %dataptr64, align 1
  %dataptr65 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 18
  store i8 114, i8* %dataptr65, align 1
  %dataptr66 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 19
  store i8 111, i8* %dataptr66, align 1
  %dataptr67 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 20
  store i8 106, i8* %dataptr67, align 1
  %dataptr68 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 21
  store i8 101, i8* %dataptr68, align 1
  %dataptr69 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 22
  store i8 99, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 23
  store i8 116, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 24
  store i8 115, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 25
  store i8 47, i8* %dataptr72, align 1
  %dataptr73 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 26
  store i8 112, i8* %dataptr73, align 1
  %dataptr74 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 27
  store i8 101, i8* %dataptr74, align 1
  %dataptr75 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 28
  store i8 114, i8* %dataptr75, align 1
  %dataptr76 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 29
  store i8 115, i8* %dataptr76, align 1
  %dataptr77 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 30
  store i8 111, i8* %dataptr77, align 1
  %dataptr78 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 31
  store i8 47, i8* %dataptr78, align 1
  %dataptr79 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 32
  store i8 115, i8* %dataptr79, align 1
  %dataptr80 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 33
  store i8 116, i8* %dataptr80, align 1
  %dataptr81 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 34
  store i8 97, i8* %dataptr81, align 1
  %dataptr82 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 35
  store i8 114, i8* %dataptr82, align 1
  %dataptr83 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 36
  store i8 107, i8* %dataptr83, align 1
  %dataptr84 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 37
  store i8 108, i8* %dataptr84, align 1
  %dataptr85 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 38
  store i8 97, i8* %dataptr85, align 1
  %dataptr86 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 39
  store i8 110, i8* %dataptr86, align 1
  %dataptr87 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 40
  store i8 103, i8* %dataptr87, align 1
  %dataptr88 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 41
  store i8 47, i8* %dataptr88, align 1
  %dataptr89 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 42
  store i8 116, i8* %dataptr89, align 1
  %dataptr90 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 43
  store i8 111, i8* %dataptr90, align 1
  %dataptr91 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 44
  store i8 110, i8* %dataptr91, align 1
  %dataptr92 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 45
  store i8 121, i8* %dataptr92, align 1
  %dataptr93 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 46
  store i8 46, i8* %dataptr93, align 1
  %dataptr94 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 47
  store i8 112, i8* %dataptr94, align 1
  %dataptr95 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 48
  store i8 110, i8* %dataptr95, align 1
  %dataptr96 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 49
  store i8 103, i8* %dataptr96, align 1
  %dataptr97 = getelementptr inbounds [51 x i8], [51 x i8]* %10, i32 0, i32 50
  store i8 0, i8* %dataptr97, align 1
  %alloc98 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %11 = bitcast i8* %alloc98 to %string*
  %stringleninit99 = getelementptr inbounds %string, %string* %11, i32 0, i32 1
  store i64 50, i64* %stringleninit99, align 4
  %stringdatainit100 = getelementptr inbounds %string, %string* %11, i32 0, i32 0
  %12 = bitcast [51 x i8]* %10 to i8*
  store i8* %12, i8** %stringdatainit100, align 8
  %call101 = call %gfx.Bitmap* bitcast (%Bitmap* (%Context*, %string*)* @stark.functions.gfx.loadBitmap to %gfx.Bitmap* (%gfx.Context*, %string*)*)(%gfx.Context* %load45, %string* %11)
  %tonyBitmap = alloca %gfx.Bitmap*, align 8
  store %gfx.Bitmap* %call101, %gfx.Bitmap** %tonyBitmap, align 8
  %shouldClose = alloca i1, align 1
  store i1 false, i1* %shouldClose, align 1
  %redraw = alloca i1, align 1
  store i1 true, i1* %redraw, align 1
  %x = alloca i64, align 8
  store i64 0, i64* %x, align 4
  %event = alloca %gfx.Event*, align 8
  store %gfx.Event* null, %gfx.Event** %event, align 8
  %alloc102 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([14 x i8]* getelementptr ([14 x i8], [14 x i8]* null, i32 1) to i64))
  %13 = bitcast i8* %alloc102 to [14 x i8]*
  %dataptr103 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 0
  store i8 68, i8* %dataptr103, align 1
  %dataptr104 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 1
  store i8 73, i8* %dataptr104, align 1
  %dataptr105 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 2
  store i8 83, i8* %dataptr105, align 1
  %dataptr106 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 3
  store i8 80, i8* %dataptr106, align 1
  %dataptr107 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 4
  store i8 76, i8* %dataptr107, align 1
  %dataptr108 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 5
  store i8 65, i8* %dataptr108, align 1
  %dataptr109 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 6
  store i8 89, i8* %dataptr109, align 1
  %dataptr110 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 7
  store i8 95, i8* %dataptr110, align 1
  %dataptr111 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 8
  store i8 67, i8* %dataptr111, align 1
  %dataptr112 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 9
  store i8 76, i8* %dataptr112, align 1
  %dataptr113 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 10
  store i8 79, i8* %dataptr113, align 1
  %dataptr114 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 11
  store i8 83, i8* %dataptr114, align 1
  %dataptr115 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 12
  store i8 69, i8* %dataptr115, align 1
  %dataptr116 = getelementptr inbounds [14 x i8], [14 x i8]* %13, i32 0, i32 13
  store i8 0, i8* %dataptr116, align 1
  %alloc117 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %14 = bitcast i8* %alloc117 to %string*
  %stringleninit118 = getelementptr inbounds %string, %string* %14, i32 0, i32 1
  store i64 13, i64* %stringleninit118, align 4
  %stringdatainit119 = getelementptr inbounds %string, %string* %14, i32 0, i32 0
  %15 = bitcast [14 x i8]* %13 to i8*
  store i8* %15, i8** %stringdatainit119, align 8
  %DISPLAY_CLOSE = alloca %string*, align 8
  store %string* %14, %string** %DISPLAY_CLOSE, align 8
  %alloc120 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([6 x i8]* getelementptr ([6 x i8], [6 x i8]* null, i32 1) to i64))
  %16 = bitcast i8* %alloc120 to [6 x i8]*
  %dataptr121 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 0
  store i8 84, i8* %dataptr121, align 1
  %dataptr122 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 1
  store i8 73, i8* %dataptr122, align 1
  %dataptr123 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 2
  store i8 77, i8* %dataptr123, align 1
  %dataptr124 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 3
  store i8 69, i8* %dataptr124, align 1
  %dataptr125 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 4
  store i8 82, i8* %dataptr125, align 1
  %dataptr126 = getelementptr inbounds [6 x i8], [6 x i8]* %16, i32 0, i32 5
  store i8 0, i8* %dataptr126, align 1
  %alloc127 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %17 = bitcast i8* %alloc127 to %string*
  %stringleninit128 = getelementptr inbounds %string, %string* %17, i32 0, i32 1
  store i64 5, i64* %stringleninit128, align 4
  %stringdatainit129 = getelementptr inbounds %string, %string* %17, i32 0, i32 0
  %18 = bitcast [6 x i8]* %16 to i8*
  store i8* %18, i8** %stringdatainit129, align 8
  %TIMER = alloca %string*, align 8
  store %string* %17, %string** %TIMER, align 8
  br label %whiletest

whiletest:                                        ; preds = %ifcont172, %ifcont
  %load130 = load i1, i1* %shouldClose, align 1
  %cmp131 = icmp ne i1 %load130, true
  br i1 %cmp131, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %load132 = load %gfx.Context*, %gfx.Context** %context, align 8
  %call133 = call %gfx.Event* bitcast (%Event* (%Context*)* @stark.functions.gfx.waitForEvent to %gfx.Event* (%gfx.Context*)*)(%gfx.Context* %load132)
  store %gfx.Event* %call133, %gfx.Event** %event, align 8
  %19 = load %gfx.Event*, %gfx.Event** %event, align 8
  %memberptr134 = getelementptr inbounds %gfx.Event, %gfx.Event* %19, i32 0, i32 0
  %load135 = load %string*, %string** %memberptr134, align 8
  %load136 = load %string*, %string** %DISPLAY_CLOSE, align 8
  %comp = call i1 @stark_runtime_priv_eq_string(%string* %load135, %string* %load136)
  br i1 %comp, label %if137, label %ifcont138

if137:                                            ; preds = %while
  store i1 true, i1* %shouldClose, align 1
  br label %ifcont138

ifcont138:                                        ; preds = %if137, %while
  %20 = load %gfx.Event*, %gfx.Event** %event, align 8
  %memberptr139 = getelementptr inbounds %gfx.Event, %gfx.Event* %20, i32 0, i32 0
  %load140 = load %string*, %string** %memberptr139, align 8
  %load141 = load %string*, %string** %TIMER, align 8
  %comp142 = call i1 @stark_runtime_priv_eq_string(%string* %load140, %string* %load141)
  br i1 %comp142, label %if143, label %ifcont144

if143:                                            ; preds = %ifcont138
  store i1 true, i1* %redraw, align 1
  br label %ifcont144

ifcont144:                                        ; preds = %if143, %ifcont138
  %load145 = load i1, i1* %redraw, align 1
  %cmp146 = icmp eq i1 %load145, true
  %load147 = load %gfx.Context*, %gfx.Context** %context, align 8
  %call148 = call i1 bitcast (i1 (%Context*)* @stark.functions.gfx.isEventQueueEmpty to i1 (%gfx.Context*)*)(%gfx.Context* %load147)
  %binop = and i1 %cmp146, %call148
  br i1 %binop, label %if149, label %ifcont172

if149:                                            ; preds = %ifcont144
  %load150 = load %gfx.Font*, %gfx.Font** %builtinFont, align 8
  %load151 = load %gfx.Color*, %gfx.Color** %whiteColor, align 8
  %alloc152 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint ([14 x i8]* getelementptr ([14 x i8], [14 x i8]* null, i32 1) to i64))
  %21 = bitcast i8* %alloc152 to [14 x i8]*
  %dataptr153 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 0
  store i8 72, i8* %dataptr153, align 1
  %dataptr154 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 1
  store i8 101, i8* %dataptr154, align 1
  %dataptr155 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 2
  store i8 108, i8* %dataptr155, align 1
  %dataptr156 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 3
  store i8 108, i8* %dataptr156, align 1
  %dataptr157 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 4
  store i8 111, i8* %dataptr157, align 1
  %dataptr158 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 5
  store i8 32, i8* %dataptr158, align 1
  %dataptr159 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 6
  store i8 83, i8* %dataptr159, align 1
  %dataptr160 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 7
  store i8 116, i8* %dataptr160, align 1
  %dataptr161 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 8
  store i8 97, i8* %dataptr161, align 1
  %dataptr162 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 9
  store i8 114, i8* %dataptr162, align 1
  %dataptr163 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 10
  store i8 107, i8* %dataptr163, align 1
  %dataptr164 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 11
  store i8 32, i8* %dataptr164, align 1
  %dataptr165 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 12
  store i8 33, i8* %dataptr165, align 1
  %dataptr166 = getelementptr inbounds [14 x i8], [14 x i8]* %21, i32 0, i32 13
  store i8 0, i8* %dataptr166, align 1
  %alloc167 = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %22 = bitcast i8* %alloc167 to %string*
  %stringleninit168 = getelementptr inbounds %string, %string* %22, i32 0, i32 1
  store i64 13, i64* %stringleninit168, align 4
  %stringdatainit169 = getelementptr inbounds %string, %string* %22, i32 0, i32 0
  %23 = bitcast [14 x i8]* %21 to i8*
  store i8* %23, i8** %stringdatainit169, align 8
  call void bitcast (void (%Font*, %Color*, i64, i64, i64, %string*)* @stark.functions.gfx.drawText to void (%gfx.Font*, %gfx.Color*, i64, i64, i64, %string*)*)(%gfx.Font* %load150, %gfx.Color* %load151, i64 20, i64 20, i64 0, %string* %22)
  %load170 = load %gfx.Bitmap*, %gfx.Bitmap** %tonyBitmap, align 8
  %load171 = load i64, i64* %x, align 4
  call void bitcast (void (%Bitmap*, i64, i64, i64)* @stark.functions.gfx.drawBitmap to void (%gfx.Bitmap*, i64, i64, i64)*)(%gfx.Bitmap* %load170, i64 %load171, i64 50, i64 0)
  call void @stark.functions.gfx.flipDisplay()
  store i1 false, i1* %redraw, align 1
  br label %ifcont172

ifcont172:                                        ; preds = %if149, %ifcont144
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  %load173 = load %gfx.Context*, %gfx.Context** %context, align 8
  call void bitcast (void (%Context*)* @stark.functions.gfx.destroy to void (%gfx.Context*)*)(%gfx.Context* %load173)
  ret i64 0
}

declare i8* @stark_runtime_priv_mm_alloc(i64)

declare %string* @stark_runtime_priv_concat_string(%string*, %string*)

declare void @stark_runtime_pub_println(%string*)

define internal %gfx.Color* @stark.structs.gfx.Color.constructor(double %r, double %g, double %b, double %a) {
entry:
  %r1 = alloca double, align 8
  store double %r, double* %r1, align 8
  %g2 = alloca double, align 8
  store double %g, double* %g2, align 8
  %b3 = alloca double, align 8
  store double %b, double* %b3, align 8
  %a4 = alloca double, align 8
  store double %a, double* %a4, align 8
  %alloc = call i8* @stark_runtime_priv_mm_alloc(i64 ptrtoint (%gfx.Color* getelementptr (%gfx.Color, %gfx.Color* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %gfx.Color*
  %structmemberinit = getelementptr inbounds %gfx.Color, %gfx.Color* %0, i32 0, i32 0
  %1 = load double, double* %r1, align 8
  store double %1, double* %structmemberinit, align 8
  %structmemberinit5 = getelementptr inbounds %gfx.Color, %gfx.Color* %0, i32 0, i32 1
  %2 = load double, double* %g2, align 8
  store double %2, double* %structmemberinit5, align 8
  %structmemberinit6 = getelementptr inbounds %gfx.Color, %gfx.Color* %0, i32 0, i32 2
  %3 = load double, double* %b3, align 8
  store double %3, double* %structmemberinit6, align 8
  %structmemberinit7 = getelementptr inbounds %gfx.Color, %gfx.Color* %0, i32 0, i32 3
  %4 = load double, double* %a4, align 8
  store double %4, double* %structmemberinit7, align 8
  ret %gfx.Color* %0
}

declare i1 @stark_runtime_priv_eq_string(%string*, %string*)

; Function Attrs: nounwind ssp uwtable
define %struct.string_t* @createAllegroString(i8* %0) local_unnamed_addr #0 {
  %2 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 16) #5
  %3 = bitcast i8* %2 to %struct.string_t*
  %4 = tail call i64 @strlen(i8* nonnull dereferenceable(1) %0)
  %5 = getelementptr inbounds i8, i8* %2, i64 8
  %6 = bitcast i8* %5 to i64*
  store i64 %4, i64* %6, align 8, !tbaa !4
  %7 = add nsw i64 %4, 1
  %8 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 %7) #5
  %9 = bitcast i8* %2 to i8**
  store i8* %8, i8** %9, align 8, !tbaa !10
  %10 = load i64, i64* %6, align 8, !tbaa !4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %8, i8* align 1 %0, i64 %10, i1 false) #5
  %11 = load i8*, i8** %9, align 8, !tbaa !10
  %12 = load i64, i64* %6, align 8, !tbaa !4
  %13 = getelementptr inbounds i8, i8* %11, i64 %12
  store i8 0, i8* %13, align 1, !tbaa !11
  ret %struct.string_t* %3
}

; Function Attrs: argmemonly nofree nounwind readonly willreturn
declare i64 @strlen(i8* nocapture) local_unnamed_addr #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nounwind ssp uwtable
define i8** @createAllegroEvent() #0 {
  %1 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 72) #5
  %2 = bitcast i8* %1 to i8**
  ret i8** %2
}

; Function Attrs: nounwind ssp uwtable
define %struct.allegro_event_t* @fromAllegroEvent(i8* nocapture readonly %0) #0 {
  %2 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 8) #5
  %3 = bitcast i8* %0 to i32*
  %4 = load i32, i32* %3, align 8, !tbaa !11
  switch i32 %4, label %19 [
    i32 42, label %5
    i32 30, label %12
  ]

5:                                                ; preds = %1
  %6 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 16) #5
  %7 = getelementptr inbounds i8, i8* %6, i64 8
  %8 = bitcast i8* %7 to i64*
  store i64 13, i64* %8, align 8, !tbaa !4
  %9 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 14) #5
  %10 = bitcast i8* %6 to i8**
  store i8* %9, i8** %10, align 8, !tbaa !10
  %11 = load i64, i64* %8, align 8, !tbaa !4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %9, i8* align 1 getelementptr inbounds ([14 x i8], [14 x i8]* @.str, i64 0, i64 0), i64 %11, i1 false) #5
  br label %26

12:                                               ; preds = %1
  %13 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 16) #5
  %14 = getelementptr inbounds i8, i8* %13, i64 8
  %15 = bitcast i8* %14 to i64*
  store i64 5, i64* %15, align 8, !tbaa !4
  %16 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 6) #5
  %17 = bitcast i8* %13 to i8**
  store i8* %16, i8** %17, align 8, !tbaa !10
  %18 = load i64, i64* %15, align 8, !tbaa !4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %16, i8* align 1 getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 %18, i1 false) #5
  br label %26

19:                                               ; preds = %1
  %20 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 16) #5
  %21 = getelementptr inbounds i8, i8* %20, i64 8
  %22 = bitcast i8* %21 to i64*
  store i64 6, i64* %22, align 8, !tbaa !4
  %23 = tail call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 7) #5
  %24 = bitcast i8* %20 to i8**
  store i8* %23, i8** %24, align 8, !tbaa !10
  %25 = load i64, i64* %22, align 8, !tbaa !4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %23, i8* align 1 getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i64 %25, i1 false) #5
  br label %26

26:                                               ; preds = %19, %12, %5
  %27 = phi i8** [ %24, %19 ], [ %17, %12 ], [ %10, %5 ]
  %28 = phi i64* [ %22, %19 ], [ %15, %12 ], [ %8, %5 ]
  %29 = phi i8* [ %20, %19 ], [ %13, %12 ], [ %6, %5 ]
  %30 = load i8*, i8** %27, align 8, !tbaa !10
  %31 = load i64, i64* %28, align 8, !tbaa !4
  %32 = getelementptr inbounds i8, i8* %30, i64 %31
  store i8 0, i8* %32, align 1, !tbaa !11
  %33 = bitcast i8* %2 to i8**
  store i8* %29, i8** %33, align 8, !tbaa !12
  %34 = bitcast i8* %2 to %struct.allegro_event_t*
  ret %struct.allegro_event_t* %34
}

; Function Attrs: nounwind ssp uwtable
define void @allegroClearToColor(%struct.allegro_color_t* nocapture readonly %0) local_unnamed_addr #3 {
  %2 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %0, i64 0, i32 0
  %3 = load double, double* %2, align 8, !tbaa !14
  %4 = fptrunc double %3 to float
  %5 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %0, i64 0, i32 1
  %6 = load double, double* %5, align 8, !tbaa !17
  %7 = fptrunc double %6 to float
  %8 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %0, i64 0, i32 2
  %9 = load double, double* %8, align 8, !tbaa !18
  %10 = fptrunc double %9 to float
  %11 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %0, i64 0, i32 3
  %12 = load double, double* %11, align 8, !tbaa !19
  %13 = fptrunc double %12 to float
  %14 = tail call { <2 x float>, <2 x float> } @al_map_rgba_f(float %4, float %7, float %10, float %13) #5
  %15 = extractvalue { <2 x float>, <2 x float> } %14, 0
  %16 = extractvalue { <2 x float>, <2 x float> } %14, 1
  tail call void @al_clear_to_color(<2 x float> %15, <2 x float> %16) #5
  ret void
}

declare { <2 x float>, <2 x float> } @al_map_rgba_f(float, float, float, float) local_unnamed_addr #4

declare void @al_clear_to_color(<2 x float>, <2 x float>) local_unnamed_addr #4

; Function Attrs: nounwind ssp uwtable
define void @allegroDrawText(i8* %0, %struct.allegro_color_t* nocapture readonly %1, i64 %2, i64 %3, i64 %4, %struct.string_t* nocapture readonly %5) #3 {
  %7 = bitcast i8* %0 to %struct.ALLEGRO_FONT*
  %8 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %1, i64 0, i32 0
  %9 = load double, double* %8, align 8, !tbaa !14
  %10 = fptrunc double %9 to float
  %11 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %1, i64 0, i32 1
  %12 = load double, double* %11, align 8, !tbaa !17
  %13 = fptrunc double %12 to float
  %14 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %1, i64 0, i32 2
  %15 = load double, double* %14, align 8, !tbaa !18
  %16 = fptrunc double %15 to float
  %17 = getelementptr inbounds %struct.allegro_color_t, %struct.allegro_color_t* %1, i64 0, i32 3
  %18 = load double, double* %17, align 8, !tbaa !19
  %19 = fptrunc double %18 to float
  %20 = tail call { <2 x float>, <2 x float> } @al_map_rgba_f(float %10, float %13, float %16, float %19) #5
  %21 = extractvalue { <2 x float>, <2 x float> } %20, 0
  %22 = extractvalue { <2 x float>, <2 x float> } %20, 1
  %23 = sitofp i64 %2 to float
  %24 = sitofp i64 %3 to float
  %25 = trunc i64 %4 to i32
  %26 = getelementptr inbounds %struct.string_t, %struct.string_t* %5, i64 0, i32 0
  %27 = load i8*, i8** %26, align 8, !tbaa !10
  tail call void @al_draw_text(%struct.ALLEGRO_FONT* %7, <2 x float> %21, <2 x float> %22, float %23, float %24, i32 %25, i8* %27) #5
  ret void
}

declare void @al_draw_text(%struct.ALLEGRO_FONT*, <2 x float>, <2 x float>, float, float, i32, i8*) local_unnamed_addr #4

; Function Attrs: nounwind ssp uwtable
define void @allegroDrawBitmap(i8* %0, i64 %1, i64 %2, i64 %3) #0 {
  %5 = bitcast i8* %0 to %struct.ALLEGRO_BITMAP*
  %6 = sitofp i64 %1 to float
  %7 = sitofp i64 %2 to float
  %8 = trunc i64 %3 to i32
  tail call void @al_draw_bitmap(%struct.ALLEGRO_BITMAP* %5, float %6, float %7, i32 %8) #5
  ret void
}

declare void @al_draw_bitmap(%struct.ALLEGRO_BITMAP*, float, float, i32) local_unnamed_addr #4

define %Bitmap* @stark.functions.gfx.loadBitmap(%Context* %context1, %string* %path3) {
entry:
  %context = alloca %Context*, align 8
  store %Context* null, %Context** %context, align 8
  store %Context* %context1, %Context** %context, align 8
  %path = alloca %string*, align 8
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
  store %string* %1, %string** %path, align 8
  store %string* %path3, %string** %path, align 8
  %3 = load %string*, %string** %path, align 8
  %memberptr = getelementptr inbounds %string, %string* %3, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %call = call i8* @al_load_bitmap(i8* %load)
  %call4 = call %Bitmap* @stark.structs.gfx.Bitmap.constructor(i8* %call)
  %b = alloca %Bitmap*, align 8
  store %Bitmap* %call4, %Bitmap** %b, align 8
  %4 = load %Context*, %Context** %context, align 8
  %memberptr5 = getelementptr inbounds %Context, %Context* %4, i32 0, i32 4
  %load6 = load %array.Bitmap*, %array.Bitmap** %memberptr5, align 8
  %5 = ptrtoint %array.Bitmap* %load6 to i64
  %cmp = icmp eq i64 %5, 0
  br i1 %cmp, label %if, label %else

if:                                               ; preds = %entry
  %load7 = load %Bitmap*, %Bitmap** %b, align 8
  %alloc8 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %Bitmap*]* getelementptr ([1 x %Bitmap*], [1 x %Bitmap*]* null, i32 1) to i64))
  %6 = bitcast i8* %alloc8 to [1 x %Bitmap*]*
  %elementptr = getelementptr inbounds [1 x %Bitmap*], [1 x %Bitmap*]* %6, i32 0, i32 0
  store %Bitmap* %load7, %Bitmap** %elementptr, align 8
  %alloc9 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.Bitmap* getelementptr (%array.Bitmap, %array.Bitmap* null, i32 1) to i64))
  %7 = bitcast i8* %alloc9 to %array.Bitmap*
  %arrayleninit = getelementptr inbounds %array.Bitmap, %array.Bitmap* %7, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.Bitmap, %array.Bitmap* %7, i32 0, i32 0
  %8 = bitcast [1 x %Bitmap*]* %6 to %Bitmap**
  store %Bitmap** %8, %Bitmap*** %arrayeleminit, align 8
  %9 = load %Context*, %Context** %context, align 8
  %memberptr10 = getelementptr inbounds %Context, %Context* %9, i32 0, i32 4
  store %array.Bitmap* %7, %array.Bitmap** %memberptr10, align 8
  br label %ifcont

else:                                             ; preds = %entry
  %10 = load %Context*, %Context** %context, align 8
  %memberptr11 = getelementptr inbounds %Context, %Context* %10, i32 0, i32 4
  %load12 = load %array.Bitmap*, %array.Bitmap** %memberptr11, align 8
  %load13 = load %Bitmap*, %Bitmap** %b, align 8
  %alloc14 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %Bitmap*]* getelementptr ([1 x %Bitmap*], [1 x %Bitmap*]* null, i32 1) to i64))
  %11 = bitcast i8* %alloc14 to [1 x %Bitmap*]*
  %elementptr15 = getelementptr inbounds [1 x %Bitmap*], [1 x %Bitmap*]* %11, i32 0, i32 0
  store %Bitmap* %load13, %Bitmap** %elementptr15, align 8
  %alloc16 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.Bitmap* getelementptr (%array.Bitmap, %array.Bitmap* null, i32 1) to i64))
  %12 = bitcast i8* %alloc16 to %array.Bitmap*
  %arrayleninit17 = getelementptr inbounds %array.Bitmap, %array.Bitmap* %12, i32 0, i32 1
  store i64 1, i64* %arrayleninit17, align 4
  %arrayeleminit18 = getelementptr inbounds %array.Bitmap, %array.Bitmap* %12, i32 0, i32 0
  %13 = bitcast [1 x %Bitmap*]* %11 to %Bitmap**
  store %Bitmap** %13, %Bitmap*** %arrayeleminit18, align 8
  %14 = bitcast %array.Bitmap* %load12 to i8*
  %15 = bitcast %array.Bitmap* %12 to i8*
  %concat = call i8* @stark_runtime_priv_concat_array(i8* %14, i8* %15, i64 ptrtoint (%Bitmap*** getelementptr (%Bitmap**, %Bitmap*** null, i32 1) to i64))
  %16 = bitcast i8* %concat to %array.Bitmap*
  %17 = load %Context*, %Context** %context, align 8
  %memberptr19 = getelementptr inbounds %Context, %Context* %17, i32 0, i32 4
  store %array.Bitmap* %16, %array.Bitmap** %memberptr19, align 8
  br label %ifcont

ifcont:                                           ; preds = %else, %if
  %load20 = load %Bitmap*, %Bitmap** %b, align 8
  ret %Bitmap* %load20
}

declare i8* @al_load_bitmap(i8*)

define internal %Bitmap* @stark.structs.gfx.Bitmap.constructor(i8* %allegroBitmap) {
entry:
  %allegroBitmap1 = alloca i8*, align 8
  store i8* %allegroBitmap, i8** %allegroBitmap1, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%Bitmap* getelementptr (%Bitmap, %Bitmap* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Bitmap*
  %structmemberinit = getelementptr inbounds %Bitmap, %Bitmap* %0, i32 0, i32 0
  %1 = load i8*, i8** %allegroBitmap1, align 8
  store i8* %1, i8** %structmemberinit, align 8
  ret %Bitmap* %0
}

declare i8* @stark_runtime_priv_concat_array(i8*, i8*, i64)

define void @stark.functions.gfx.drawBitmap(%Bitmap* %bitmap1, i64 %x2, i64 %y3, i64 %flags4) {
entry:
  %bitmap = alloca %Bitmap*, align 8
  store %Bitmap* null, %Bitmap** %bitmap, align 8
  store %Bitmap* %bitmap1, %Bitmap** %bitmap, align 8
  %x = alloca i64, align 8
  store i64 0, i64* %x, align 4
  store i64 %x2, i64* %x, align 4
  %y = alloca i64, align 8
  store i64 0, i64* %y, align 4
  store i64 %y3, i64* %y, align 4
  %flags = alloca i64, align 8
  store i64 0, i64* %flags, align 4
  store i64 %flags4, i64* %flags, align 4
  %0 = load %Bitmap*, %Bitmap** %bitmap, align 8
  %memberptr = getelementptr inbounds %Bitmap, %Bitmap* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %load5 = load i64, i64* %x, align 4
  %load6 = load i64, i64* %y, align 4
  %load7 = load i64, i64* %flags, align 4
  call void bitcast (void (i8*, i64, i64, i64)* @allegroDrawBitmap to void (i8*, i64, i64, i64)*)(i8* %load, i64 %load5, i64 %load6, i64 %load7)
  ret void
}

define void @stark.functions.gfx.destroyBitmap(%Bitmap* %bitmap1) {
entry:
  %bitmap = alloca %Bitmap*, align 8
  store %Bitmap* null, %Bitmap** %bitmap, align 8
  store %Bitmap* %bitmap1, %Bitmap** %bitmap, align 8
  %0 = load %Bitmap*, %Bitmap** %bitmap, align 8
  %memberptr = getelementptr inbounds %Bitmap, %Bitmap* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  call void @al_destroy_bitmap(i8* %load)
  ret void
}

declare void @al_destroy_bitmap(i8*)

define i64 @stark.functions.gfx.run(i64 (i64, i8*)* %startFunc1) {
entry:
  %startFunc = alloca i64 (i64, i8*)*, align 8
  store i64 (i64, i8*)* null, i64 (i64, i8*)** %startFunc, align 8
  store i64 (i64, i8*)* %startFunc1, i64 (i64, i8*)** %startFunc, align 8
  %load = load i64 (i64, i8*)*, i64 (i64, i8*)** %startFunc, align 8
  %call = call i64 @al_run_main(i64 0, i8* null, i64 (i64, i8*)* %load)
  ret i64 %call
}

declare i64 @al_run_main(i64, i8*, i64 (i64, i8*)*)

define %ContextResult* @stark.functions.gfx.init(i64 %width1, i64 %height2) {
entry:
  %width = alloca i64, align 8
  store i64 0, i64* %width, align 4
  store i64 %width1, i64* %width, align 4
  %height = alloca i64, align 8
  store i64 0, i64* %height, align 4
  store i64 %height2, i64* %height, align 4
  %call = call %ContextResult* @stark.structs.gfx.ContextResult.constructor(%Context* null, %string* null)
  %result = alloca %ContextResult*, align 8
  store %ContextResult* %call, %ContextResult** %result, align 8
  %call3 = call i64 @al_get_allegro_version()
  %call4 = call i1 @al_install_system(i64 %call3, i64 ()* null)
  %cmp = icmp eq i1 %call4, true
  br i1 %cmp, label %if, label %else

if:                                               ; preds = %entry
  %call5 = call i1 @al_init_image_addon()
  %cmp6 = icmp ne i1 %call5, true
  br i1 %cmp6, label %if7, label %ifcont

if7:                                              ; preds = %if
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([33 x i8]* getelementptr ([33 x i8], [33 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [33 x i8]*
  %dataptr = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 0
  store i8 102, i8* %dataptr, align 1
  %dataptr8 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 1
  store i8 97, i8* %dataptr8, align 1
  %dataptr9 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 2
  store i8 105, i8* %dataptr9, align 1
  %dataptr10 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 3
  store i8 108, i8* %dataptr10, align 1
  %dataptr11 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 4
  store i8 101, i8* %dataptr11, align 1
  %dataptr12 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 5
  store i8 100, i8* %dataptr12, align 1
  %dataptr13 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 6
  store i8 32, i8* %dataptr13, align 1
  %dataptr14 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 7
  store i8 116, i8* %dataptr14, align 1
  %dataptr15 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 8
  store i8 111, i8* %dataptr15, align 1
  %dataptr16 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 9
  store i8 32, i8* %dataptr16, align 1
  %dataptr17 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 10
  store i8 105, i8* %dataptr17, align 1
  %dataptr18 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 11
  store i8 110, i8* %dataptr18, align 1
  %dataptr19 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 12
  store i8 105, i8* %dataptr19, align 1
  %dataptr20 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 13
  store i8 116, i8* %dataptr20, align 1
  %dataptr21 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 14
  store i8 105, i8* %dataptr21, align 1
  %dataptr22 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 15
  store i8 97, i8* %dataptr22, align 1
  %dataptr23 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 16
  store i8 108, i8* %dataptr23, align 1
  %dataptr24 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 17
  store i8 105, i8* %dataptr24, align 1
  %dataptr25 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 18
  store i8 122, i8* %dataptr25, align 1
  %dataptr26 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 19
  store i8 101, i8* %dataptr26, align 1
  %dataptr27 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 20
  store i8 32, i8* %dataptr27, align 1
  %dataptr28 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 21
  store i8 105, i8* %dataptr28, align 1
  %dataptr29 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 22
  store i8 109, i8* %dataptr29, align 1
  %dataptr30 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 23
  store i8 97, i8* %dataptr30, align 1
  %dataptr31 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 24
  store i8 103, i8* %dataptr31, align 1
  %dataptr32 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 25
  store i8 101, i8* %dataptr32, align 1
  %dataptr33 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 26
  store i8 32, i8* %dataptr33, align 1
  %dataptr34 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 27
  store i8 97, i8* %dataptr34, align 1
  %dataptr35 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 28
  store i8 100, i8* %dataptr35, align 1
  %dataptr36 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 29
  store i8 100, i8* %dataptr36, align 1
  %dataptr37 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 30
  store i8 111, i8* %dataptr37, align 1
  %dataptr38 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 31
  store i8 110, i8* %dataptr38, align 1
  %dataptr39 = getelementptr inbounds [33 x i8], [33 x i8]* %0, i32 0, i32 32
  store i8 0, i8* %dataptr39, align 1
  %alloc40 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc40 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 32, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [33 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  %3 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr = getelementptr inbounds %ContextResult, %ContextResult* %3, i32 0, i32 1
  store %string* %1, %string** %memberptr, align 8
  %load = load %ContextResult*, %ContextResult** %result, align 8
  ret %ContextResult* %load

ifcont:                                           ; preds = %if
  %call41 = call i8* @al_create_event_queue()
  %queue = alloca i8*, align 8
  store i8* %call41, i8** %queue, align 8
  %load42 = load i8*, i8** %queue, align 8
  %cmp43 = icmp eq i8* %load42, null
  br i1 %cmp43, label %if44, label %ifcont78

if44:                                             ; preds = %ifcont
  %alloc45 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([27 x i8]* getelementptr ([27 x i8], [27 x i8]* null, i32 1) to i64))
  %4 = bitcast i8* %alloc45 to [27 x i8]*
  %dataptr46 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 0
  store i8 102, i8* %dataptr46, align 1
  %dataptr47 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 1
  store i8 97, i8* %dataptr47, align 1
  %dataptr48 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 2
  store i8 105, i8* %dataptr48, align 1
  %dataptr49 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 3
  store i8 108, i8* %dataptr49, align 1
  %dataptr50 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 4
  store i8 101, i8* %dataptr50, align 1
  %dataptr51 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 5
  store i8 100, i8* %dataptr51, align 1
  %dataptr52 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 6
  store i8 32, i8* %dataptr52, align 1
  %dataptr53 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 7
  store i8 116, i8* %dataptr53, align 1
  %dataptr54 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 8
  store i8 111, i8* %dataptr54, align 1
  %dataptr55 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 9
  store i8 32, i8* %dataptr55, align 1
  %dataptr56 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 10
  store i8 105, i8* %dataptr56, align 1
  %dataptr57 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 11
  store i8 110, i8* %dataptr57, align 1
  %dataptr58 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 12
  store i8 105, i8* %dataptr58, align 1
  %dataptr59 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 13
  store i8 116, i8* %dataptr59, align 1
  %dataptr60 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 14
  store i8 105, i8* %dataptr60, align 1
  %dataptr61 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 15
  store i8 97, i8* %dataptr61, align 1
  %dataptr62 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 16
  store i8 108, i8* %dataptr62, align 1
  %dataptr63 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 17
  store i8 105, i8* %dataptr63, align 1
  %dataptr64 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 18
  store i8 122, i8* %dataptr64, align 1
  %dataptr65 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 19
  store i8 101, i8* %dataptr65, align 1
  %dataptr66 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 20
  store i8 32, i8* %dataptr66, align 1
  %dataptr67 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 21
  store i8 113, i8* %dataptr67, align 1
  %dataptr68 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 22
  store i8 117, i8* %dataptr68, align 1
  %dataptr69 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 23
  store i8 101, i8* %dataptr69, align 1
  %dataptr70 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 24
  store i8 117, i8* %dataptr70, align 1
  %dataptr71 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 25
  store i8 101, i8* %dataptr71, align 1
  %dataptr72 = getelementptr inbounds [27 x i8], [27 x i8]* %4, i32 0, i32 26
  store i8 0, i8* %dataptr72, align 1
  %alloc73 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %5 = bitcast i8* %alloc73 to %string*
  %stringleninit74 = getelementptr inbounds %string, %string* %5, i32 0, i32 1
  store i64 26, i64* %stringleninit74, align 4
  %stringdatainit75 = getelementptr inbounds %string, %string* %5, i32 0, i32 0
  %6 = bitcast [27 x i8]* %4 to i8*
  store i8* %6, i8** %stringdatainit75, align 8
  %7 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr76 = getelementptr inbounds %ContextResult, %ContextResult* %7, i32 0, i32 1
  store %string* %5, %string** %memberptr76, align 8
  %load77 = load %ContextResult*, %ContextResult** %result, align 8
  ret %ContextResult* %load77

ifcont78:                                         ; preds = %ifcont
  %load79 = load i64, i64* %width, align 4
  %load80 = load i64, i64* %height, align 4
  %call81 = call i8* @al_create_display(i64 %load79, i64 %load80)
  %display = alloca i8*, align 8
  store i8* %call81, i8** %display, align 8
  %load82 = load i8*, i8** %display, align 8
  %cmp83 = icmp eq i8* %load82, null
  br i1 %cmp83, label %if84, label %ifcont120

if84:                                             ; preds = %ifcont78
  %alloc85 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([29 x i8]* getelementptr ([29 x i8], [29 x i8]* null, i32 1) to i64))
  %8 = bitcast i8* %alloc85 to [29 x i8]*
  %dataptr86 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 0
  store i8 102, i8* %dataptr86, align 1
  %dataptr87 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 1
  store i8 97, i8* %dataptr87, align 1
  %dataptr88 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 2
  store i8 105, i8* %dataptr88, align 1
  %dataptr89 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 3
  store i8 108, i8* %dataptr89, align 1
  %dataptr90 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 4
  store i8 101, i8* %dataptr90, align 1
  %dataptr91 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 5
  store i8 100, i8* %dataptr91, align 1
  %dataptr92 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 6
  store i8 32, i8* %dataptr92, align 1
  %dataptr93 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 7
  store i8 116, i8* %dataptr93, align 1
  %dataptr94 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 8
  store i8 111, i8* %dataptr94, align 1
  %dataptr95 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 9
  store i8 32, i8* %dataptr95, align 1
  %dataptr96 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 10
  store i8 105, i8* %dataptr96, align 1
  %dataptr97 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 11
  store i8 110, i8* %dataptr97, align 1
  %dataptr98 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 12
  store i8 105, i8* %dataptr98, align 1
  %dataptr99 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 13
  store i8 116, i8* %dataptr99, align 1
  %dataptr100 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 14
  store i8 105, i8* %dataptr100, align 1
  %dataptr101 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 15
  store i8 97, i8* %dataptr101, align 1
  %dataptr102 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 16
  store i8 108, i8* %dataptr102, align 1
  %dataptr103 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 17
  store i8 105, i8* %dataptr103, align 1
  %dataptr104 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 18
  store i8 122, i8* %dataptr104, align 1
  %dataptr105 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 19
  store i8 101, i8* %dataptr105, align 1
  %dataptr106 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 20
  store i8 32, i8* %dataptr106, align 1
  %dataptr107 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 21
  store i8 100, i8* %dataptr107, align 1
  %dataptr108 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 22
  store i8 105, i8* %dataptr108, align 1
  %dataptr109 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 23
  store i8 115, i8* %dataptr109, align 1
  %dataptr110 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 24
  store i8 112, i8* %dataptr110, align 1
  %dataptr111 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 25
  store i8 108, i8* %dataptr111, align 1
  %dataptr112 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 26
  store i8 97, i8* %dataptr112, align 1
  %dataptr113 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 27
  store i8 121, i8* %dataptr113, align 1
  %dataptr114 = getelementptr inbounds [29 x i8], [29 x i8]* %8, i32 0, i32 28
  store i8 0, i8* %dataptr114, align 1
  %alloc115 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %9 = bitcast i8* %alloc115 to %string*
  %stringleninit116 = getelementptr inbounds %string, %string* %9, i32 0, i32 1
  store i64 28, i64* %stringleninit116, align 4
  %stringdatainit117 = getelementptr inbounds %string, %string* %9, i32 0, i32 0
  %10 = bitcast [29 x i8]* %8 to i8*
  store i8* %10, i8** %stringdatainit117, align 8
  %11 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr118 = getelementptr inbounds %ContextResult, %ContextResult* %11, i32 0, i32 1
  store %string* %9, %string** %memberptr118, align 8
  %load119 = load %ContextResult*, %ContextResult** %result, align 8
  ret %ContextResult* %load119

ifcont120:                                        ; preds = %ifcont78
  %call121 = call i8* @al_create_timer(double 0x3FA1111111111111)
  %timer = alloca i8*, align 8
  store i8* %call121, i8** %timer, align 8
  %load122 = load i8*, i8** %timer, align 8
  %cmp123 = icmp eq i8* %load122, null
  br i1 %cmp123, label %if124, label %ifcont158

if124:                                            ; preds = %ifcont120
  %alloc125 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([27 x i8]* getelementptr ([27 x i8], [27 x i8]* null, i32 1) to i64))
  %12 = bitcast i8* %alloc125 to [27 x i8]*
  %dataptr126 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 0
  store i8 102, i8* %dataptr126, align 1
  %dataptr127 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 1
  store i8 97, i8* %dataptr127, align 1
  %dataptr128 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 2
  store i8 105, i8* %dataptr128, align 1
  %dataptr129 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 3
  store i8 108, i8* %dataptr129, align 1
  %dataptr130 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 4
  store i8 101, i8* %dataptr130, align 1
  %dataptr131 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 5
  store i8 100, i8* %dataptr131, align 1
  %dataptr132 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 6
  store i8 32, i8* %dataptr132, align 1
  %dataptr133 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 7
  store i8 116, i8* %dataptr133, align 1
  %dataptr134 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 8
  store i8 111, i8* %dataptr134, align 1
  %dataptr135 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 9
  store i8 32, i8* %dataptr135, align 1
  %dataptr136 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 10
  store i8 105, i8* %dataptr136, align 1
  %dataptr137 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 11
  store i8 110, i8* %dataptr137, align 1
  %dataptr138 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 12
  store i8 105, i8* %dataptr138, align 1
  %dataptr139 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 13
  store i8 116, i8* %dataptr139, align 1
  %dataptr140 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 14
  store i8 105, i8* %dataptr140, align 1
  %dataptr141 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 15
  store i8 97, i8* %dataptr141, align 1
  %dataptr142 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 16
  store i8 108, i8* %dataptr142, align 1
  %dataptr143 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 17
  store i8 105, i8* %dataptr143, align 1
  %dataptr144 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 18
  store i8 122, i8* %dataptr144, align 1
  %dataptr145 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 19
  store i8 101, i8* %dataptr145, align 1
  %dataptr146 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 20
  store i8 32, i8* %dataptr146, align 1
  %dataptr147 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 21
  store i8 116, i8* %dataptr147, align 1
  %dataptr148 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 22
  store i8 105, i8* %dataptr148, align 1
  %dataptr149 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 23
  store i8 109, i8* %dataptr149, align 1
  %dataptr150 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 24
  store i8 101, i8* %dataptr150, align 1
  %dataptr151 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 25
  store i8 114, i8* %dataptr151, align 1
  %dataptr152 = getelementptr inbounds [27 x i8], [27 x i8]* %12, i32 0, i32 26
  store i8 0, i8* %dataptr152, align 1
  %alloc153 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %13 = bitcast i8* %alloc153 to %string*
  %stringleninit154 = getelementptr inbounds %string, %string* %13, i32 0, i32 1
  store i64 26, i64* %stringleninit154, align 4
  %stringdatainit155 = getelementptr inbounds %string, %string* %13, i32 0, i32 0
  %14 = bitcast [27 x i8]* %12 to i8*
  store i8* %14, i8** %stringdatainit155, align 8
  %15 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr156 = getelementptr inbounds %ContextResult, %ContextResult* %15, i32 0, i32 1
  store %string* %13, %string** %memberptr156, align 8
  %load157 = load %ContextResult*, %ContextResult** %result, align 8
  ret %ContextResult* %load157

ifcont158:                                        ; preds = %ifcont120
  %load159 = load i8*, i8** %queue, align 8
  %load160 = load i8*, i8** %display, align 8
  %call161 = call i8* @al_get_display_event_source(i8* %load160)
  call void @al_register_event_source(i8* %load159, i8* %call161)
  %load162 = load i8*, i8** %queue, align 8
  %load163 = load i8*, i8** %timer, align 8
  %call164 = call i8* @al_get_timer_event_source(i8* %load163)
  call void @al_register_event_source(i8* %load162, i8* %call164)
  %load165 = load i8*, i8** %timer, align 8
  call void @al_start_timer(i8* %load165)
  %alloc166 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([8 x i8]* getelementptr ([8 x i8], [8 x i8]* null, i32 1) to i64))
  %16 = bitcast i8* %alloc166 to [8 x i8]*
  %dataptr167 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 0
  store i8 98, i8* %dataptr167, align 1
  %dataptr168 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 1
  store i8 117, i8* %dataptr168, align 1
  %dataptr169 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 2
  store i8 105, i8* %dataptr169, align 1
  %dataptr170 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 3
  store i8 108, i8* %dataptr170, align 1
  %dataptr171 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 4
  store i8 116, i8* %dataptr171, align 1
  %dataptr172 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 5
  store i8 105, i8* %dataptr172, align 1
  %dataptr173 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 6
  store i8 110, i8* %dataptr173, align 1
  %dataptr174 = getelementptr inbounds [8 x i8], [8 x i8]* %16, i32 0, i32 7
  store i8 0, i8* %dataptr174, align 1
  %alloc175 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %17 = bitcast i8* %alloc175 to %string*
  %stringleninit176 = getelementptr inbounds %string, %string* %17, i32 0, i32 1
  store i64 7, i64* %stringleninit176, align 4
  %stringdatainit177 = getelementptr inbounds %string, %string* %17, i32 0, i32 0
  %18 = bitcast [8 x i8]* %16 to i8*
  store i8* %18, i8** %stringdatainit177, align 8
  %call178 = call i8* @al_create_builtin_font()
  %call179 = call %Font* @stark.structs.gfx.Font.constructor(%string* %17, i8* %call178)
  %alloc180 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x %Font*]* getelementptr ([1 x %Font*], [1 x %Font*]* null, i32 1) to i64))
  %19 = bitcast i8* %alloc180 to [1 x %Font*]*
  %elementptr = getelementptr inbounds [1 x %Font*], [1 x %Font*]* %19, i32 0, i32 0
  store %Font* %call179, %Font** %elementptr, align 8
  %alloc181 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%array.Font* getelementptr (%array.Font, %array.Font* null, i32 1) to i64))
  %20 = bitcast i8* %alloc181 to %array.Font*
  %arrayleninit = getelementptr inbounds %array.Font, %array.Font* %20, i32 0, i32 1
  store i64 1, i64* %arrayleninit, align 4
  %arrayeleminit = getelementptr inbounds %array.Font, %array.Font* %20, i32 0, i32 0
  %21 = bitcast [1 x %Font*]* %19 to %Font**
  store %Font** %21, %Font*** %arrayeleminit, align 8
  %fonts = alloca %array.Font*, align 8
  store %array.Font* %20, %array.Font** %fonts, align 8
  %load182 = load i8*, i8** %queue, align 8
  %load183 = load i8*, i8** %display, align 8
  %load184 = load i8*, i8** %timer, align 8
  %load185 = load %array.Font*, %array.Font** %fonts, align 8
  %call186 = call i8* bitcast (i8** ()* @createAllegroEvent to i8* ()*)()
  %call187 = call %Context* @stark.structs.gfx.Context.constructor(i8* %load182, i8* %load183, i8* %load184, %array.Font* %load185, %array.Bitmap* null, i8* %call186)
  %context = alloca %Context*, align 8
  store %Context* %call187, %Context** %context, align 8
  %load188 = load %Context*, %Context** %context, align 8
  %22 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr189 = getelementptr inbounds %ContextResult, %ContextResult* %22, i32 0, i32 0
  store %Context* %load188, %Context** %memberptr189, align 8
  br label %ifcont224

else:                                             ; preds = %entry
  %alloc190 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([29 x i8]* getelementptr ([29 x i8], [29 x i8]* null, i32 1) to i64))
  %23 = bitcast i8* %alloc190 to [29 x i8]*
  %dataptr191 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 0
  store i8 102, i8* %dataptr191, align 1
  %dataptr192 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 1
  store i8 97, i8* %dataptr192, align 1
  %dataptr193 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 2
  store i8 105, i8* %dataptr193, align 1
  %dataptr194 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 3
  store i8 108, i8* %dataptr194, align 1
  %dataptr195 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 4
  store i8 101, i8* %dataptr195, align 1
  %dataptr196 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 5
  store i8 100, i8* %dataptr196, align 1
  %dataptr197 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 6
  store i8 32, i8* %dataptr197, align 1
  %dataptr198 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 7
  store i8 116, i8* %dataptr198, align 1
  %dataptr199 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 8
  store i8 111, i8* %dataptr199, align 1
  %dataptr200 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 9
  store i8 32, i8* %dataptr200, align 1
  %dataptr201 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 10
  store i8 105, i8* %dataptr201, align 1
  %dataptr202 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 11
  store i8 110, i8* %dataptr202, align 1
  %dataptr203 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 12
  store i8 105, i8* %dataptr203, align 1
  %dataptr204 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 13
  store i8 116, i8* %dataptr204, align 1
  %dataptr205 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 14
  store i8 105, i8* %dataptr205, align 1
  %dataptr206 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 15
  store i8 97, i8* %dataptr206, align 1
  %dataptr207 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 16
  store i8 108, i8* %dataptr207, align 1
  %dataptr208 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 17
  store i8 105, i8* %dataptr208, align 1
  %dataptr209 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 18
  store i8 122, i8* %dataptr209, align 1
  %dataptr210 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 19
  store i8 101, i8* %dataptr210, align 1
  %dataptr211 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 20
  store i8 32, i8* %dataptr211, align 1
  %dataptr212 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 21
  store i8 99, i8* %dataptr212, align 1
  %dataptr213 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 22
  store i8 111, i8* %dataptr213, align 1
  %dataptr214 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 23
  store i8 110, i8* %dataptr214, align 1
  %dataptr215 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 24
  store i8 116, i8* %dataptr215, align 1
  %dataptr216 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 25
  store i8 101, i8* %dataptr216, align 1
  %dataptr217 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 26
  store i8 120, i8* %dataptr217, align 1
  %dataptr218 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 27
  store i8 116, i8* %dataptr218, align 1
  %dataptr219 = getelementptr inbounds [29 x i8], [29 x i8]* %23, i32 0, i32 28
  store i8 0, i8* %dataptr219, align 1
  %alloc220 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %24 = bitcast i8* %alloc220 to %string*
  %stringleninit221 = getelementptr inbounds %string, %string* %24, i32 0, i32 1
  store i64 28, i64* %stringleninit221, align 4
  %stringdatainit222 = getelementptr inbounds %string, %string* %24, i32 0, i32 0
  %25 = bitcast [29 x i8]* %23 to i8*
  store i8* %25, i8** %stringdatainit222, align 8
  %26 = load %ContextResult*, %ContextResult** %result, align 8
  %memberptr223 = getelementptr inbounds %ContextResult, %ContextResult* %26, i32 0, i32 1
  store %string* %24, %string** %memberptr223, align 8
  br label %ifcont224

ifcont224:                                        ; preds = %else, %ifcont158
  %load225 = load %ContextResult*, %ContextResult** %result, align 8
  ret %ContextResult* %load225
}

define internal %ContextResult* @stark.structs.gfx.ContextResult.constructor(%Context* %value, %string* %error) {
entry:
  %value1 = alloca %Context*, align 8
  store %Context* %value, %Context** %value1, align 8
  %error2 = alloca %string*, align 8
  store %string* %error, %string** %error2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%ContextResult* getelementptr (%ContextResult, %ContextResult* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %ContextResult*
  %structmemberinit = getelementptr inbounds %ContextResult, %ContextResult* %0, i32 0, i32 0
  %1 = load %Context*, %Context** %value1, align 8
  store %Context* %1, %Context** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %ContextResult, %ContextResult* %0, i32 0, i32 1
  %2 = load %string*, %string** %error2, align 8
  store %string* %2, %string** %structmemberinit3, align 8
  ret %ContextResult* %0
}

declare i64 @al_get_allegro_version()

declare i1 @al_install_system(i64, i64 ()*)

declare i1 @al_init_image_addon()

declare i8* @al_create_event_queue()

declare i8* @al_create_display(i64, i64)

declare i8* @al_create_timer(double)

declare i8* @al_get_display_event_source(i8*)

declare void @al_register_event_source(i8*, i8*)

declare i8* @al_get_timer_event_source(i8*)

declare void @al_start_timer(i8*)

declare i8* @al_create_builtin_font()

define internal %Font* @stark.structs.gfx.Font.constructor(%string* %name, i8* %allegroFont) {
entry:
  %name1 = alloca %string*, align 8
  store %string* %name, %string** %name1, align 8
  %allegroFont2 = alloca i8*, align 8
  store i8* %allegroFont, i8** %allegroFont2, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%Font* getelementptr (%Font, %Font* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Font*
  %structmemberinit = getelementptr inbounds %Font, %Font* %0, i32 0, i32 0
  %1 = load %string*, %string** %name1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  %structmemberinit3 = getelementptr inbounds %Font, %Font* %0, i32 0, i32 1
  %2 = load i8*, i8** %allegroFont2, align 8
  store i8* %2, i8** %structmemberinit3, align 8
  ret %Font* %0
}

define internal %Context* @stark.structs.gfx.Context.constructor(i8* %queue, i8* %display, i8* %timer, %array.Font* %fonts, %array.Bitmap* %bitmaps, i8* %event) {
entry:
  %queue1 = alloca i8*, align 8
  store i8* %queue, i8** %queue1, align 8
  %display2 = alloca i8*, align 8
  store i8* %display, i8** %display2, align 8
  %timer3 = alloca i8*, align 8
  store i8* %timer, i8** %timer3, align 8
  %fonts4 = alloca %array.Font*, align 8
  store %array.Font* %fonts, %array.Font** %fonts4, align 8
  %bitmaps5 = alloca %array.Bitmap*, align 8
  store %array.Bitmap* %bitmaps, %array.Bitmap** %bitmaps5, align 8
  %event6 = alloca i8*, align 8
  store i8* %event, i8** %event6, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%Context* getelementptr (%Context, %Context* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Context*
  %structmemberinit = getelementptr inbounds %Context, %Context* %0, i32 0, i32 0
  %1 = load i8*, i8** %queue1, align 8
  store i8* %1, i8** %structmemberinit, align 8
  %structmemberinit7 = getelementptr inbounds %Context, %Context* %0, i32 0, i32 1
  %2 = load i8*, i8** %display2, align 8
  store i8* %2, i8** %structmemberinit7, align 8
  %structmemberinit8 = getelementptr inbounds %Context, %Context* %0, i32 0, i32 2
  %3 = load i8*, i8** %timer3, align 8
  store i8* %3, i8** %structmemberinit8, align 8
  %structmemberinit9 = getelementptr inbounds %Context, %Context* %0, i32 0, i32 3
  %4 = load %array.Font*, %array.Font** %fonts4, align 8
  store %array.Font* %4, %array.Font** %structmemberinit9, align 8
  %structmemberinit10 = getelementptr inbounds %Context, %Context* %0, i32 0, i32 4
  %5 = load %array.Bitmap*, %array.Bitmap** %bitmaps5, align 8
  store %array.Bitmap* %5, %array.Bitmap** %structmemberinit10, align 8
  %structmemberinit11 = getelementptr inbounds %Context, %Context* %0, i32 0, i32 5
  %6 = load i8*, i8** %event6, align 8
  store i8* %6, i8** %structmemberinit11, align 8
  ret %Context* %0
}

define void @stark.functions.gfx.destroy(%Context* %context1) {
entry:
  %context = alloca %Context*, align 8
  store %Context* null, %Context** %context, align 8
  store %Context* %context1, %Context** %context, align 8
  %0 = load %Context*, %Context** %context, align 8
  %memberptr = getelementptr inbounds %Context, %Context* %0, i32 0, i32 1
  %load = load i8*, i8** %memberptr, align 8
  call void @al_destroy_display(i8* %load)
  %1 = load %Context*, %Context** %context, align 8
  %memberptr2 = getelementptr inbounds %Context, %Context* %1, i32 0, i32 2
  %load3 = load i8*, i8** %memberptr2, align 8
  call void @al_destroy_timer(i8* %load3)
  %2 = load %Context*, %Context** %context, align 8
  %memberptr4 = getelementptr inbounds %Context, %Context* %2, i32 0, i32 0
  %load5 = load i8*, i8** %memberptr4, align 8
  call void @al_destroy_event_queue(i8* %load5)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 4
  %3 = load %Context*, %Context** %context, align 8
  %memberptr6 = getelementptr inbounds %Context, %Context* %3, i32 0, i32 3
  %load7 = load %array.Font*, %array.Font** %memberptr6, align 8
  %4 = ptrtoint %array.Font* %load7 to i64
  %cmp = icmp ne i64 %4, 0
  br i1 %cmp, label %if, label %ifcont

if:                                               ; preds = %entry
  br label %whiletest

whiletest:                                        ; preds = %while, %if
  %load8 = load i64, i64* %i, align 4
  %5 = load %Context*, %Context** %context, align 8
  %memberptr9 = getelementptr inbounds %Context, %Context* %5, i32 0, i32 3
  %6 = load %array.Font*, %array.Font** %memberptr9, align 8
  %memberptr10 = getelementptr inbounds %array.Font, %array.Font* %6, i32 0, i32 1
  %load11 = load i64, i64* %memberptr10, align 4
  %cmp12 = icmp slt i64 %load8, %load11
  br i1 %cmp12, label %while, label %whilecont

while:                                            ; preds = %whiletest
  %7 = load %Context*, %Context** %context, align 8
  %memberptr13 = getelementptr inbounds %Context, %Context* %7, i32 0, i32 3
  %load14 = load i64, i64* %i, align 4
  %8 = trunc i64 %load14 to i32
  %9 = load %array.Font*, %array.Font** %memberptr13, align 8
  %elementptrs = getelementptr inbounds %array.Font, %array.Font* %9, i32 0, i32 0
  %10 = load %Font**, %Font*** %elementptrs, align 8
  %11 = getelementptr inbounds %Font*, %Font** %10, i32 %8
  %load15 = load %Font*, %Font** %11, align 8
  call void @stark.functions.gfx.destroyFont(%Font* %load15)
  %load16 = load i64, i64* %i, align 4
  %binop = add i64 %load16, 1
  store i64 %binop, i64* %i, align 4
  br label %whiletest

whilecont:                                        ; preds = %whiletest
  br label %ifcont

ifcont:                                           ; preds = %whilecont, %entry
  store i64 0, i64* %i, align 4
  %12 = load %Context*, %Context** %context, align 8
  %memberptr17 = getelementptr inbounds %Context, %Context* %12, i32 0, i32 4
  %load18 = load %array.Bitmap*, %array.Bitmap** %memberptr17, align 8
  %13 = ptrtoint %array.Bitmap* %load18 to i64
  %cmp19 = icmp ne i64 %13, 0
  br i1 %cmp19, label %if20, label %ifcont35

if20:                                             ; preds = %ifcont
  br label %whiletest21

whiletest21:                                      ; preds = %while27, %if20
  %load22 = load i64, i64* %i, align 4
  %14 = load %Context*, %Context** %context, align 8
  %memberptr23 = getelementptr inbounds %Context, %Context* %14, i32 0, i32 4
  %15 = load %array.Bitmap*, %array.Bitmap** %memberptr23, align 8
  %memberptr24 = getelementptr inbounds %array.Bitmap, %array.Bitmap* %15, i32 0, i32 1
  %load25 = load i64, i64* %memberptr24, align 4
  %cmp26 = icmp slt i64 %load22, %load25
  br i1 %cmp26, label %while27, label %whilecont34

while27:                                          ; preds = %whiletest21
  %16 = load %Context*, %Context** %context, align 8
  %memberptr28 = getelementptr inbounds %Context, %Context* %16, i32 0, i32 4
  %load29 = load i64, i64* %i, align 4
  %17 = trunc i64 %load29 to i32
  %18 = load %array.Bitmap*, %array.Bitmap** %memberptr28, align 8
  %elementptrs30 = getelementptr inbounds %array.Bitmap, %array.Bitmap* %18, i32 0, i32 0
  %19 = load %Bitmap**, %Bitmap*** %elementptrs30, align 8
  %20 = getelementptr inbounds %Bitmap*, %Bitmap** %19, i32 %17
  %load31 = load %Bitmap*, %Bitmap** %20, align 8
  call void @stark.functions.gfx.destroyBitmap(%Bitmap* %load31)
  %load32 = load i64, i64* %i, align 4
  %binop33 = add i64 %load32, 1
  store i64 %binop33, i64* %i, align 4
  br label %whiletest21

whilecont34:                                      ; preds = %whiletest21
  br label %ifcont35

ifcont35:                                         ; preds = %whilecont34, %ifcont
  ret void
}

declare void @al_destroy_display(i8*)

declare void @al_destroy_timer(i8*)

declare void @al_destroy_event_queue(i8*)

define void @stark.functions.gfx.destroyFont(%Font* %font1) {
entry:
  %font = alloca %Font*, align 8
  store %Font* null, %Font** %font, align 8
  store %Font* %font1, %Font** %font, align 8
  %0 = load %Font*, %Font** %font, align 8
  %memberptr = getelementptr inbounds %Font, %Font* %0, i32 0, i32 1
  %load = load i8*, i8** %memberptr, align 8
  call void @al_destroy_font(i8* %load)
  ret void
}

declare void @al_destroy_font(i8*)

define void @stark.functions.gfx.flipDisplay() {
entry:
  call void @al_flip_display()
  ret void
}

declare void @al_flip_display()

define %Event* @stark.functions.gfx.waitForEvent(%Context* %context1) {
entry:
  %context = alloca %Context*, align 8
  store %Context* null, %Context** %context, align 8
  store %Context* %context1, %Context** %context, align 8
  %0 = load %Context*, %Context** %context, align 8
  %memberptr = getelementptr inbounds %Context, %Context* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %1 = load %Context*, %Context** %context, align 8
  %memberptr2 = getelementptr inbounds %Context, %Context* %1, i32 0, i32 5
  %load3 = load i8*, i8** %memberptr2, align 8
  call void @al_wait_for_event(i8* %load, i8* %load3)
  %2 = load %Context*, %Context** %context, align 8
  %memberptr4 = getelementptr inbounds %Context, %Context* %2, i32 0, i32 5
  %load5 = load i8*, i8** %memberptr4, align 8
  %call = call %Event* bitcast (%struct.allegro_event_t* (i8*)* @fromAllegroEvent to %Event* (i8*)*)(i8* %load5)
  %event = alloca %Event*, align 8
  store %Event* %call, %Event** %event, align 8
  %3 = load %Event*, %Event** %event, align 8
  %memberptr6 = getelementptr inbounds %Event, %Event* %3, i32 0, i32 0
  %load7 = load %string*, %string** %memberptr6, align 8
  %call8 = call %Event* @stark.structs.gfx.Event.constructor(%string* %load7)
  ret %Event* %call8
}

declare void @al_wait_for_event(i8*, i8*)

define internal %Event* @stark.structs.gfx.Event.constructor(%string* %type) {
entry:
  %type1 = alloca %string*, align 8
  store %string* %type, %string** %type1, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%Event* getelementptr (%Event, %Event* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Event*
  %structmemberinit = getelementptr inbounds %Event, %Event* %0, i32 0, i32 0
  %1 = load %string*, %string** %type1, align 8
  store %string* %1, %string** %structmemberinit, align 8
  ret %Event* %0
}

define i1 @stark.functions.gfx.isEventQueueEmpty(%Context* %context1) {
entry:
  %context = alloca %Context*, align 8
  store %Context* null, %Context** %context, align 8
  store %Context* %context1, %Context** %context, align 8
  %0 = load %Context*, %Context** %context, align 8
  %memberptr = getelementptr inbounds %Context, %Context* %0, i32 0, i32 0
  %load = load i8*, i8** %memberptr, align 8
  %call = call i1 @al_is_event_queue_empty(i8* %load)
  ret i1 %call
}

declare i1 @al_is_event_queue_empty(i8*)

define %Font* @stark.functions.gfx.getFont(%Context* %context1, %string* %name3) {
entry:
  %context = alloca %Context*, align 8
  store %Context* null, %Context** %context, align 8
  store %Context* %context1, %Context** %context, align 8
  %name = alloca %string*, align 8
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
  store %string* %1, %string** %name, align 8
  store %string* %name3, %string** %name, align 8
  %3 = load %Context*, %Context** %context, align 8
  %memberptr = getelementptr inbounds %Context, %Context* %3, i32 0, i32 3
  %4 = load %array.Font*, %array.Font** %memberptr, align 8
  %elementptrs = getelementptr inbounds %array.Font, %array.Font* %4, i32 0, i32 0
  %5 = load %Font**, %Font*** %elementptrs, align 8
  %6 = getelementptr inbounds %Font*, %Font** %5, i32 0
  %load = load %Font*, %Font** %6, align 8
  ret %Font* %load
}

define void @stark.functions.gfx.drawText(%Font* %font1, %Color* %color2, i64 %x3, i64 %y4, i64 %flags5, %string* %text7) {
entry:
  %font = alloca %Font*, align 8
  store %Font* null, %Font** %font, align 8
  store %Font* %font1, %Font** %font, align 8
  %color = alloca %Color*, align 8
  store %Color* null, %Color** %color, align 8
  store %Color* %color2, %Color** %color, align 8
  %x = alloca i64, align 8
  store i64 0, i64* %x, align 4
  store i64 %x3, i64* %x, align 4
  %y = alloca i64, align 8
  store i64 0, i64* %y, align 4
  store i64 %y4, i64* %y, align 4
  %flags = alloca i64, align 8
  store i64 0, i64* %flags, align 4
  store i64 %flags5, i64* %flags, align 4
  %text = alloca %string*, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint ([1 x i8]* getelementptr ([1 x i8], [1 x i8]* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to [1 x i8]*
  %dataptr = getelementptr inbounds [1 x i8], [1 x i8]* %0, i32 0, i32 0
  store i8 0, i8* %dataptr, align 1
  %alloc6 = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%string* getelementptr (%string, %string* null, i32 1) to i64))
  %1 = bitcast i8* %alloc6 to %string*
  %stringleninit = getelementptr inbounds %string, %string* %1, i32 0, i32 1
  store i64 0, i64* %stringleninit, align 4
  %stringdatainit = getelementptr inbounds %string, %string* %1, i32 0, i32 0
  %2 = bitcast [1 x i8]* %0 to i8*
  store i8* %2, i8** %stringdatainit, align 8
  store %string* %1, %string** %text, align 8
  store %string* %text7, %string** %text, align 8
  %3 = load %Color*, %Color** %color, align 8
  %memberptr = getelementptr inbounds %Color, %Color* %3, i32 0, i32 0
  %load = load double, double* %memberptr, align 8
  %4 = load %Color*, %Color** %color, align 8
  %memberptr8 = getelementptr inbounds %Color, %Color* %4, i32 0, i32 1
  %load9 = load double, double* %memberptr8, align 8
  %5 = load %Color*, %Color** %color, align 8
  %memberptr10 = getelementptr inbounds %Color, %Color* %5, i32 0, i32 2
  %load11 = load double, double* %memberptr10, align 8
  %6 = load %Color*, %Color** %color, align 8
  %memberptr12 = getelementptr inbounds %Color, %Color* %6, i32 0, i32 3
  %load13 = load double, double* %memberptr12, align 8
  %call = call %Color* @stark.structs.gfx.AllegroColor.constructor(double %load, double %load9, double %load11, double %load13)
  %c = alloca %Color*, align 8
  store %Color* %call, %Color** %c, align 8
  %7 = load %Font*, %Font** %font, align 8
  %memberptr14 = getelementptr inbounds %Font, %Font* %7, i32 0, i32 1
  %load15 = load i8*, i8** %memberptr14, align 8
  %load16 = load %Color*, %Color** %c, align 8
  %load17 = load i64, i64* %x, align 4
  %load18 = load i64, i64* %y, align 4
  %load19 = load i64, i64* %flags, align 4
  %load20 = load %string*, %string** %text, align 8
  call void bitcast (void (i8*, %struct.allegro_color_t*, i64, i64, i64, %struct.string_t*)* @allegroDrawText to void (i8*, %Color*, i64, i64, i64, %string*)*)(i8* %load15, %Color* %load16, i64 %load17, i64 %load18, i64 %load19, %string* %load20)
  ret void
}

define internal %Color* @stark.structs.gfx.AllegroColor.constructor(double %r, double %g, double %b, double %a) {
entry:
  %r1 = alloca double, align 8
  store double %r, double* %r1, align 8
  %g2 = alloca double, align 8
  store double %g, double* %g2, align 8
  %b3 = alloca double, align 8
  store double %b, double* %b3, align 8
  %a4 = alloca double, align 8
  store double %a, double* %a4, align 8
  %alloc = call i8* bitcast (i8* (i64)* @stark_runtime_priv_mm_alloc to i8* (i64)*)(i64 ptrtoint (%Color* getelementptr (%Color, %Color* null, i32 1) to i64))
  %0 = bitcast i8* %alloc to %Color*
  %structmemberinit = getelementptr inbounds %Color, %Color* %0, i32 0, i32 0
  %1 = load double, double* %r1, align 8
  store double %1, double* %structmemberinit, align 8
  %structmemberinit5 = getelementptr inbounds %Color, %Color* %0, i32 0, i32 1
  %2 = load double, double* %g2, align 8
  store double %2, double* %structmemberinit5, align 8
  %structmemberinit6 = getelementptr inbounds %Color, %Color* %0, i32 0, i32 2
  %3 = load double, double* %b3, align 8
  store double %3, double* %structmemberinit6, align 8
  %structmemberinit7 = getelementptr inbounds %Color, %Color* %0, i32 0, i32 3
  %4 = load double, double* %a4, align 8
  store double %4, double* %structmemberinit7, align 8
  ret %Color* %0
}

attributes #0 = { nounwind ssp uwtable "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nofree nounwind readonly willreturn "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { nounwind ssp uwtable "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="64" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { "darwin-stkchk-strong-link" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "probe-stack"="___chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2, !3}

!0 = !{!"Apple clang version 13.0.0 (clang-1300.0.29.30)"}
!1 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 1]}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"PIC Level", i32 2}
!4 = !{!5, !9, i64 8}
!5 = !{!"", !6, i64 0, !9, i64 8}
!6 = !{!"any pointer", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!"long long", !7, i64 0}
!10 = !{!5, !6, i64 0}
!11 = !{!7, !7, i64 0}
!12 = !{!13, !6, i64 0}
!13 = !{!"", !6, i64 0}
!14 = !{!15, !16, i64 0}
!15 = !{!"", !16, i64 0, !16, i64 8, !16, i64 16, !16, i64 24}
!16 = !{!"double", !7, i64 0}
!17 = !{!15, !16, i64 8}
!18 = !{!15, !16, i64 16}
!19 = !{!15, !16, i64 24}