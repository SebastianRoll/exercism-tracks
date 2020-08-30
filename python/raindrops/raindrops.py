def convert(number):
    return "".join(
        [f"Pl{c}ng" * (not number % i) for c, i in zip(["i", "a", "o"], [3, 5, 7])]
    ) or str(number)
