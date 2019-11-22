SonarQube With docker and postgres


1. Install runner with core - run this: dotnet tool install --global dotnet-sonarscanner --version 4.X.X take latest
2. Start docker and login with admin
3. Go to security and create a token for analysis job.
4. Copy the token and replace it in the sonar-scanner.properties file.
5. put sonar-scanner.properties in C:\Users\username\.dotnet\tools\.store\dotnet-sonarscanner\{version}\dotnet-sonarscanner\{version}\tools\netcoreapp2.1\any\sonar-scanner-x.x.x.x.x\conf folder
6. Update the Analyze-All.ps1 with path to project folder and projects you want to build
7. Run Analyze-All.ps1 

ref: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-msbuild/