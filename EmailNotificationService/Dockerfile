FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["EmailNotificationService/EmailNotificationService.csproj", "EmailNotificationService/"]
RUN dotnet restore "EmailNotificationService/EmailNotificationService.csproj"
COPY . .

WORKDIR "/src/EmailNotificationService"
RUN dotnet build "EmailNotificationService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EmailNotificationService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "EmailNotificationService.dll"]