#!/bin/bash

if [[ "$SHELL" =~ "zsh" ]]; then
    exit 0
fi

DIR=${DIR:-$(pwd)}
RCFILE="${HOME}/.bashrc"

if [ ! -d "${DIR}/dircolors-solarized" ]; then
    git clone --depth=1 https://github.com/yuweijun/bash-it.git "${DIR}/bash-it"
fi

ln -sfn ${DIR}/bash-it ${HOME}/.bash-it
cd ${HOME}/.bash-it
./install.sh --silent --no-modify-config
cp ${DIR}/bash-custom/template/bash_profile.template.bash ${RCFILE}
cd -

ln -sfn ${DIR}/bash-custom/themes ${DIR}/bash-it/custom/themes
ln -sfn ${DIR}/bash-custom/plugins ${DIR}/bash-it/custom/plugins
echo "###########################################" >> ${RCFILE}
