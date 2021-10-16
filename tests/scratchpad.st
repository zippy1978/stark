
extern sleep(t: int)

start := time()

sleep(5)

end := time()

duration := end - start

println(duration as string + " ms")