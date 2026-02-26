# Command Line Murder Mystery — Solution

The clues and the interview are what created the suspect list. The interview confirmed that the suspect was male, not the female from the coffee shop. With this information, we were able to focus on finding a male who is 6ft or taller and a member of the four places in the clues.

---

## Command 1: Build the Suspect List

### Full command

```bash
grep -w 'M' people \
  | cut -f1 \
  | grep -Fxf memberships/AAA - \
  | grep -Fxf memberships/Delta_SkyMiles - \
  | grep -Fxf memberships/Terminal_City_Library - \
  | grep -Fxf memberships/Museum_of_Bash_History - \
  > suspect_list.txt
```

### Breakdown

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `grep -w 'M' people` | Grabs the `M` single letter from the people file to filter males |
| 2 | `cut -f1` | Grabs the name column from the people file |
| 3–6 | `grep -Fxf memberships/<file> -` | `-F` = string literal, `-x` = exact match (e.g. "Joe" not "Joel"), `-f` = read patterns from file, `-` = take stdin from the pipe. Applied to each membership file, then output to `suspect_list.txt` |

---

## Command 2: Filter by Height (6ft+)

Next, we know from the clues to find someone who is 6ft or taller. This information is available in the vehicles file.

### Full command

```bash
grep -B 1 "Height: [6-8]'" vehicles \
  | grep "Owner:" \
  | cut -d: -f2 \
  | sed 's/^ //' \
  | grep -Fxf suspect_list.txt -
```

### Breakdown

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `grep -B 1 "Height: [6-8]'" vehicles` | Finds anyone between 6–8ft tall |
| 2 | `grep "Owner:"` | Keeps only the owner line |
| 3 | `cut -d: -f2` | Extracts the owner name |
| 4 | `sed 's/^ //'` | Trims leading whitespace |
| 5 | `grep -Fxf suspect_list.txt -` | Cross-references tall car owners against the suspect list |

---

## Command 3: Check Each Suspect

At this point, the suspect list is short, so we can check the names one at a time. I opted to use an environment variable, but putting the names in a list and looping through would be better.

### Verification attempts

```bash
export SUSPECT='Mike Bostock'     # ❌ SORRY, TRY AGAIN.
export SUSPECT='Nikolaus Milatz'  # ❌ SORRY, TRY AGAIN.
export SUSPECT='Matt Waite'       # ❌ SORRY, TRY AGAIN.
export SUSPECT='Brian Boyer'      # ❌ SORRY, TRY AGAIN.
export SUSPECT='Augustin Lozano'  # ❌ SORRY, TRY AGAIN.
export SUSPECT='Jeremy Bowers'    # ✅ CORRECT! GREAT WORK, GUMSHOE.
```

## Proof:

```bash
dave@Davids-MacBook-Pro-3 command-line-mystery % echo $SUSPECT | $(command -v md5 || command -v md5sum) | grep -qif /dev/stdin encoded && echo CORRECT\! GREAT WORK, GUMSHOE. || echo SORRY, TRY AGAIN.
CORRECT! GREAT WORK, GUMSHOE.
```
