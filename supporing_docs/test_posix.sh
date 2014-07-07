#!/bin/sh

# list of utilities Mac OS X says are built-in
posix_builtins="alias bg break cd command continue echo eval exec exit export false fc fg getopts hash jobs kill printf pwd read readonly return set shift test times trap true type ulimit umask unalias unset wait"

# from Wikipedia
posix_sccs="delta get prs rmdel sact sccs unget val what"
posix_batch="qalter qdel qhold qmove qmsg qrerun qrls qselect qsig qstat qsub"
posix_cprog="c99 cflow ctags cxref lex nm strings strip yacc"
posix_fortr77prog="fort77"
posix_filesystem="basename cat cd chgrp chmod chown cksum cmp compress cp dd df dirname du file find link ln ls mkdir mkfifo mv pathchk pwd rm rmdir touch unlink"
posix_network="uucp uudecode uuencode uustat"
posix_process="at batch bg fg fuser jobs kill nice nohup ps renice time uux wait"
posix_programming="make"
posix_shell="command echo expr false getopts logger printf read sh sleep tee test true xargs"
posix_sysadmin="who"
posix_textprocessing="asa awk comm csplit cut diff ed ex expand fold head iconv join lp more nl paste patch pr sed sort tail tr tsort unexpand uniq vi wc zcat" 
posix_misc="alias ar bc cal crontab date env fc gencat getconf grep hash id ipcrm ipcs locale localedef logname m4 mailx man mesg newgrp od pax split stty tabs talk tput tty type ulimit umask unalias uname uncompress write"

# omitted from Wikiepedia
posix_omitted="break colon continue dot eval exec exit export readonly return set shift times trap true unset"

# list of utilitlies found on X/Open site
# http://pubs.opengroup.org/onlinepubs/009695399/idx/utilities.html
posix_utils="admin alias ar asa at awk basename batch bc bg break c99 cal cat cd cflow chgrp chmod chown cksum cmp colon comm command compress continue cp crontab csplit ctags cut cxref date dd delta df diff dirname dot du echo ed env eval ex exec exit expand export expr false fc fg file find fold fort77 fuser gencat get getconf getopts grep hash head iconv id ipcrm ipcs jobs join kill lex link ln locale localedef logger logname lp ls m4 mailx make man mesg mkdir mkfifo more mv newgrp nice nl nm nohup od paste patch pathchk pax pr printf prs ps pwd qalter qdel qhold qmove qmsg qrerun qrls qselect qsig qstat qsub read readonly renice return rm rmdel rmdir sact sccs sed set sh shift sleep sort split strings strip stty tabs tail talk tee test time times touch tput tr trap true tsort tty type ulimit umask unalias uname uncompress unexpand unget uniq unlink unset uucp uudecode uuencode uustat uux val vi wait wc what who write xargs yacc zcat"

no_util=""

for util in $posix_utils; do
  type $util &> /dev/null
  if [ $? -gt 0 ]; then
    no_util="$no_util $util"
  fi
done

echo "POSIX Utilities not on this system:$no_util"
