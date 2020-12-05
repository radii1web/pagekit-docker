if [ "$1" = "" ]; then
    echo "you need to create a github token with access to radii1web/pagekit to run this build see https://github.com/settings/tokens/new"
    exit -1
fi

docker build --build-arg "GITHUB_TOKEN=$1" -t radii1web/pagekit .