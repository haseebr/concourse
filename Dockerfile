# NOTE: this Dockerfile is purely for local development! it is *not* used for
# the official 'concourse/concourse' image.

FROM concourse/dev

# generate one-off keys for development
RUN mkdir /concourse-keys
RUN ssh-keygen -t rsa -N '' -f /concourse-keys/tsa_host_key
RUN ssh-keygen -t rsa -N '' -f /concourse-keys/session_signing_key
RUN ssh-keygen -t rsa -N '' -f /concourse-keys/worker_key
RUN cp /concourse-keys/worker_key.pub /concourse-keys/authorized_worker_keys

# keys for 'web'
ENV CONCOURSE_TSA_HOST_KEY        /concourse-keys/tsa_host_key
ENV CONCOURSE_TSA_AUTHORIZED_KEYS /concourse-keys/authorized_worker_keys
ENV CONCOURSE_SESSION_SIGNING_KEY /concourse-keys/session_signing_key


# keys for 'worker'
ENV CONCOURSE_TSA_PUBLIC_KEY         /concourse-keys/tsa_host_key.pub
ENV CONCOURSE_TSA_WORKER_PRIVATE_KEY /concourse-keys/worker_key

# build Concourse
COPY . /src
WORKDIR /src
RUN ls -l
RUN go build -o /usr/local/bin/concourse github.com/concourse/concourse/bin/cmd/concourse

# override /src with a volume so we get live-updated packr stuff
VOLUME /src
