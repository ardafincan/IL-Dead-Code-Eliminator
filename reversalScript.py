with open("input.txt", "r") as f:
    intCode = f.readlines()
    reverseCode = intCode[::-1]
    with open("output.txt", "w") as out:
        for line in reverseCode:
            out.write(line)
        out.close()
        f.close()
