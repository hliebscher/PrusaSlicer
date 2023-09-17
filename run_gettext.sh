#!/bin/sh

#  PrusaSlicer gettext
#  Created by SoftFever on 27/5/23.
#

# Check for --full argument
FULL_MODE=false
for arg in "$@"
do
    if [ "$arg" == "--full" ]; then
        FULL_MODE=true
    fi
done

if $FULL_MODE; then
    xgettext --keyword=L --keyword=_L --keyword=_u8L --keyword=L_CONTEXT:1,2c --keyword=_L_PLURAL:1,2 --add-comments=TRN --from-code=UTF-8 --no-location --debug --boost -f ./resources/localization/list.txt -o ./resources/localization/PrusaSlicer.pot
    ./build_arm64/src/hints/Release/hintsToPot.app/Contents/MacOS/hintsToPot ./resources ./resources/localization
fi


echo $PWD
pot_file="./resources/localization/PrusaSlicer.pot"
for dir in ./resources/localization/*/
do
    dir=${dir%*/}      # remove the trailing "/"
    lang=${dir##*/}    # extract the language identifier

    if [ -f "$dir/PrusaSlicer_${lang}.po" ]; then
        if $FULL_MODE; then
            msgmerge -N -o $dir/PrusaSlicer_${lang}.po $dir/PrusaSlicer_${lang}.po $pot_file
         fi
        mkdir -p ./resources/localization/${lang}/
        msgfmt --check-format -o ./resources/localization/${lang}/PrusaSlicer.mo $dir/PrusaSlicer_${lang}.po
    fi
done
