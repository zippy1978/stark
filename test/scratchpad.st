extern println(s: string): void
extern print(s: string): void
extern printi(i: int): void
extern printd(i: double): void
extern now(): int

extern assertIntEquals(actual: int, expected: int): void
extern assertDoubleEquals(actual: double, expected: double): void
extern assertTrue(actual: bool): void

struct ship {
    name: string
}

struct trooper {
    name: string,
    serial: int,
    ship: ship
}

extern createTrooperArray(): trooper[]
extern printTrooperArray(arr: trooper[]): void

sh: ship
sh.name = "tie"

t1: trooper
t1.name = "t1"
t1.serial = 1
t1.ship = sh

//s: trooper = t1

//println(t1.ship.name)


t2: trooper
t2.name = "t2"
t2.serial = 22
t2.ship = sh

t3: trooper
t3.name = "t3"
t3.serial = 304
t3.ship = sh

// Bug on litteral probably 
army: trooper[] = [t1, t2, t3]
//army: trooper[] = createTrooperArray()


printTrooperArray(army)

thes: ship = army[0].ship
thes.name = "fff"
println(thes.name)

army[0].name = "coucou"
army[0].serial = 12


println("------------")
i: int = 0
while ( i < army.len) {
    print("index = ")
    printi(i)
    print("name = ")
    println(army[i].name)
    print("serial = ")
    printi(army[i].serial)
    print("ship.name = ")
    println(army[i].ship.name)
    i = i + 1
    println("------------")
}

/*

  %elementptrs2 = getelementptr inbounds %array.trooper, %array.trooper* %army, i32 0, i32 0

  // Seems like this one goes nowhere !!!
  %elementptr3 = getelementptr inbounds %trooper*, %trooper** %elementptrs2, i64 1
  
  %1 = load %trooper*, %trooper** %elementptr3, align 8
  %memberptr4 = getelementptr inbounds %trooper, %trooper* %1, i32 0, i32 0
  %load5 = load %string, %string* %memberptr4, align 8
  call void @println(%string %load5)

*/


/*

  
  // get elements pointer (troopers carray)
  %elementptrs2 = getelementptr inbounds %array.trooper, %array.trooper* %army, i32 0, i32 0

  // get first element (trooper)
  %elementptr3 = getelementptr inbounds %trooper*, %trooper** %elementptrs2, i64 0

  // load address
  %1 = load %trooper*, %trooper** %elementptr3, align 8

  // >>>> should be ok from here

  // load member
  %memberptr4 = getelementptr inbounds %trooper, %trooper* %1, i32 0, i32 0
  %load5 = load %string, %string* %memberptr4, align 8
  call void @println(%string %load5)

*/

/*

  // get elements pointer (troopers carray)
  %elementptrs = getelementptr inbounds %array.trooper, %array.trooper* %army, i32 0, i32 0

  // get first element (trooper)
  %elementptr = getelementptr inbounds %trooper*, %trooper** %elementptrs, i64 0

  // create alloc
  %elementalloc = alloca %trooper*, align 8

  // store first element (trooper)
  store %trooper** %elementalloc, %trooper** %elementptr, align 8
  %0 = load %trooper*, %trooper** %elementptr, align 8

  // access member at 1 : len ?? (access 1 from trooper: its the size !!!!)
  // ACTUALLY WHAT IF PRINTED IS THE SIZE OF THE ARRAY !!!
  %memberptr = getelementptr inbounds %trooper, %trooper* %0, i32 0, i32 1
  
  %load1 = load i64, i64* %memberptr, align 4
  call void @printi(i64 %load1)
  ret void

*/



/*

  // struct alloc
  %t1 = alloca %trooper, align 8
  
  // get member ptr at 0 (string type)
  %memberptr = getelementptr inbounds %trooper, %trooper* %t1, i32 0, i32 0
  // store string in it
  store %string { [3 x i8]* @t1, i64 2 }, %string* %memberptr, align 8

  // get member pr at 1 (len : i64)
  %memberptr1 = getelementptr inbounds %trooper, %trooper* %t1, i32 0, i32 1
  // store i64 in it
  store i64 12, i64* %memberptr1, align 4

  // GEP from alloc
  %memberptr2 = getelementptr inbounds %trooper, %trooper* %t1, i32 0, i32 1
  %load = load i64, i64* %memberptr2, align 4
  call void @printi(i64 %load)

*/


/*

  %t1 = alloca %trooper, align 8
  %memberptr = getelementptr inbounds %trooper, %trooper* %t1, i32 0, i32 0
  store %string { [3 x i8]* @t1, i64 2 }, %string* %memberptr, align 8
  %memberptr1 = getelementptr inbounds %trooper, %trooper* %t1, i32 0, i32 1
  store i64 12, i64* %memberptr1, align 4
  
  %s = alloca %trooper, align 8
  %load = load %trooper, %trooper* %t1, align 8
  store %trooper %load, %trooper* %s, align 8

  // GEP from alloc
  %memberptr2 = getelementptr inbounds %trooper, %trooper* %s, i32 0, i32 1
  %load3 = load i64, i64* %memberptr2, align 4
  call void @printi(i64 %load3)

*/

// Nested structs > does not work !!!