# build "server" image
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine as build

WORKDIR /src

COPY demo.sln .
COPY LevelUpDevOps.csproj .
RUN dotnet restore demo.sln

COPY . .
RUN dotnet build -c Release demo.sln
RUN dotnet test -c Release demo.sln
RUN dotnet publish -c Release -o /dist demo.sln


# production runtime "server" image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine

ENV ASPNETCORE_URLS http://+:8080
ENV ASPNETCORE_ENVIRONMENT Production
EXPOSE 8080
ENV ConnectionStrings__MyDB ""

WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "LevelUpDevOps.dll"]
