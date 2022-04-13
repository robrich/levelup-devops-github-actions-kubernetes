# build "server" container
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine as build

WORKDIR /src

COPY LevelUpDevOps.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release
RUN dotnet test -c Release
RUN dotnet publish -c Release -o /dist


# production "server" container
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

ENV ASPNETCORE_ENVIRONMENT Production
ENV ASPNETCORE_URLS http://+:80
EXPOSE 80

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "LevelUpDevOps.dll"]
