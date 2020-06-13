#!/usr/bin/python3

def fibonacci(n):
    const = [0, 1]
    a = 0
    b = 1
    r = 1

    for i in range(2, n + 1):
        r, a = a + b, b
        b = r

    if n == 0:
        return 0
    else:
        return r

n = int(input())
print(fibonacci(n))


