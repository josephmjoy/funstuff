# MINCPU: A Mijjnimal CPU Architecture


## Working Doc
https://docs.google.com/document/d/17AJ7x4v8D95TJLc58pEsGX3iTWN-aZa6sDZFsPrQbjg/


# Scratch

def main():
    x = sum(3, 5)
    print(x)
    y = x

def sum(i, j):
    return i + j






main:
    ...
    PUSH 3
    PUSH 5
    CALL sum
    STR X0, [FP] // store return value into variable x

    LDR X0, [FP]
    PUSH X0
    CALL print

    // Note: [FP+8] is the address in memory of variable y
    LDR X0, [FP]
    STR X0, [FP+8]

sum:
   PUSH FP
   MOV FP, SP
   .. Tommy write the rest of the code ...


