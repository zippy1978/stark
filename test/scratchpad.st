extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

extern printIntArray(a: int[]): void
extern createIntArray(): int[]

func test(): int[] {

}

a: int[] = [1, 2, 3]

//a: int[] = createIntArray()


printIntArray(a)
printi(a[0])
printi(a[1])
printi(a[2])
print("len is ")
printi(a.len)
print("elements is ")
printi(a.elements)


// FIXME : crash on array element access !!!


/*

 %7 = load i64*, i64** %6, align 8
  %8 = getelementptr inbounds i64, i64* %7, i64 3

*/


/*

%elementptr2 = getelementptr inbounds %array.int, %array.int* %a, i32 0, i32 0
  %1 = getelementptr i64, i64* %elementptr2, i32 1
  %load3 = load i64, i64* %1, align 4

*/
