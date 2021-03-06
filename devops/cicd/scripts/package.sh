#!/bin/sh
echo "***************************************"
echo "***         PACKAGING BUILDER       ***"
echo "***            1. version           ***"
echo "***            2. create image      ***"
echo "***            3. push image        ***"
echo "***************************************"

appname=$APP_NAME

echo "**** $appname ****"

#
# for NPM Builds
#
version=$(cat package.json \
 | grep version \
 | head -1 \
 | awk -F: '{ print $2 }' \
 | sed 's/[",]//g' \
 | tr -d '[[:space:]]')


v1="$(echo $version|awk -F'.' '{print $1}')"
v2="$(echo $version|awk -F'.' '{print $2}')"
v3="$(echo $version|awk -F'.' '{print $3}')"

#v1="$(echo $v1|awk '{print substr($0,2)}')"
#v3="$(echo $v3|awk -F'-' '{print $1}')"

branch=$DEPLOY_TO_SERVER
if [ "$branch" = "" ]; then
  branch="dev"
fi;

#
# Create Docker Image
#
cp docker-compose.yml ./docker-compose-tmp.yml
sed -i 's/{version}/'"$branch"'/' ./docker-compose-tmp.yml

cat ./docker-compose-tmp.yml

echo "*************************************** $APP_BUILD_SERVICE_NAME"

docker-compose --file ./docker-compose-tmp.yml build $APP_BUILD_SERVICE_NAME
 
rm ./docker-compose-tmp.yml

imageId="$(docker images|grep $appname|head -1|awk '{print $3}')"

docker tag $imageId $DOCKER_REPO/$appname:$version
docker tag $imageId $DOCKER_REPO/$appname:$branch



#
# Push Image to Registry
#
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
#docker rmi  $DOCKER_REPO/$appname
docker push $DOCKER_REPO/$appname:latest

#docker push $DOCKER_REPO/$appname:$version
#docker rmi  $DOCKER_REPO/$appname:$branch
docker push $DOCKER_REPO/$appname:$branch

#if [ "$branch" = "stage" ]; then
  echo "Pushing Versioned Tags [$v1, $v2, $v3]"

  docker tag $imageId  $DOCKER_REPO/$appname:$v1
  docker tag $imageId  $DOCKER_REPO/$appname:$v1.$v2
  docker tag $imageId  $DOCKER_REPO/$appname:$v1.$v2.$v3

  #docker rmi   $DOCKER_REPO/$appname:$v1
  #docker rmi   $DOCKER_REPO/$appname:$v1.$v2
  #docker rmi   $DOCKER_REPO/$appname:$v1.$v2.$v3

  docker push   $DOCKER_REPO/$appname:$v1
  docker push   $DOCKER_REPO/$appname:$v1.$v2
  docker push   $DOCKER_REPO/$appname:$v1.$v2.$v3
#fi;

echo "Docker Images on Build Server"
docker images|grep $appname
