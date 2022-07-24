FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
RUN apt update
RUN apt install -y postgresql-client git openssh-client rsync
ADD ./id_rsa_intrivo /root/.ssh/id_rsa
ADD ./known_hosts /root/.ssh/known_hosts
WORKDIR /root
RUN git clone git@bitbucket.org:intrivo/routinesengine-poc.git
WORKDIR /root/routinesengine-poc/consumer
RUN dotnet publish -c Release

FROM mcr.microsoft.com/dotnet/runtime:5.0
RUN apt update
RUN apt install -y postgresql-client
COPY --from=build /root/routinesengine-poc/consumer/bin/Release/net5.0/publish /app
COPY ./appsettings.json /app/
WORKDIR /app
CMD ["dotnet","Consumer.dll"]

