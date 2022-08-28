FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["NPascuAPI/NPascuAPI/NPascuAPI.csproj", "NPascuAPI/NPascuAPI/"]
RUN dotnet restore "NPascuAPI\NPascuAPI\NPascuAPI.csproj"
COPY . .
WORKDIR "/src/NPascuAPI/NPascuAPI"
RUN dotnet build "NPascuAPI/NPascuAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NPascuAPI/NPascuAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet NPascuAPI.dll