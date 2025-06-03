# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src

COPY demo.slnx .
COPY LevelUpDevOps.csproj .
RUN dotnet restore demo.slnx
COPY . .
RUN dotnet build demo.slnx -c Release
RUN dotnet test demo.slnx -c Release --no-build
RUN dotnet publish LevelUpDevOps.csproj -c Release -o /dist

# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENV ASPNETCORE_ENVIRONMENT=Production

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "LevelUpDevOps.dll"]
