# Bash Notes

## `ls` — List Files and Directories

List files in the current directory:

```bash
ls
```

List recursively, including subdirectories:

```bash
ls -R
```

Useful variants:

```bash
ls -la       # Include hidden files and show details
ls -lR       # Recursive with details
ls -laR      # Recursive with details and hidden files
```

To list everything recursively, `find` is often cleaner:

```bash
find .
```

Directories only:

```bash
find . -type d
```

Files only:

```bash
find . -type f
```

---

## `grep` — Search Text

Search for a string:

```bash
grep 'apple' file.txt
```

Search for either of two strings:

```bash
grep -E 'apple|banana' file.txt
```

`-E` enables **Extended Regular Expressions**, allowing operators such as `|` for OR.

Search recursively:

```bash
grep -rE 'apple|banana' .
```

Useful options:

```bash
grep -i 'apple' file.txt    # Case-insensitive
grep -n 'apple' file.txt    # Show line numbers
grep -r 'apple' .           # Search recursively
```

To find lines containing **both** strings:

```bash
grep 'apple' file.txt | grep 'banana'
```

---

## `wc` — Count Lines, Words, and Bytes

```bash
wc file.txt
```

The default output contains lines, words, bytes, and the filename.

Common options:

```bash
wc -l file.txt    # Lines
wc -w file.txt    # Words
wc -c file.txt    # Bytes
wc -m file.txt    # Characters
```

Count matching lines:

```bash
grep 'ERROR' file.txt | wc -l
```

Count files recursively:

```bash
find . -type f | wc -l
```

---

## `cut` — Extract Fields or Characters

Extract field 2 from comma-separated text:

```bash
cut -d',' -f2 file.csv
```

Here, `-d','` sets the delimiter and `-f2` selects field 2.

Multiple fields and ranges:

```bash
cut -d',' -f1,3 file.csv
cut -d',' -f1-3 file.csv
```

Character positions:

```bash
cut -c1-5 file.txt
```

`cut -f` accepts **field numbers, not field names**. To select a column dynamically by its header, `awk` can be used:

```bash
awk -F',' 'NR==1 {for(i=1;i<=NF;i++) if($i=="age") col=i} {print $col}' file.csv
```

For real CSV files containing quoted commas or other CSV complexities, use a CSV-aware tool rather than `cut` or simple `awk`.

---

## `uniq` — Count Duplicate Values

`uniq` operates on **consecutive identical lines**:

```bash
uniq -c file.txt
```

Because duplicates must be adjacent, it is commonly combined with `sort`:

```bash
sort file.txt | uniq -c
```

Sort counts from highest to lowest:

```bash
sort file.txt | uniq -c | sort -nr
```

A common frequency-count pattern:

```bash
cut -d',' -f2 file.csv | sort | uniq -c | sort -nr
```

Conceptually: extract → sort → count → rank.

---

## `sed` — Transform Text

`sed` is a **stream editor**. A common use is find-and-replace:

```bash
sed 's/old/new/' file.txt
```

This replaces the first match on each line. Add `g` to replace all matches on each line:

```bash
sed 's/apple/orange/g' file.txt
```

By default, `sed` prints the transformed result rather than changing the original file.

Save to another file:

```bash
sed 's/apple/orange/g' file.txt > newfile.txt
```

Modify in place on GNU/Linux:

```bash
sed -i 's/apple/orange/g' file.txt
```

Delete lines containing a pattern:

```bash
sed '/ERROR/d' file.txt
```

---

## Reading Script Arguments

If a script is run as:

```bash
./script.sh apple banana 123
```

Bash exposes its arguments as:

```bash
$0      # Script name
$1      # First argument
$2      # Second argument
$#      # Number of arguments
"$@"    # All arguments, preserving separate values
"$*"    # All arguments combined
```

A common way to iterate over every argument is:

```bash
for arg in "$@"; do
    echo "Argument: $arg"
done
```

Using `"$@"` preserves an argument such as `"New York"` as one value.

---

## `cat` — Display File Contents

Display all matching files in the current directory:

```bash
cat *
```

If `*` includes directories, `cat` will complain about them. For regular files only:

```bash
find . -maxdepth 1 -type f -exec cat {} +
```

Display all regular files recursively:

```bash
find . -type f -exec cat {} +
```

Display a particular file type:

```bash
cat *.txt
```

Recursively display a particular file type:

```bash
find . -type f -name '*.txt' -exec cat {} +
```

---

## Useful Bash Pattern

Commands can be chained with pipes:

```bash
command1 | command2 | command3
```

For example:

```bash
grep 'ERROR' logfile.txt | cut -d' ' -f1 | sort | uniq -c | sort -nr
```

Conceptually:

```text
filter → extract → sort → count → rank
```
