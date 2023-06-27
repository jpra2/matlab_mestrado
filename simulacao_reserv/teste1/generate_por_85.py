import numpy as np
lines = []

for i in range(1, 28):
    
    data1 = '27*0.28\n'
    data2 = '27*0.3\n'

    if i > 18:
        data = data2
    else:
        data = data1
    
    lines.append(data)

with open('por27.txt', 'w') as f:
    for line in lines:
        f.write(line)
    f.write(str(len(lines)))

