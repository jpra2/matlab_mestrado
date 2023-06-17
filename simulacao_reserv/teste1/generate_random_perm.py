import scipy.stats as stats
import numpy as np

# a, b = 0.001, 100
# mu, sigma = (a+b)/2, 100
# dist = stats.truncnorm((a - mu) / sigma, (b - mu) / sigma, loc=mu, scale=sigma)

# values = dist.rvs(17*17).reshape((17, 17))
# ldist = np.log10(values)
# vtest = ldist.min()

# while vtest > -1:
#     values = dist.rvs(17*17).reshape((17, 17))
#     ldist = np.log10(values)
#     vtest = ldist.min()

# values = dist.rvs(17*17).reshape((17, 17))
# values = np.round(values, decimals=2)

# all_lines = []
# for line in values:
#     line_str = [str(val) for val in line]
#     linew = ' '.join(line_str)
#     linew += '\n'
#     all_lines.append(linew)

a, b = -3, 3
mu, sigma = 0, 1.5
dist = stats.truncnorm((a - mu) / sigma, (b - mu) / sigma, loc=mu, scale=sigma)

values = dist.rvs(17*17)
values = np.array([10**i for i in values]).reshape((17, 17))
values = np.round(values, decimals=3)

all_lines = []
for line in values:
    line_str = [str(val) for val in line]
    linew = ' '.join(line_str)
    linew += '\n'
    all_lines.append(linew)

with open('perms2.txt', 'w') as f:
    for line in all_lines:
        f.write(line)

# print(d1.min(), d1.max())
# import pdb; pdb.set_trace()