## Solutions

[Link to class materials](https://missing.csail.mit.edu/)

- [Solutions](#solutions)
  - [Shell Tools and Scripting Exercises](#shell-tools-and-scripting-exercises)
  - [Editors (Vim) Exercises](#editors-vim-exercises)
  - [Data Wrangling Exercises](#data-wrangling-exercises)
  - [Debugging and Profiling Exercises](#debugging-and-profiling-exercises)
    - [Debugging](#debugging)
    - [Profiling](#profiling)

### Shell Tools and Scripting Exercises
1. Read `man ls` and write an `ls` command that lists files in the following manner
   - Includes all files, including hidden files
   - Sizes are listed in human readable format (e.g. 454M instead of 454279954)
   - Files are ordered by recency
   - Output is colorized
- A sample output would look like this
    ```
    -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
    drwxr-xr-x   5 user group  160 Jan 14 09:53 .
    -rw-r--r--   1 user group  514 Jan 14 06:42 bar
    -rw-r--r--   1 user group 106M Jan 13 12:12 foo
    drwx------+ 47 user group 1.5K Jan 12 18:08 ..
    ```

    <details>
    <summary>Solutions</summary>

    ```bash
    # -l: use a long listing format
    # -a: Includes all files, including hidden files
    # -h: Sizes are listed in human readable format (e.g. 454M instead of 454279954)
    # -c: Files are ordered by recency
    # -G: Output is colorized
    $ ls -l -a -h -c -G
    ``` 

    </details>
    
---

2. Write bash functions `marco` and `polo` that do the following. Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no matter what directory you are in, `polo` should cd you back to the directory where you executed marco. For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`. <br></br>


    <details>
    <summary>Solutions</summary>

    - marco.sh

        ```bash
        #! /bin/zsh
        marco() {
            export MARCO=$(pwd);
            echo "Directory saved: $MARCO";
        }
        ```
    
    - polo.sh
        ```bash
        #! /bin/zsh
        polo() {
            cd $MARCO;
        }
        ```
    
    - testing
        ```bash
        ➜  ~$ marco
        Directory saved: /Users/vanessa
        ➜  ~$ cd Documents
        ➜  Documents$ marco
        Directory saved: /Users/vanessa/Documents
        ➜  Documents$ cd ../Downloads
        ➜  Downloads$ polo
        ➜  Documents$
        ```
    </details>

---

3. Say you have a command that fails rarely. In order to debug it you need to capture its output but it can be time consuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. Bonus points if you can also report how many runs it took for the script to fail.
   
    ```bash
    #!/usr/bin/env bash

    n=$(( RANDOM % 100 ))

    if [[ n -eq 42 ]]; then
        echo "Something went wrong"
        >&2 echo "The error was using magic numbers"
        exit 1
    fi

    echo "Everything went according to plan"
    ```
    
    </br>

    <details>
    <summary>Solutions</summary>

    - magic-numbers.sh: the above provided script

    - debug-magic-numbers.sh
        ```bash
        ➜  $ vim debug-magic-numbers.sh
        #!/bin/zsh

        counter=1;

        while true
        do
            response=$(./magic-numbers.sh);
            ((counter++));
            if [ "$response" != "Everything went according to plan" ]; then
                echo "Num runs: $counter";
                break
            fi
        done
        ```
    
    - testing
        ```bash
        ➜  $ sh debug-magic-numbers.sh
        The error was using magic numbers
        Num runs: 111
        ```
    
    </details>

---

4. As we covered in the lecture `find`’s `-exec` can be very powerful for performing operations over the files we are searching for. However, what if we want to do something with all the files, like creating a zip file? As you have seen so far commands will take input from both arguments and STDIN. When piping commands, we are connecting STDOUT to STDIN, but some commands like `tar` take inputs from arguments. To bridge this disconnect there’s the `xargs` command which will execute a command using STDIN as arguments. For example `ls | xargs rm` will delete the files in the current directory.
    
    </br>

    Your task is to write a command that recursively finds all HTML files in the folder and makes a zip with them. Note that your command should work even if the files have spaces (hint: check -d flag for xargs).

    </br>

    If you’re on macOS, note that the default BSD find is different from the one included in GNU coreutils. You can use -print0 on find and the -0 flag on xargs. As a macOS user, you should be aware that command-line utilities shipped with macOS may differ from the GNU counterparts; you can install the GNU versions if you like by using brew.

    </br>

    <details>
    <summary>Solutions</summary>

    - create test files
        ```bash
        ➜  $ tree
        .
        ├── html-files
        │   ├── subd
        │   │   └── test3.html
        │   ├── test1.html
        │   └── test 2.html
        ```
    
    - command
        ```bash
        # -print0: prints the pathnames followed by a NUL character
        # -0: expects NUL characters as separators
        ➜  $ find . -path '*.html' -print0 | xargs -0 tar -cf output.tar
        ```
    </details>

---

5. (Advanced) Write a command or script to recursively find the most recently modified file in a directory. More generally, can you list all files by recency?

    </br>

    <details>
    <summary>Solutions</summary>

    ```bash
    ➜  $ find . -print0 | xargs -0 ls -l -t
    ```

    </details>


### Editors (Vim) Exercises
1. Complete `vimtutor`. Note: it looks best in a 80x24 (80 columns by 24 lines) terminal window.

    </br>

    <details>

    ```
    Lesson 1 SUMMARY

    1. The cursor is moved using either the arrow keys or the hjkl keys.
            h (left)       j (down)       k (up)       l (right)

    2. To start Vim from the shell prompt type:  vim FILENAME <ENTER>

    3. To exit Vim type:     <ESC>   :q!   <ENTER>  to trash all changes.
                OR type:      <ESC>   :wq   <ENTER>  to save the changes.

    4. To delete the character at the cursor type:  x

    5. To insert or append text type:
            i   type inserted text   <ESC>         insert before the cursor
            A   type appended text   <ESC>         append after the line

    NOTE: Pressing <ESC> will place you in Normal mode or will cancel
        an unwanted and partially completed command.

    Now continue with lesson 2.

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 2 SUMMARY

     6. To delete from the cursor up to the next word type:        dw
     7. To delete from the cursor up to the end of the word type:  de
     8. To delete from the cursor to the end of a line type:       d$
     9. To delete a whole line type:                               dd

     10. To repeat a motion prepend it with a number:   2w
     11. The format for a change command is:
                  operator   [number]   motion
        where:
          operator - is what to do, such as  d  for delete
          [number] - is an optional count to repeat the motion
          motion   - moves over the text to operate on, such as  w (word),
                     e (end of word),  $ (end of the line), etc.

     12. To move to the start of the line use a zero:  0

     13. To undo previous actions, type:           u  (lowercase u)
        To undo all the changes on a line, type:  U  (capital U)
        To undo the undos, type:                  CTRL-R

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 3 SUMMARY

    1. To put back text that has just been deleted, type   p .  This puts the
        deleted text AFTER the cursor (if a line was deleted it will go on the
        line below the cursor).

    2. To replace the character under the cursor, type   r   and then the
        character you want to have there.

    3. The change operator allows you to change from the cursor to where the
        motion takes you.  eg. Type  ce  to change from the cursor to the end of
        the word,  c$  to change to the end of a line.

    4. The format for change is:

            c   [number]   motion

    Now go on to the next lesson.


   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 4 SUMMARY

    1. CTRL-G  displays your location in the file and the file status.
                G  moves to the end of the file.
        number  G  moves to that line number.
               gg  moves to the first line.

    2. Typing  /  followed by a phrase searches FORWARD for the phrase.
        Typing  ?  followed by a phrase searches BACKWARD for the phrase.
        After a search type  n  to find the next occurrence in the same direction
        or  N  to search in the opposite direction.
        CTRL-O takes you back to older positions, CTRL-I to newer positions.

    3. Typing  %  while the cursor is on a (,),[,],{, or } goes to its match.

    4. To substitute new for the first old in a line type    :s/old/new
        To substitute new for all 'old's on a line type       :s/old/new/g
        To substitute phrases between two line #'s type       :#,#s/old/new/g
        To substitute all occurrences in the file type        :%s/old/new/g
        To ask for confirmation each time add 'c'             :%s/old/new/gc

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 5 SUMMARY

    1.  :!command  executes an external command.

        Some useful examples are:
            (Windows)        (Unix)
            :!dir            :!ls            -  shows a directory listing.
            :!del FILENAME   :!rm FILENAME   -  removes file FILENAME.

    2.  :w FILENAME  writes the current Vim file to disk with name FILENAME.

    3.  v  motion  :w FILENAME  saves the Visually selected lines in file
        FILENAME.

    4.  :r FILENAME  retrieves disk file FILENAME and puts it below the
        cursor position.

    5.  :r !dir  reads the output of the dir command and puts it below the
        cursor position.
    
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 6 SUMMARY

    1. Type  o  to open a line BELOW the cursor and start Insert mode.
    Type  O  to open a line ABOVE the cursor.

    2. Type  a  to insert text AFTER the cursor.
    Type  A  to insert text after the end of the line.

    3. The  e  command moves to the end of a word.

    4. The  y  operator yanks (copies) text,  p  puts (pastes) it.

    5. Typing a capital  R  enters Replace mode until  <ESC>  is pressed.

    6. Typing ":set xxx" sets the option "xxx".  Some options are:
        'ic' 'ignorecase'       ignore upper/lower case when searching
        'is' 'incsearch'        show partial matches for a search phrase
        'hls' 'hlsearch'        highlight all matching phrases
    You can either use the long or the short option name.

    7. Prepend "no" to switch an option off:   :set noic

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Lesson 7 SUMMARY

    1. Type  :help  or press <F1> or <HELP>  to open a help window.

    2. Type  :help cmd  to find help on  cmd .

    3. Type  CTRL-W CTRL-W  to jump to another window.

    4. Type  :q  to close the help window.

    5. Create a vimrc startup script to keep your preferred settings.

    6. When typing a  :  command, press CTRL-D to see possible completions.
        Press <TAB> to use one completion.
    ```

    </details>

---
2. Download our `basic vimrc` and save it to ~/.vimrc. Read through the well-commented file (using Vim!), and observe how Vim looks and behaves slightly differently with the new config.
3. Install and configure a plugin: ctrlp.vim.
    1. Create the plugins directory with mkdir -p ~/.vim/pack/vendor/start
    2. Download the plugin: cd ~/.vim/pack/vendor/start; git clone https://github.com/ctrlpvim/ctrlp.vim
    3. Read the documentation for the plugin. Try using CtrlP to locate a file by navigating to a project directory, opening Vim, and using the Vim command-line to start :CtrlP.
    4. Customize CtrlP by adding configuration to your ~/.vimrc to open CtrlP by pressing Ctrl-P.
4. To practice using Vim, re-do the Demo from lecture on your own machine.
5. Use Vim for all your text editing for the next month. Whenever something seems inefficient, or when you think “there must be a better way”, try Googling it, there probably is. If you get stuck, come to office hours or send us an email.
6. Configure your other tools to use Vim bindings (see instructions above).
7. Further customize your ~/.vimrc and install more plugins.
8. (Advanced) Convert XML to JSON (example file) using Vim macros. Try to do this on your own, but you can look at the macros section above if you get stuck.

### Data Wrangling Exercises
1. Take this [short interactive regex tutorial](https://regexone.com/).
   
    Exercise 1: Matching Characters
    |Task	|Text	
    |---|---|
    |Match	|abcdefg
    |Match	|abcde
    |Match	|abc

    <details>
    <summary>Solutions</summary>

    `^abc.*$`

    </details>
    </br>

    Exercise 1½: Matching Digits
    |Task	|Text	
    |---|---|
    |Match	|abc123xyz	
    |Match	|define "123"	
    |Match	|var g = 123;

    <details>
    <summary>Solutions</summary>

    `^.*123.*$`

    </details>
    </br>

    Exercise 2: Matching With Wildcards
    |Task	|Text	
    |---|---|	 
    |Match	|cat.
    |Match	|896.
    |Match	|?=+.
    |Skip	|abc1

    <details>
    <summary>Solutions</summary>

    `^.*\..*$`

    </details>
    </br>

    Exercise 3: Matching Characters
    |Task	|Text	
    |---|---|
    |Match	|can
    |Match	|man
    |Match	|fan
    |Skip	|dan
    |Skip	|ran
    |Skip	|pan

    <details>
    <summary>Solutions</summary>

    `^[cmf]an$`

    </details>
    </br>

    Exercise 4: Excluding Characters
    |Task	|Text	
    |---|---|
    |Match	|hog
    |Match	|dog
    |Skip	|bog

    <details>
    <summary>Solutions</summary>

    `^[^b]og$`

    </details>
    </br>

    Exercise 5: Matching Character Ranges
    |Task	|Text	
    |---|---| 
    |Match	|Ana
    |Match	|Bob
    |Match	|Cpc
    |Skip	|aax
    |Skip	|bby
    |Skip	|ccz

    <details>
    <summary>Solutions</summary>

    `^[A-Z][a-z][a-z]$`

    </details>
    </br>

    Exercise 6: Matching Repeated Characters
    |Task	|Text	
    |---|---| 
    |Match	|wazzzzzup|
    |Match	|wazzzup|
    |Skip	|wazup|

    <details>
    <summary>Solutions</summary>

    `^wa[z]{2,}up$`

    </details>
    </br>

    Exercise 7: Matching Repeated Characters
    |Task	|Text	
    |---|---|
    |Match	|aaaabcc
    |Match	|aabbbbc
    |Match	|aacc
    |Skip	|a

    <details>
    <summary>Solutions</summary>

    `^[abc]{2,}$`

    </details>
    </br>

    Exercise 8: Matching Optional Characters
    |Task	|Text	
    |---|---|
    Match	|1 file found?
    Match	|2 files found?
    Match	|24 files found?
    Skip	|No files found.

    <details>
    <summary>Solutions</summary>

    `^\d{1,}\sfile[s]*\sfound\?$`

    </details>
    </br>

    Exercise 9: Matching Whitespaces
    |Task	|Text	
    |---|---|
    |Match	|1.   abc
    |Match	|2.	abc
    |Match	|3.           abc
    |Skip	|4.abc

    <details>
    <summary>Solutions</summary>

    `^\d\.\s+abc$`

    </details>
    </br>

    Exercise 10: Matching Lines
    |Task	|Text	
    |---|---|
    |Match	|Mission: successful	
    |Skip	|Last Mission: unsuccessful	
    |Skip	|Next Mission: successful upon capture of target

    <details>
    <summary>Solutions</summary>

    `^Mission:.*successful$`

    </details>
    </br>

    Exercise 11: Matching Groups

    |Task	|Text	|Capture Groups|
    |---|---|---|
    |Capture	|file_record_transcript.pdf	|file_record_transcript	
    |Capture	|file_07241999.pdf	|file_07241999	
    |Skip	|testfile_fake.pdf.tmp  |

    <details>
    <summary>Solutions</summary>

    `^(.*)\.pdf$`

    </details>
    </br>

    Exercise 12: Matching Nested Groups

    |Task	|Text	|Capture Groups|
    |---|---|---|
    |Capture	|Jan 1987	|Jan 1987 1987|
    |Capture	|May 1969	|May 1969 1969|
    |Capture	|Aug 2011	|Aug 2011 2011|

    <details>
    <summary>Solutions</summary>

    `^([A-Z][a-z]{2,3}\s(\d{4}))$`

    </details>
    </br>

    Exercise 13: Matching Nested Groups

    |Task	|Text	|Capture Groups|
    |---|---|---|
    |Capture	|1280x720	|1280 720|
    |Capture	|1920x1600	|1920 1600|
    |Capture	|1024x768	|1024 768|

    <details>
    <summary>Solutions</summary>

    `^(\d{3,})x(\d{3,})$`

    </details>
    </br>

    Exercise 14: Matching Conditional Text

    |Task	|Text	|
    |---|---|
    |Match	|I love cats|
    |Match	|I love dogs|
    |Skip	|I love logs|
    |Skip	|I love cogs|	

    <details>
    <summary>Solutions</summary>

    `^I love (cats|dogs)$`

    </details>
    </br>

    Exercise 15: Matching Other Special Characters

    |Task	|Text	|
    |---|---|
    |Match	|The quick brown fox jumps over the lazy dog.|
    |Match	|There were 614 instances of students getting 90.0% or above.|
    |Match	|The FCC had to censor the network for saying &$#*@!.|

    <details>
    <summary>Solutions</summary>

    `^I love (cats|dogs)$`

    </details>
    </br>

    Additional Problems
    </br>

    Exercise 1: Matching Numbers
    |Task	|Text	|
    |---|---|
    Match	|3.14529
    Match	|-255.34
    Match	|128	
    Match	|1.9e10	
    Match	|123,340.00
    Skip	|720p

    <details>
    <summary>Solutions</summary>

    `^[\d\.e\,\-]+$`

    </details>
    </br>

    Exercise 2: Matching Phone Numbers
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Capture	|415-555-1234	|415	
    Capture	|650-555-2345	|650	
    Capture	|(416)555-3456	|416	
    Capture	|202 555 4567	|202	
    Capture	|4035555678	|403	
    Capture	|1 416 555 9292	|416	

    <details>
    <summary>Solutions</summary>

    `^[1\s\(]*(\d{3}).*$`

    </details>
    </br>

    Exercise 3: Matching Emails
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Capture	|tom@hogwarts.com	|tom
    Capture	|tom.riddle@hogwarts.com	|tom.riddle
    Capture	|tom.riddle+regexone@hogwarts.com	|tom.riddle
    Capture	|tom@hogwarts.eu.com	|tom
    Capture	|potter@hogwarts.com	|potter
    Capture	|harry@hogwarts.com	|harry
    Capture	|hermione+regexone@hogwarts.com	|hermione

    <details>
    <summary>Solutions</summary>

    `^([A-Za-z\.]*).*@.*$`

    </details>
    </br>

    Exercise 4: Capturing HTML Tags
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Capture	|\<a>This is a link\</a>	|a	
    Capture	|\<a href='https://regexone.com'>Link\</a>	|a	
    Capture	|\<div class='test_style'>Test\</div>	|div	
    Capture	|\<div>Hello \<span>world\</span>\</div>	|div	

    <details>
    <summary>Solutions</summary>

    `^<([a-z]+).*>`

    </details>
    </br>

    Exercise 5: Capturing Filename Data
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Skip	|.bash_profile		|
    Skip	|workspace.doc		|
    Capture	|img0912.jpg	|img0912 jpg	
    Capture	|updated_img0912.png	|updated_img0912 png	
    Skip	|documentation.html		
    Capture	|favicon.gif	|favicon gif	
    Skip	|img0912.jpg.tmp		|
    Skip	|access.lock		|

    <details>
    <summary>Solutions</summary>

    `^(.*)\.(jpg|png|gif)$`

    </details>
    </br>

    Exercise 6: Matching Lines
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Capture|				The quick brown fox...	|The quick brown fox...	
    Capture|	   jumps over the lazy dog.	|jumps over the lazy dog.	

    <details>
    <summary>Solutions</summary>

    `^\s*([A-Za-z\s\.]+)\s*$`

    </details>
    </br>

    Exercise 7: Extracting Data From Log Entries
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Skip	|W/dalvikvm( 1553): threadid=1: uncaught exception		|
    Skip	|E/( 1553): FATAL EXCEPTION: main		|
    Skip	|E/( 1553): java.lang.StringIndexOutOfBoundsException		|
    Capture	|E/( 1553):   at widget.List.makeView(ListView.java:1727)	|makeView ListView.java 1727	
    Capture	|E/( 1553):   at widget.List.fillDown(ListView.java:652)	|fillDown ListView.java 652	
    Capture	|E/( 1553):   at widget.List.fillFrom(ListView.java:709)	|fillFrom ListView.java 709	

    <details>
    <summary>Solutions</summary>

    `^.*at .*\..*\.(.*)\((.*):(\d{1,})\)$`

    </details>
    </br>

    Exercise 8: Extracting Data From URLs
    |Task	|Text	|Capture Groups	 
    |---|---|---|
    Capture	|ftp://file_server.com:21/top_secret/life_changing_plans.pdf	|ftp file_server.com 21	
    Capture	|https://regexone.com/lesson/introduction#section	|https regexone.com	
    Capture	|file://localhost:4040/zip_file	|file localhost 4040	
    Capture	|https://s3cur3-server.com:9999/	|https s3cur3-server.com 9999	
    Capture	|market://search/angry%20birds	|market search
    <details>
    <summary>Solutions</summary>

    `^(.*)://([A-Za-z0-9\.\_\-]*):*(\d{1,})*/.*$`

    </details>
    </br>

---
2. Find the number of words (in /usr/share/dict/words) that contain at least three as and don’t have a 's ending. What are the three most common last two letters of those words? `sed`’s `y` command, or the `tr` program, may help you with case insensitivity. How many of those two-letter combinations are there? And for a challenge: which combinations do not occur?
    </br>
    <details>
    <summary>Solutions</summary>

    ```bash
    # Find the number of words (in /usr/share/dict/words) that contain at least three as and don’t have a 's ending
    ~ cat /usr/share/dict/words | grep --regexp="^.*'s$" -v | grep --regexp="^.*a.*a.*a.*$" | wc -l
    7048

    # What are the three most common last two letters of those words?
    ➜  ~ cat /usr/share/dict/words | grep --regexp="^.*'s$" -v | grep --regexp="^.*a.*a.*a.*$" | sed -E 's/^.*(.{2})$/\1/' | sort | uniq -i -c | sort | tail -n3
    682 an
    752 ia
    1031 al

    # How many of those two-letter combinations are there?
    ➜  ~ cat /usr/share/dict/words | grep --regexp="^.*'s$" -v | grep --regexp="^.*a.*a.*a.*$" | sed -E 's/^.*(.{2})$/\1/' | sort | uniq -i | wc -l
    150

    # which combinations do not occur?
    echo {a..z}{a..z}
    ```

    </details>

---
3. To do in-place substitution it is quite tempting to do something like `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`. However this is a bad idea, why? Is this particular to `sed`? Use `man sed` to find out how to accomplish this.

    </br>
    <details>
    <summary>Solutions</summary>

    Overwriting while reading could lead to potential data loss.
    ```bash
    sed -i s/REGEX/SUBSTITUTION/ input.txt
    ```

    </details>

---
4. Find your average, median, and max system boot time over the last ten boots. Use `journalctl` on Linux and `log show` on macOS, and look for log timestamps near the beginning and end of each boot. On Linux, they may look something like:
    ```
    Logs begin at ...
    ```
    and
    ```
    systemd[577]: Startup finished in ...
    ```
    On macOS, look for:
    ```
    === system boot:
    ```
    and
    ```
    Previous shutdown cause: 5
    ```
---
5. Look for boot messages that are not shared between your past three reboots (see journalctl’s -b flag). Break this task down into multiple steps. First, find a way to get just the logs from the past three boots. There may be an applicable flag on the tool you use to extract the boot logs, or you can use sed '0,/STRING/d' to remove all lines previous to one that matches STRING. Next, remove any parts of the line that always varies (like the timestamp). Then, de-duplicate the input lines and keep a count of each one (uniq is your friend). And finally, eliminate any line whose count is 3 (since it was shared among all the boots).
---
6. Find an online data set like [this one](https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm), [this one](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1), or maybe one [from here](https://www.springboard.com/blog/data-science/free-public-data-sets-data-science-project/). Fetch it using `curl` and extract out just two columns of numerical data. If you’re fetching HTML data, `pup` might be helpful. For JSON data, try `jq`. Find the min and max of one column in a single command, and the difference of the sum of each column in another.

    </br>
    <details>
    <summary>Solutions</summary>

    ```bash
    # 1. install pup
    ➜  ~ brew install pup

    # 2. fetch the FBI crime data via curl and save as a local HTML file
    ➜  ~ curl https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1 -H "User-Agent: Mozilla/5.0" -o crime.html

    # column 1: Population
    ➜  ~ cat crime.html| pup --color 'td.group1' | grep -v '<' | sort | head -n 1
    267,783,607
    ➜  ~ cat crime.html| pup --color 'td.group1' | grep -v '<' | sort | tail -n 1
    323,127,513
    ➜  ~ cat crime.html| pup --color 'td.group1' | grep -v '<' | sed 's/,//g' | tr '\n' '+' | sed 's/+$//' | bc
    5972695389

    # column 2: Violent crime
    ➜  ~ cat crime.html| pup --color 'td.group2' | grep -v '<' | sort | head -n 1
    1,153,022
    ➜  ~ cat crime.html| pup --color 'td.group2' | grep -v '<' | sort | tail -n 1
    1,636,096
    ➜  ~ cat crime.html| pup --color 'td.group2' | grep -v '<' | sed 's/,//g' | tr '\n' '+' | sed 's/+$//' | bc
    27040754

    # find the difference of sum between two columns
    ➜  ~ echo "$(cat crime.html| pup --color 'td.group1' | grep -v '<' | sed 's/,//g' | tr '\n' '+' | sed 's/+$//') - ($(cat crime.html| pup --color 'td.group2' | grep -v '<' | sed 's/,//g' | tr '\n' '+' | sed 's/+$//'))" | bc
    5945654635
    ```

    </details>


### Debugging and Profiling Exercises
#### Debugging
1. Use `journalctl` on Linux or `log show` on macOS to get the super user accesses and commands in the last day. If there aren’t any you can execute some harmless commands such as sudo ls and check again.
   
    </br>
    <details>
    <summary>Solutions</summary>
    
    ```bash
    log show --last 1d --predicate "process == 'sudo'"
    ```

    </details>
---
2. Do [this](https://github.com/spiside/pdb-tutorial) hands on `pdb` tutorial to familiarize yourself with the commands. For a more in depth tutorial read [this](https://realpython.com/python-debugging-pdb/).
---

3. Install [`shellcheck`](https://www.shellcheck.net/) and try checking the following script. What is wrong with the code? Fix it. Install a linter plugin in your editor so you can get your warnings automatically.

    ```bash
    #!/bin/sh
    ## Example: a typical script with several problems
    for f in $(ls *.m3u)
    do
    grep -qi hq.*mp3 $f \
        && echo -e 'Playlist $f contains a HQ file in mp3 format'
    done
    ```

    </br>
    <details>
    <summary>Solutions</summary>

    ```bash
    ➜  ~ vim test.sh
    ➜  ~ shellcheck test.sh
    In test.sh line 3:
    for f in $(ls *.m3u)
            ^---------^ SC2045 (error): Iterating over ls output is fragile. Use globs.
                ^-- SC2035 (info): Use ./*glob* or -- *glob* so names with dashes won't become options.


    In test.sh line 5:
    grep -qi hq.*mp3 $f \
            ^-----^ SC2062 (warning): Quote the grep pattern so the shell won't interpret it.
                    ^-- SC2086 (info): Double quote to prevent globbing and word splitting.

    Did you mean:
    grep -qi hq.*mp3 "$f" \


    In test.sh line 6:
        && echo -e 'Playlist $f contains a HQ file in mp3 format'
                ^-- SC3037 (warning): In POSIX sh, echo flags are undefined.
                ^-- SC2016 (info): Expressions don't expand in single quotes, use double quotes for that.

    For more information:
    https://www.shellcheck.net/wiki/SC2045 -- Iterating over ls output is fragi...
    https://www.shellcheck.net/wiki/SC2062 -- Quote the grep pattern so the she...
    https://www.shellcheck.net/wiki/SC3037 -- In POSIX sh, echo flags are undef...
    ```

    ```bash
    #!/bin/sh
    ## Example: a typical script with several problems
    for f in  *.m3u
    do
       grep -qi "hq.*mp3" "$f" \
       && printf "Playlist %s contains a HQ file in mp3 format" "$f"
    done
    ```

    </details>

---

4. (Advanced) Read about [reversible debugging](https://undo.io/resources/reverse-debugging-whitepaper/) and get a simple example working using rr or RevPDB.

#### Profiling
5. Here are some sorting algorithm implementations. Use cProfile and line_profiler to compare the runtime of insertion sort and quicksort. What is the bottleneck of each algorithm? Use then memory_profiler to check the memory consumption, why is insertion sort better? Check now the inplace version of quicksort. Challenge: Use perf to look at the cycle counts and cache hits and misses of each algorithm.
---

6. Here’s some (arguably convoluted) Python code for computing Fibonacci numbers using a function for each number.

```python
#!/usr/bin/env python
def fib0(): return 0

def fib1(): return 1

s = """def fib{}(): return fib{}() + fib{}()"""

if __name__ == '__main__':

    for n in range(2, 10):
        exec(s.format(n, n-1, n-2))
    # from functools import lru_cache
    # for n in range(10):
    #     exec("fib{} = lru_cache(1)(fib{})".format(n, n))
    print(eval("fib9()"))
```

Put the code into a file and make it executable. Install prerequisites: pycallgraph and graphviz. (If you can run dot, you already have GraphViz.) Run the code as is with pycallgraph graphviz -- ./fib.py and check the pycallgraph.png file. How many times is fib0 called?. We can do better than that by memoizing the functions. Uncomment the commented lines and regenerate the images. How many times are we calling each fibN function now?

---

7. A common issue is that a port you want to listen on is already taken by another process. Let’s learn how to discover that process pid. First execute `python -m http.server 4444` to start a minimal web server listening on port 4444. On a separate terminal run `lsof | grep LISTEN` to print all listening processes and ports. Find that process pid and terminate it by running `kill <PID>`.

    </br>
    <details>
    <summary>Solutions</summary>

    ```bash
    ➜  ~ python3 -m http.server 4444
    Serving HTTP on :: port 4444 (http://[::]:4444/) ...

    # -iTCP: Lists only TCP network connections.
    # -sTCP:LISTEN: Filters for listening sockets.
    # -P: Displays port numbers instead of attempting to resolve service names.
    ➜  ~ lsof -iTCP -sTCP:LISTEN -P | grep 4444
    Python    94711 vanessa    4u  IPv6 0xf4b871a890b02d67      0t0  TCP *:4444 (LISTEN)
    ➜  ~ kill 94711

    [1]    94711 terminated  python3 -m http.server 4444
    ```
    </details>
---

8. Limiting a process’s resources can be another handy tool in your toolbox. Try running stress -c 3 and visualize the CPU consumption with htop. Now, execute taskset --cpu-list 0,2 stress -c 3 and visualize it. Is stress taking three CPUs? Why not? Read man taskset. Challenge: achieve the same using cgroups. Try limiting the memory consumption of stress -m.

---

9. (Advanced) The command curl ipinfo.io performs a HTTP request and fetches information about your public IP. Open Wireshark and try to sniff the request and reply packets that curl sent and received. (Hint: Use the http filter to just watch HTTP packets).

