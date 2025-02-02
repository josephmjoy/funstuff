# import random as rand

def check_median(val, i, nl, ar):
    # Chack if {val} the value at left array at index {i} is a candidate median
    # value. (If total length is odd, it will be the median, else the median will be
    # between the return value and an element to the right)
    # {nl}: the size of the left array,
    # {ar}: the right array
    # Return value:
    # -1: {i} must be smaller. Need to look lower in {al}
    # 0: {i} is correct. {val} is the median.
    # 1: {i} needs to be larger. Need to look higher in {al}
    assert i < nl
    nr = len(ar)
    assert nr > 0 # must be at least one element in the right array
    # Let's derive where to look in the right array {ar} for the median to be at {i}
    #    left_less + right_less = left_greater + right_greater
    #                           = left_greater + nr - right_less
    #    left_less = left_greater + nr - 2*right_less
    #    2*right_less = nr + left_greater - left_less
    #    right_less = (nr + left_greater - left_less)/2
    #               = (nr + ((nl-1) - i) -i)/2 because left_less = i
    #               = (nr + (nl-1) - 2*i)/2
    #               = (nr + nl - 1)/2 - i
    # If total is even this is an integer
    # Note: right_less = right_i
    right_i = (nr + nl - 1)//2 - i
    # {val} must be inserted between {right_i} and {right_i + 1}
    if right_i < -1: # i is too large
        return -1
    elif right_i == -1: # Must be inserted *before* smallest element of {ar}
        return 0 if val <= ar[0] else -1
    elif right_i < nr - 1: # Must be inserted between {right_i} and {right_i + 1}
        if val >= ar[right_i] and val <= ar[right_i + 1]:
            return 0 # found it!
        elif val < ar[right_i]:
            return 1
        elif val > ar[right_i + 1]:
            return -1
        else:
            assert False
    elif right_i == nr - 1: # Must be inserted *after* largest element of {ar}
        return 0 if val >= ar[nr - 1] else 1
    else: # i is too small
        assert right_i >= nr
        return 1



def window_median(al, ar, l1, l2):
    '''
    Search for the index of the median within left array al, within the given window (l1, l2)
    a1: left list
    a2: right list
    l1, l2: Defines the window within which the search occurs: [l1, l2)
    Returns the {i}, the index of the median. If 0 <= {i] < len(a1)-1, the
    median is located between al[i] and al[i+1]
    If i == -1, index is left of al
    If i == len(al) then index is right of al
    '''
    lenl = len(al)
    lenr = len(ar)
    totlen = lenl + lenr
    assert 0 <= l1 and l1 < lenl
    assert 0 < l2 and l2 <= lenl # Note window is [l1, l2)
    assert l1 < l2
    ret = -1
    for i in range(l1, l2):
        val = check_median(al[i], i, lenl, ar)
        if val == 0:
            ret = i
    '''
    direction = mid1 = mid = 0
    if direction == -1:
       ret =  window_median(al, ar, l1, mid1)
    elif direction == 1:
       ret =  window_median(al, ar, mid1, l2)
    else:
       assert direction == 0
       ret = mid
    '''
    return ret

def test_median(al, ar):
    return window_median(al, ar, 0, len(al))
N = 4
#a = [rand.randint(0, N-1) for _ in range(N)]
a0 = list(range(0,N))
