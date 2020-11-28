# Spinner types
SPINNER_ARRAY[0]="|/-\\" 
SPINNER_ARRAY[1]="⠂-–—–-" 
SPINNER_ARRAY[2]="◐◓◑◒" 
SPINNER_ARRAY[3]="◴◷◶◵" 
SPINNER_ARRAY[4]="◰◳◲◱" 
SPINNER_ARRAY[5]="▖▘▝▗" 
SPINNER_ARRAY[6]="■□▪▫" 
SPINNER_ARRAY[7]="▌▀▐▄" 
SPINNER_ARRAY[8]="▉▊▋▌▍▎▏▎▍▌▋▊▉" 
SPINNER_ARRAY[9]="▁▃▄▅▆▇█▇▆▅▄▃" 
SPINNER_ARRAY[10]="←↖↑↗→↘↓↙" 
SPINNER_ARRAY[11]="┤┘┴└├┌┬┐" 
SPINNER_ARRAY[12]="◢◣◤◥" 
SPINNER_ARRAY[13]=".oO°Oo." 
SPINNER_ARRAY[14]=".oO@*" 
SPINNER_ARRAY[15]="◡◡ ⊙⊙ ◠◠" 
SPINNER_ARRAY[16]="☱☲☴" 
SPINNER_ARRAY[17]="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏" 
SPINNER_ARRAY[18]="⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓" 
SPINNER_ARRAY[19]="⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆" 
SPINNER_ARRAY[20]="⠋⠙⠚⠒⠂⠂⠒⠲⠴⠦⠖⠒⠐⠐⠒⠓⠋" 
SPINNER_ARRAY[21]="⠁⠉⠙⠚⠒⠂⠂⠒⠲⠴⠤⠄⠄⠤⠴⠲⠒⠂⠂⠒⠚⠙⠉⠁" 
SPINNER_ARRAY[22]="⠈⠉⠋⠓⠒⠐⠐⠒⠖⠦⠤⠠⠠⠤⠦⠖⠒⠐⠐⠒⠓⠋⠉⠈" 
SPINNER_ARRAY[23]="⠁⠁⠉⠙⠚⠒⠂⠂⠒⠲⠴⠤⠄⠄⠤⠠⠠⠤⠦⠖⠒⠐⠐⠒⠓⠋⠉⠈⠈" 
SPINNER_ARRAY[24]="⢄⢂⢁⡁⡈⡐⡠" 
SPINNER_ARRAY[25]="⢹⢺⢼⣸⣇⡧⡗⡏" 
SPINNER_ARRAY[26]="⣾⣽⣻⢿⡿⣟⣯⣷" 
SPINNER_ARRAY[27]="⠁⠂⠄⡀⢀⠠⠐⠈"

# show spinner whiles running
function _spinner()
{
  case $1 in
    start)
      # calculate the column where spinner and status msg will be displayed
      let column=$(tput cols)-${#2}-8
      
      # display message and position the cursor in $column column
      echo -ne ${2}
      printf "%${column}s"

      # get spinner str
      SaSize=${#SPINNER_ARRAY[@]}
      SaIndex=$(($RANDOM % $SaSize))

      # start spinner
      i=1
      sp=${SPINNER_ARRAY[$SaIndex]}
      delay=${SPINNER_DELAY:-0.15}

      while :
      do
        printf "\b${sp:i++%${#sp}:1}"
        sleep $delay
      done
      ;;
    stop)
      if [[ -z ${3} ]]; then
        echo "Spinner is not running..."
        exit 1
      fi

      kill $3 > /dev/null 2>&1

      ;;
    *)
      echo "Invalid argument, use {start/stop}"
      exit 1
      ;;
  esac
}

# bootup spinner
function start_spinner
{
  _spinner "start" "${1}" &
  _sp_pid=$!
  disown
}

# close spinner
function stop_spinner
{
  _spinner "stop" $1 $_sp_pid
  unset _sp_pid
}