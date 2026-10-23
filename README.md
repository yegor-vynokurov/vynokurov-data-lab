# vynokurov-data-lab

docker build -t practice-postgres:1.0 . # build the container with tag -t and in the . current dir



docker run -d --name practice-postgres -e POSTGRES_PASSWORD= -p 5434:5432 practice-postgres:1.0 # run the container

docker exec -it practice-postgres psql -U student -d practice # interacitve mode


docker ps -a # all containers and stopped

docker stop practice-postgres # by name

docker rmi nginx # remove image without containers

docker rm -f web # stop and remove working container

docker run --rm hello-world .  # container will remove after stopping



docker compose up -d
docker compose down
docker compose down -v # del volume with data. must be careful



Раз в несколько недель или после активных экспериментов можешь запускать:
docker system df


Чтобы удалить ненужный кэш сборки:
docker builder prune


А для более широкой очистки:
docker system prune