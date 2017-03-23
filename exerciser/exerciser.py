# Exerciser - presents a random exercise to perform each time the user enters
# some text.
import random

exercises = [
    # exercise, min, max, total
    ('pushups', 3, 10, 30),
    ('situps', 3, 10, 30),
    ('pullups', 3, 10, 30),
    ('squats', 5, 10, 50)
]
s = '';
nx = len(exercises)
remaining = [ ex[3] for ex in exercises] # reps left for each exercise

while s != 'q':
    ex_i = random.randint(0,nx-1)
    ex = exercises[ex_i]
    reps = random.randint(ex[1], ex[2])
    reps = min(reps, remaining[ex_i])
    if reps == 0:
        # check if there are any reps to do
        tot = sum(remaining)
        if (tot == 0):
            print('ALL DONE!')
            break
        else:
            continue
    print('Do {} {}'.format(reps, ex[0]))
    remaining[ex_i] -= reps
    assert(remaining[ex_i]>=0)
    s = input('Next:')
print('TOTALS')
for i in range(0, nx):
    ex = exercises[i]
    print('{} : {}'.format(ex[0], ex[3] - remaining[i]))
print('Bye!')
