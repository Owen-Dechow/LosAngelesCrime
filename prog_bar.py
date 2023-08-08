from colorama import Fore
from math import floor


def progress_bar(progress):
    PASSED = "*"  # "█"
    PROG = "-"
    BAR_SIZE = 20
    DECIMALS = 2
    if progress >= 1:
        print(
            f"\t|{Fore.GREEN}{PASSED * BAR_SIZE}{Fore.RESET}| 100%  {' ' * (DECIMALS + 1)}"
        )
        return

    passed_slots = floor(progress * BAR_SIZE)
    not_passed_slots = BAR_SIZE - passed_slots

    # Passed slots
    prog_bar = "\t|" + Fore.BLUE + PASSED * passed_slots

    # Non passed slots
    prog_bar += Fore.YELLOW + PROG * not_passed_slots

    # End area
    prog_bar += f"{Fore.RESET}| {round(progress*100, DECIMALS)}%"
    print(prog_bar, end="\r")


def spinner(num, speed_factor):
    LEVELS = ["|", "/", "⎯", "\\"]
    WIDTH = 20
    step = floor(num * speed_factor) % len(LEVELS)
    print(f"{LEVELS[step] * WIDTH} Loading {LEVELS[step] * WIDTH}", end="\r")
