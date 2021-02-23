from random import randint
type = int(input())
filename = input()
n = randint(5, 20)
min = -16384 if type <= 0 else 0
max = 16383 if type >= 0 else 0
points = []
for _ in range(n):
    points.append((randint(min, max), randint(min, max)))
points.sort()
ans = 0
x1, y1 = points[0]
for i in range(1, n):
    x2, y2 = points[i]
    ans += 0.5 * (y1 + y2) * (x2 - x1)
    x1, y1 = x2, y2
print(ans)
with open(filename, "w") as f:
	f.write(str(n) + "\n")
	for (x, y) in points:
		f.write(str(x) + "\n")
		f.write(str(y) + "\n")
