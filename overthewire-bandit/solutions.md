## Solutions

Link to the challenge:https://overthewire.org/wargames/bandit/

- [Solutions](#solutions)
  - [Bandit Level 11 → Level 12](#bandit-level-11--level-12)
  - [Bandit Level 12 → Level 13](#bandit-level-12--level-13)
  - [Bandit Level 13 → Level 14](#bandit-level-13--level-14)
  - [Bandit Level 14 → Level 15](#bandit-level-14--level-15)
  - [Bandit Level 15 → Level 16](#bandit-level-15--level-16)
  - [Bandit Level 16 → Level 17](#bandit-level-16--level-17)
  - [Bandit Level 17 → Level 18](#bandit-level-17--level-18)
  - [Bandit Level 18 → Level 19](#bandit-level-18--level-19)
  - [Bandit Level 19 → Level 20](#bandit-level-19--level-20)
  - [Bandit Level 19 → Level 20](#bandit-level-19--level-20-1)
  - [Bandit Level 20 → Level 21](#bandit-level-20--level-21)
  - [Bandit Level 21 → Level 22](#bandit-level-21--level-22)
  - [Bandit Level 22 → Level 23](#bandit-level-22--level-23)
  - [Bandit Level 23 → Level 24](#bandit-level-23--level-24)
  - [Bandit Level 24 → Level 25](#bandit-level-24--level-25)
  - [Bandit Level 25 → Level 26](#bandit-level-25--level-26)
  - [Bandit Level 26 → Level 27](#bandit-level-26--level-27)
  - [Bandit Level 27 → Level 28](#bandit-level-27--level-28)
  - [Bandit Level 28 → Level 29](#bandit-level-28--level-29)
  - [Bandit Level 29 → Level 30](#bandit-level-29--level-30)
  - [Bandit Level 30 → Level 31](#bandit-level-30--level-31)
  - [Bandit Level 31 → Level 32](#bandit-level-31--level-32)
  - [Bandit Level 32 → Level 33](#bandit-level-32--level-33)
  - [Bandit Level 33 → Level 34](#bandit-level-33--level-34)
  - [All passwords](#all-passwords)

### Bandit Level 11 → Level 12
The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions

```bash
cat data.txt  | tr 'N-ZA-Mn-za-m' 'A-Za-z'
```

### Bandit Level 12 → Level 13
The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command “mktemp -d”. Then copy the datafile using cp, and rename it using mv (read the manpages!)

```bash
$ xxd -r data.txt data-reversed.txt
$ file data-reversed.txt
data-reversed.txt: gzip compressed data, was "data2.bin", last modified: Wed Jul 17 15:57:06 2024, max compression, from Unix, original size modulo 2^32 577
$ gunzip data-reversed.txt -S .txt
$ ls
data-reversed  data.txt  -p  -r
$ file data-reversed
data-reversed: bzip2 compressed data, block size = 900k
$ bunzip2 data-reversed
bunzip2: Can't guess original name for data-reversed -- using data-reversed.out
$ ls
data-reversed.out  data.txt  -p  -r
$ file data-reversed.out
data-reversed.out: gzip compressed data, was "data4.bin", last modified: Wed Jul 17 15:57:06 2024, max compression, from Unix, original size modulo 2^32 20480
$ gunzip data-reversed.out -S .out
$ file data-reversed
data-reversed: POSIX tar archive (GNU)
$ tar -xvf data-reversed
data5.bin
$ file data5.bin
data5.bin: POSIX tar archive (GNU)
$ tar -xvf data5.bin
data6.bin
$ tar -xvf data6.bin
data8.bin
$ file data8.bin
data8.bin: gzip compressed data, was "data9.bin", last modified: Wed Jul 17 15:57:06 2024, max compression, from Unix, original size modulo 2^32 49
$ gunzip data8.bin -S .bin
$ file data8
data8: ASCII text
$ cat data8
The password is FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn
```

### Bandit Level 13 → Level 14
The password for the next level is stored in /etc/bandit_pass/bandit14 and can only be read by user bandit14. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level. Note: localhost is a hostname that refers to the machine you are working on

```bash
ssh -i sshkey.private bandit14@localhost  -p 2220
```

### Bandit Level 14 → Level 15
The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost.

```bash
$ echo $(cat /etc/bandit_pass/bandit14) | nc localhost 30000
Correct!
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
```

### Bandit Level 15 → Level 16
The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL/TLS encryption.

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.

```bash
$ openssl s_client -connect localhost:30001
CONNECTED(00000003)
...
read R BLOCK
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
Correct!
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

closed
```


### Bandit Level 16 → Level 17
The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL/TLS and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.

```bash
bandit16@bandit:~$ nmap localhost -p 31000-32000 -sV
Starting Nmap 7.94SVN ( https://nmap.org ) at 2024-08-07 00:01 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00015s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT      STATE SERVICE     VERSION
31046/tcp open  echo
31518/tcp open  ssl/echo
31691/tcp open  echo
31790/tcp open  ssl/unknown
31960/tcp open  echo
...

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 167.95 seconds

$ openssl s_client -connect localhost:31790 -ign_eof
CONNECTED(00000003)
read R BLOCK
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx
Correct!
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----

closed
```

### Bandit Level 17 → Level 18
There are 2 files in the homedirectory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new

NOTE: if you have solved this level and see ‘Byebye!’ when trying to log into bandit18, this is related to the next level, bandit19

```bash
$ diff passwords.old passwords.new
```

### Bandit Level 18 → Level 19
The password for the next level is stored in a file readme in the homedirectory. Unfortunately, someone has modified .bashrc to log you out when you log in with SSH.

### Bandit Level 19 → Level 20
To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary.

```bash
$ssh -f bandit18@bandit.labs.overthewire.org -p 2220 cat readme
```

### Bandit Level 19 → Level 20
To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary.

```bash
$ file bandit20-do
bandit20-do: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, BuildID[sha1]=368cd8ac4633fabdf3f4fb1c47a250634d6a8347, for GNU/Linux 3.2.0, not stripped
$ /lib/ld-linux.so.2 ~/bandit20-do
Run a command as another user.
  Example: /home/bandit19/bandit20-do id
$ /home/bandit19/bandit20-do cat /etc/bandit_pass/bandit20
0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO
```

### Bandit Level 20 → Level 21
There is a setuid binary in the homedirectory that does the following: it makes a connection to localhost on the port you specify as a commandline argument. It then reads a line of text from the connection and compares it to the password in the previous level (bandit20). If the password is correct, it will transmit the password for the next level (bandit21).

NOTE: Try connecting to your own network daemon to see if it works as you think

```bash
$ echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" | nc -l localhost 12345 &
[1] 3752913
$ jobs
[1]+  Running                 echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" | nc -l localhost 12345 &
$ ~/suconnect 12345
Read: 0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO
Password matches, sending next password
EeoULMCra2q0dSkYj561DX7s1CpBuOBt
[1]+  Done                    echo "0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO" | nc -l localhost 12345
```

### Bandit Level 21 → Level 22
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

```bash
$ ls /etc/cron.d/
cronjob_bandit22  cronjob_bandit24  otw-tmp-dir
cronjob_bandit23  e2scrub_all       sysstat
$ cat /etc/cron.d/cronjob_bandit22
@reboot bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null
$ cat /usr/bin/cronjob_bandit22.sh
#!/bin/bash
chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
$ cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q
```

### Bandit Level 22 → Level 23
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

NOTE: Looking at shell scripts written by other people is a very useful skill. The script for this level is intentionally made easy to read. If you are having problems understanding what it does, try executing it to see the debug information it prints.

```bash
$ ls /etc/cron.d/
cronjob_bandit22  cronjob_bandit24  otw-tmp-dir
cronjob_bandit23  e2scrub_all       sysstat
$ cat /etc/cron.d/cronjob_bandit23
@reboot bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null
* * * * * bandit23 /usr/bin/cronjob_bandit23.sh  &> /dev/null
$ cat /usr/bin/cronjob_bandit23.sh
#!/bin/bash

myname=$(whoami)
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)

echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"

cat /etc/bandit_pass/$myname > /tmp/$mytarget

$ export myname=bandit23
$ export mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)
$ cat /etc/bandit_pass/$myname > /tmp/$mytarget
$ echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"
Copying passwordfile /etc/bandit_pass/bandit23 to /tmp/8ca319486bfbbc3663ea0fbe81326349
$ cat /tmp/8ca319486bfbbc3663ea0fbe81326349
0Zf11ioIjMVN551jX3CmStKLYqjk54Ga
```

### Bandit Level 23 → Level 24
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

NOTE: This level requires you to create your own first shell-script. This is a very big step and you should be proud of yourself when you beat this level!

NOTE 2: Keep in mind that your shell script is removed once executed, so you may want to keep a copy around…

```bash
$ ls /etc/cron.d/
cronjob_bandit22  cronjob_bandit24  otw-tmp-dir
cronjob_bandit23  e2scrub_all       sysstat
$ cp /usr/bin/cronjob_bandit23.sh /tmp/cronjob_bandit24.sh
$ nano /tmp/cronjob_bandit24.sh
$ cat /tmp/cronjob_bandit24.sh
#!/bin/bash

myname=bandit24
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)

echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"

cat /etc/bandit_pass/$myname > /tmp/$mytarget
$ bash /tmp/cronjob_bandit24.sh
Copying passwordfile /etc/bandit_pass/bandit24 to /tmp/ee4ee1703b083edac9f8183e4ae70293
$ cat /tmp/ee4ee1703b083edac9f8183e4ae70293
gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8
```

### Bandit Level 24 → Level 25
A daemon is listening on port 30002 and will give you the password for bandit25 if given the password for bandit24 and a secret numeric 4-digit pincode. There is no way to retrieve the pincode except by going through all of the 10000 combinations, called brute-forcing.
You do not need to create new connections each time

```bash
$ for i in {0000..9999}; do echo "gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 $i"; done | nc localhost 30002
```

### Bandit Level 25 → Level 26
Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not /bin/bash, but something else. Find out what it is, how it works and how to break out of it.

```bash
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
...
bandit25:x:11025:11025:bandit level 25:/home/bandit25:/bin/bash
bandit26:x:11026:11026:bandit level 26:/home/bandit26:/usr/bin/showtext
...

$ cat /usr/bin/showtext
#!/bin/sh

export TERM=linux

exec more ~/text.txt
exit 0

$ ssh -i bandit26.sshkey bandit26@bandit.labs.overthewire.org -p 2220
```

### Bandit Level 26 → Level 27
Good job getting a shell! Now hurry and grab the password for bandit27!

```bash
$ ./bandit27-do
Run a command as another user
  Example: ./bandit27-do id
$ ./bandit27-do cat /etc/bandit_pass/bandit27
upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB
```

### Bandit Level 27 → Level 28
There is a git repository at ssh://bandit27-git@localhost/home/bandit27-git/repo via the port 2220. The password for the user bandit27-git is the same as for the user bandit27.

Clone the repository and find the password for the next level.


```bash
$ cd /tmp/
$ mkdir tmp-repo
$ cd tmp-repo
$ git clone ssh://bandit27-git@localhost:2220/home/bandit27-git/repo
Cloning into 'repo'...
...
bandit27-git@localhost's password:
...
Receiving objects: 100% (3/3), done.
$ ls
README
$ cat README
The password to the next level is: Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN
```

### Bandit Level 28 → Level 29
There is a git repository at ssh://bandit28-git@localhost/home/bandit28-git/repo via the port 2220. The password for the user bandit28-git is the same as for the user bandit28.

Clone the repository and find the password for the next level.

```bash
# First couple steps are the same as level27
bandit28@bandit:/tmp/tmp-repo-bandit28/repo$ cat README.md
# Bandit Notes
Some notes for level29 of bandit.

## credentials

- username: bandit29
- password: xxxxxxxxxx

bandit28@bandit:/tmp/tmp-repo-bandit28/repo$ git log
commit 8cbd1e08d1879415541ba19ddee3579e80e3f61a (HEAD -> master, origin/master, origin/HEAD)
Author: Morla Porla <morla@overthewire.org>
Date:   Wed Jul 17 15:57:30 2024 +0000

    fix info leak

commit 73f5d0435070c8922da12177dc93f40b2285e22a
Author: Morla Porla <morla@overthewire.org>
Date:   Wed Jul 17 15:57:30 2024 +0000

    add missing data

commit 5f7265568c7b503b276ec20f677b68c92b43b712
Author: Ben Dover <noone@overthewire.org>

bandit28@bandit:/tmp/tmp-repo-bandit28/repo$ git checkout 73f5d0435070c8922da12177dc93f40b2285e22a
Previous HEAD position was 5f72655 initial commit of README.md
HEAD is now at 73f5d04 add missing data

bandit28@bandit:/tmp/tmp-repo-bandit28/repo$ cat README.md
# Bandit Notes
Some notes for level29 of bandit.

## credentials

- username: bandit29
- password: 4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7
```


### Bandit Level 29 → Level 30
There is a git repository at ssh://bandit29-git@localhost/home/bandit29-git/repo via the port 2220. The password for the user bandit29-git is the same as for the user bandit29.

Clone the repository and find the password for the next level.

```bash
# First couple steps are the same as level27 and level28
bandit29@bandit:/tmp/tmp-repo-bandit29/repo$ cat README.md
# Bandit Notes
Some notes for bandit30 of bandit.

## credentials

- username: bandit30
- password: <no passwords in production!>

bandit29@bandit:/tmp/tmp-repo-bandit29/repo$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/dev
  remotes/origin/master
  remotes/origin/sploits-dev
bandit29@bandit:/tmp/tmp-repo-bandit29/repo$ git checkout dev
branch 'dev' set up to track 'origin/dev'.
Switched to a new branch 'dev'
bandit29@bandit:/tmp/tmp-repo-bandit29/repo$ cat README.md
# Bandit Notes
Some notes for bandit30 of bandit.

## credentials

- username: bandit30
- password: qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL
```

### Bandit Level 30 → Level 31
There is a git repository at ssh://bandit30-git@localhost/home/bandit30-git/repo via the port 2220. The password for the user bandit30-git is the same as for the user bandit30.

Clone the repository and find the password for the next level.

```bash
# First couple steps are the same as level29
bandit30@bandit:/tmp/tmp-bandit30/repo$ cat README.md
just an epmty file... muahaha

bandit30@bandit:/tmp/tmp-bandit30/repo$ git tag
secret
bandit30@bandit:/tmp/tmp-bandit30/repo$ git show secret
fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy
```

### Bandit Level 31 → Level 32
There is a git repository at ssh://bandit31-git@localhost/home/bandit31-git/repo via the port 2220. The password for the user bandit31-git is the same as for the user bandit31.

Clone the repository and find the password for the next level.

```bash
bandit31@bandit:~$ cd /tmp; mkdir tmp-bandit-31;cd tmp-bandit-31;
bandit31@bandit:/tmp/tmp-bandit-31$ cd repo;cat README.md
This time your task is to push a file to the remote repository.

Details:
    File name: key.txt
    Content: 'May I come in?'
    Branch: master

bandit31@bandit:/tmp/tmp-bandit-31/repo$ nano key.txt

bandit31@bandit:/tmp/tmp-bandit-31/repo$ git add key.txt
The following paths are ignored by one of your .gitignore files:
key.txt
hint: Use -f if you really want to add them.
hint: Turn this message off by running
hint: "git config advice.addIgnoredFile false"

bandit31@bandit:/tmp/tmp-bandit-31/repo$ nano .gitignore
Unable to create directory /home/bandit31/.local/share/nano/: No such file or directory
It is required for saving/loading search history or cursor positions.

bandit31@bandit:/tmp/tmp-bandit-31/repo$ git add key.txt
bandit31@bandit:/tmp/tmp-bandit-31/repo$ git commit -m "push file"
[master 9f9e7d2] push file
 1 file changed, 1 insertion(+)
 create mode 100644 key.txt
bandit31@bandit:/tmp/tmp-bandit-31/repo$ git push
...
remote: Well done! Here is the password for the next level:
remote: 3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K
...
```

### Bandit Level 32 → Level 33
After all this git stuff, it’s time for another escape. Good luck!

```bash
WELCOME TO THE UPPERCASE SHELL

$0

$ cd /etc/
$ cd bandit_pass
$ ls
bandit0   bandit13  bandit18  bandit22	bandit27  bandit31  bandit6
bandit1   bandit14  bandit19  bandit23	bandit28  bandit32  bandit7
bandit10  bandit15  bandit2   bandit24	bandit29  bandit33  bandit8
bandit11  bandit16  bandit20  bandit25	bandit3   bandit4   bandit9
bandit12  bandit17  bandit21  bandit26	bandit30  bandit5
$ cat bandit33
tQdtbs5D5i2vJwkO8mEyYEyTL8izoeJ0
```

### Bandit Level 33 → Level 34
At this moment, level 34 does not exist yet.


### All passwords
```bash
bandit0: bandit0

bandit1: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

bandit2: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx

bandit3: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

bandit4: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

bandit5: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

bandit6: HWasnPhtq9AVKe0dmk45nxy20cvUa6EG

bandit7: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

bandit8: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

bandit9: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

bandit10: FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey

bandit11: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr

bandit12: 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4

bandit13: FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn

bandit15: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo

bandit16: kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

bandit18: x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO

bandit19: cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8

bandit20: 0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO

bandit21: EeoULMCra2q0dSkYj561DX7s1CpBuOBt

bandit22: tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q

bandit23: 0Zf11ioIjMVN551jX3CmStKLYqjk54Ga

bandit24: gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8

bandit25: iCi86ttT4KSNe1armKiwbQNmB3YJP3q4

bandit26: s0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ

bandit27: upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB

bandit28: Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN

bandit29: 4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7

bandit30: qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL

bandit31: fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy

bandit32: 3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K

bandit33: tQdtbs5D5i2vJwkO8mEyYEyTL8izoeJ0
```