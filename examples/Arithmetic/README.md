# Arithmetic

This is a Roc solution for the following task;

> *Write a program that given a list of pairs of integers computes and displays their: Sum, Difference, Product, Quotient, Remainder, and Exponentiation.*

The program should warn about the danger of exponentiation.

The program should not crash when trying to divide by zero (the user should be warned).

The program should not crash when an operation would result in an Overflow (the user should be warned).

## Output

```
% roc run main.roc
✅ 0 + 0 = 0
✅ 0 - 0 = 0
✅ 0 x 0 = 0
❌ 0 // 0 would result in a division by zero
❌ 0 % 0 would result in a division by zero
⚠ 0 ^ 0 = 1 (an overflow might have happened)
--------------------------------------------------
✅ 2 + 10 = 12
✅ 2 - 10 = -8
✅ 2 x 10 = 20
✅ 2 // 10 = 0
✅ 2 % 10 = 2
⚠ 2 ^ 10 = 1024 (an overflow might have happened)
--------------------------------------------------
✅ -5 + 40 = 35
✅ -5 - 40 = -45
✅ -5 x 40 = -200
✅ -5 // 40 = 0
✅ -5 % 40 = -5
⚠ -5 ^ 40 = -5 (an overflow might have happened)
```

## Code
```roc
file:main.roc
```