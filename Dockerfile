# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy and restore dependencies
COPY ConsoleApp/*.csproj ./ConsoleApp/
COPY Tests/*.csproj ./Tests/
RUN dotnet restore ConsoleApp/ConsoleApp.csproj

# Copy the rest of the source code
COPY . .


# Publish the app
RUN dotnet publish ConsoleApp/ConsoleApp.csproj -c Release -o /publish --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime:9.0 AS runtime
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "ConsoleApp.dll"]

# Expose the port the application runs on
EXPOSE 80

