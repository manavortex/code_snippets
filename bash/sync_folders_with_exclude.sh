SOURCE=.
DESTINATION=user@host:/home/$whoami/target_dir

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while true
do
        rsync -avz --exclude-from $DIR/excludelist.txt $SOURCE $DESTINATION
done
