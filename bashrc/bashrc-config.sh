#SRC_DIR=`dirname $0`
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for script in $SRC_DIR/bashrc.d/*.sh ;
 do
  #echo $script; 
  if [[ -x "$script" ]]; then
        source "$script";
   fi
 done
