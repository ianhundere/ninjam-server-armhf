FROM ubuntu:latest as builder

ENV PATH /usr/local/ninjam:$PATH
WORKDIR /opt
RUN apt-get update && apt-get install -y git-core build-essential
RUN git clone https://github.com/justinfrankel/ninjam

WORKDIR /opt/ninjam/ninjam/server
RUN make
RUN mkdir -p /usr/local/ninjam
RUN mv ninjamsrv /usr/local/ninjam
RUN mv example.cfg /usr/local/ninjam/config.cfg
RUN mv cclicense.txt /usr/local/ninjam/cclicense.txt

# forward request and error logs to docker log collector
#RUN ln -sf /dev/stdout ./ninjamserver.log

FROM ubuntu:latest

COPY --from=builder /usr/local/ninjam /usr/local/ninjam

EXPOSE 2049
ENTRYPOINT ["ninjamsrv", "config.cfg"]