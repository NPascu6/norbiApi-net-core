FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /src
COPY ["NPascuAPI.csproj", ""]
RUN dotnet restore "./NPascuAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NPascuAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NPascuAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NPascuAPI.dll"]