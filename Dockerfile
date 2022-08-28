FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore "NPascuAPI.csproj"
COPY . .
WORKDIR "/src/NPascuAPI/NPascuAPI"
RUN dotnet build "NPascuAPI.csproj" -c Release -o out

FROM build AS publish
RUN dotnet publish "NPascuAPI.csproj" -c Release -o out

FROM base AS final
WORKDIR /app
COPY --from=build-env /app/out .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet NPascuAPI.dll