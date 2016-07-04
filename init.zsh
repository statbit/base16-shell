#
# Colors
#

BASE16_DIR=~/.zprezto/modules/base16-shell/scripts
BASE16_CONFIG=~/.vim/.base16

color() {
  BACKGROUND="$1"
  SCHEME="$2"

  if [ $# -eq 0 -a -s "$BASE16_CONFIG" ]; then
    cat ~/.vim/.base16
    return
  fi

  if [[ "$SCHEME" = 'help' ]]; then
    BACKGROUND='help'
  fi

  case "$BACKGROUND" in
  dark|light)
    FILE="$BASE16_DIR/base16-$SCHEME-$BACKGROUND.sh"
    if [[ -x "$FILE" ]]; then
      echo "$SCHEME" >! "$BASE16_CONFIG"
      echo "$BACKGROUND" >> "$BASE16_CONFIG"
      "$FILE"
    else
      color $SCHEME
    fi
    ;;
  help)
    echo 'color dark [tomorrow|ocean|grayscale|ashes|default|railscasts|twilight|...]'
    echo 'color light [grayscale|harmonic16|ocean|tomorrow|twilight|...]'
    echo
    echo 'Available schemes:'
    find $BASE16_DIR -name 'base16-*.sh' | \
      sed -E 's|.+/base16-||' | \
      sed -E 's/\.(dark|light)\.sh/ (\1)/' | \
      column
      ;;

  *)
    SCHEME=$BACKGROUND
    FILE="$BASE16_DIR/base16-$SCHEME.sh"
    if [[ -x "$FILE" ]]; then
      echo "$SCHEME" >! "$BASE16_CONFIG"
      echo "dark" >> "$BASE16_CONFIG"
      "$FILE"
    else
      echo "Scheme '$SCHEME' not found in $BASE16_DIR (looking for file $FILE)"
      return 1
    fi
  esac

}

dark() {
  color dark "$1"
}

light() {
  color light "$1"
}

if [[ -s "$BASE16_CONFIG" ]]; then
  SCHEME=$(head -1 "$BASE16_CONFIG")
  BACKGROUND=$(sed -n -e '2 p' "$BASE16_CONFIG")
  color $SCHEME $BACKGROUND
else
  # Default.
  dark tomorrow
fi
