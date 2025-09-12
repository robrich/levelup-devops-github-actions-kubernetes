# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src

COPY LevelUpDevOps.slnx .
COPY LevelUpDevOps.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release
RUN dotnet test -c Release --no-build
RUN dotnet publish -c Release -o /dist --no-build LevelUpDevOps.csproj

# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ConnectionStrings__MyDB=

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "LevelUpDevOps.dll"]
