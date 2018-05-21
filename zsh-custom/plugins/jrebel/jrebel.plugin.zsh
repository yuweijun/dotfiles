if [ -e $HOME/.jrebel ]; then
    alias jrebel="MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so' mvn"
    alias jdebug="MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' mvn"
fi
