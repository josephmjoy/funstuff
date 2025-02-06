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
    # Example: al=[1] ar=[0,2], i = 0, nl = 1, nr=2
    #    left_less + right_less = left_greater + right_greater # Ex: left_greater = left_less = 0; right_less=right_greater=1
    #                           = left_greater + nr - right_less # Ex: 0 + 2 - 1 = 1
    #    left_less = left_greater + nr - 2*right_less # 0 + 2 - 2*1 = 0
    #    2*right_less = nr + left_greater - left_less
    #    right_less = (nr + left_greater - left_less)/2
    #               = (nr + ((nl-1) - i) -i)/2 because left_less = i
    #               = (nr + (nl-1) - 2*i)/2
    #               = (nr + nl - 1)/2 - i # Ex: (2 + 1 - 1)/2 - 0 = 1
    # If total is even this is an integer
    # Note: right_i = right_less - 1 # right_i is the index *after* which {val} is to be inserted. Ex: 0
    right_i = (nr + nl - 1)//2 - i - 1 # Ex: (2 + 1 - 1)//2 - 0 - 1 = 0
    # {val} must be inserted between {right_i} and {right_i + 1}
    code = None
    if right_i < -1:
        code = 1 # i is too large
    elif right_i == -1: # Must be inserted *before* smallest element of {ar}
        code = 0 if val <= ar[0] else 1
    elif right_i < nr - 1: # Must be inserted between {right_i} and {right_i + 1}
        if val >= ar[right_i] and val <= ar[right_i + 1]:
            code = 0  # found
        elif val < ar[right_i]:
            code = -1 # i is too small
        elif val > ar[right_i + 1]:
            code = 1 # i is too large
        else:
            assert False
    elif right_i == nr - 1: # Must be inserted *after* largest element of {ar}
        code = 0 if val >= ar[nr - 1] else -1
    else: # i is too small
        assert right_i >= nr
        code = -1
    return (code, right_i + 1)



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

    # Special case of l2 == l1 + 1
    if l2 == l1 + 1: # only one item in the window!
        (code, right_i) = check_median(al[l1], l1, lenl, ar)
        return (0, right_i) if code == 0 else None  #     ------- EARLY RETURN ------

    ret = None
    recursive = True
    if not recursive:
        for i in range(l1, l2):
            (code, right_i) = check_median(al[i], i, lenl, ar)
            if code == 0:
                ret = (i, right_i)
                break
    else:
        i_mid = (l1 + l2 - 1) // 2  # (l2 is 1 more than max allowable index)
        (code, right_i) = check_median(al[i_mid], i_mid, lenl, ar)
        if code == 0:
            ret = (i_mid, right_i) # found it!
        elif code == -1: # mid is too low
            ret =  window_median(al, ar, i_mid + 1, l2) # [imid+1, l2) or [imid+1, l2-1]
        else: # mid is too high
            assert code == 1
            ret =  window_median(al, ar, l1, i_mid + 1) # [l1, imid + 1) or [l1, imid]

    return ret

def find_median(al, ar):
    wm1 = window_median(al, ar, 0, len(al))
    wm2 = window_median(ar, al, 0, len(ar))
    # r1 = al[i1] if i1 >= 0 and i1 < len(al) else None
    # r2 = ar[i2] if i2 >= 0 and i2 < len(ar) else None
    # return ((i1, r1), (i2, r2))
    m1 = m2 = None
    ret = None
    if wm1 != None:
        m1 = calc_median(al, wm1[0], ar, wm1[1])
        ret = m1
    if wm2 != None:
        m2 = calc_median(ar, wm2[0], al, wm2[1])
        ret = m2

    m = ret[0] if ret[1] == None else (ret[0] + ret[1])/2
    extra = ((wm1, m1), (wm2, m2)) # for debugging
    return (m, extra)

def test_median(al, ar):
    return window_median(al, ar, 0, len(al))

def calc_median(al, i, ar, j):
    '''
    Returns the actual median at al[i], or potentially between al[i] and the next
    higher element, that could be al[i+1] or ar[j]
    '''
    ll = len(al)
    lr = len(ar)
    val = al[i]
    if (ll + lr) % 2 == 1: # total size is odd
        return (val, None) # Exact median
    else:
        if i == ll - 1: # i is the rightmost element of al
            # TODO assert j == 0
            nextval = ar[j]
        else:
            alnextval = al[i+1]
            arnextval = ar[j] if j >= 0 and j < lr else alnextval + 1
            nextval = min(alnextval, arnextval)
        return (val, nextval)

def verify_sorted(a):
    assert len(a) > 0
    prev = a[0]
    for x in a[1:]:
        assert prev <= x
        prev = x

def find_and_verify_median(al, ar, verbose=False):
    verify_sorted(al)
    verify_sorted(ar)
    r = find_median(al, ar)
    combined = al+ar
    combined.sort()
    clen = len(combined)
    i = clen//2
    true_median = combined[i] if clen % 2 == 1 else (combined[i-1] + combined[i])/2
    m, dbg = find_median(al, ar)
    if verbose or m != true_median:
        if len(al) + len(ar) <= 30:
            print(f'al = {al}')
            print(f'ar = {ar}')
            print(f'combined = {combined}')
        print(f'true_median = {true_median}')
        wm1, m1 = dbg[0]
        wm2, m2 = dbg[1]
        print(f'fwd:{(wm1, m1)}, bkwd:{(wm2, m2)} # ((i, j), (m1, m2))')
        assert m == true_median, 'Incorrect median!'

def test_median():
    from random import randint as randint
    count = 0
    prev_logval = 0
    for N in range(2, 100):
        combined = [randint(0, N) for _ in range(0, N)]
        combined_sorted = combined[:]
        combined_sorted.sort()
        for nl in range(1, N):
            al = combined[:nl]
            ar = combined[nl:]
            al.sort()
            ar.sort()
            find_and_verify_median(al, ar)
            from math import log as log
            count += 1
            logval = log(count, 10)
            if logval > prev_logval + 1:
                print(f'N={N} nl = {len(al)} nr = {len(ar)}: PASSED')
                prev_logval = logval
    print(f'Total tests run: {count}')
if __name__ == '__main__':
    find_and_verify_median([0], [1,2], True)
