# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine as build

WORKDIR /src

COPY LevelUpDevOps.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release LevelUpDevOps.csproj
RUN dotnet test -c Release LevelUpDevOps.csproj
RUN dotnet publish -c Release -o /dist LevelUpDevOps.csproj

# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENV ConnectionStrings__MyDB=""

WORKDIR /app

COPY --from=build /dist .

CMD ["dotnet", "LevelUpDevOps.dll"]
