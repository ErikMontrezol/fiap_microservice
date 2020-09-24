# .NET Core SDK
FROM microsoft/dotnet:2.2-sdk AS dotnetcore-sdk

WORKDIR /src

# Copy Projects
COPY Bank.Api/Bank.Api.csproj ./Bank.Api/

# .NET Core Restore
RUN dotnet restore ./Bank.Api/Bank.Api.csproj  -s http://nuget.Bank.net.br/nuget -s https://api.nuget.org/v3/index.json

# Copy All Files
COPY Bank.Api ./Bank.Api/

# .NET Core Build and Publish
FROM dotnetcore-sdk AS dotnetcore-build
RUN dotnet publish ./Bank.Api/Bank.Api.csproj -c Release -o /publish

# ASP.NET Core Runtime
FROM microsoft/dotnet:2.2-aspnetcore-runtime AS aspnetcore-runtime
ARG ASPNETCORE_ENVIRONMENT
ENV ASPNETCORE_ENVIRONMENT=$ASPNETCORE_ENVIRONMENT
WORKDIR /app
COPY --from=dotnetcore-build /publish .
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "Bank.Api.dll"]
