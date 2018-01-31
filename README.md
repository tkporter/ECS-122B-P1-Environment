# ECS 122B Program 1 Environment

This repo contains a `Dockerfile` that creates an Ubuntu container with the
specified environment (and follows all the testing steps as outlined in
`/p1/Project1EnvironmentSetup.pdf`). All of the p1 folder inside this repo
(which contains the the starting code and everything we were provided) is
copied inside the Ubuntu instance to `/home/ubuntu/workspace/p1`.

There's a lot to download and run, so it takes a while. Each step should be
cached by Docker, so when you run it again it should be really quick.

Keep in mind that any changes you make inside the Docker container will not
be saved unless you explicitly tell it to! Because of this I plan to write my
code in `/p1` on my own computer and just run it in the Docker container. If you
want to write code inside the container, you can either commit your changes via
Docker or start a container explicitly instead of using `docker run` like I show
in my example. [There are some good answers here that show how to do that.](https://stackoverflow.com/questions/19585028/i-lose-my-data-when-the-container-exits)

## How to run

Clone this repo
```
$ git clone https://github.com/tkporter/ECS-122B-P1-Environment
```

Build the docker image!
```
$ docker build . -t p1_image
```

Run the docker image!
```
$ docker run -it p1_image
```

Feel free to submit PRs or issues if something isn't working!
