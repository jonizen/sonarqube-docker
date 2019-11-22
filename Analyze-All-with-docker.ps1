Param(
	[string] $projectRoot = ("c:\projects\labs"),
	[string[]] $exclude = ("")
)

$initpath = get-location


#Analyze all projects in ROOT 
#Put names of folder here
$projects = @(
	"SonarCloudDemo"
);

Foreach ($project in $projects) {
	$projectShortName = $project.split('\')[0];
	if ($exclude.Contains($projectShortName)) {
		Write-Host "Excluding project $projectShortName" -ForegroundColor Yellow
	}
	else {
		$build_path = "$projectRoot\$project"
		if (Test-Path $build_path) {
	  		Set-Location $build_path
		}
		else {
			Write-Host "Could not find the path to analyze the project!" -ForegroundColor Red
		}

		$git_version = (git describe --tags)
	  
		$solutionFile = (Get-ChildItem -Path $build_path\ -Filter *.sln -Recurse -File -Name).Where( { $_ -gt 1 }, 'First').Count -gt 0
		$packageJson = "$build_path\package.json"

		Write-Host "path is: $build_path"
	  
		if (!(Test-Path $packageJson) -and ($solutionFile)) {
			docker run -it --rm -v ""$build_path"":/source nosinovacao/dotnet-sonar:latest bash -c "cd source \
			&& dotnet /sonar-scanner/SonarScanner.MSBuild.dll begin /k:$project /v:$git_version /d:sonar.cs.opencover.reportsPaths=$build_path\coverage.opencover.xml /d:sonar.coverage.exclusions=**Tests*.cs \
			&& dotnet restore \
			&& dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=$build_path\coverage.opencover.xml \
			&& dotnet build -c Release \
			&& dotnet /sonar-scanner/SonarScanner.MSBuild.dll end"
		}
		else {
			yarn install
			yarn run sonar
		}
		  
		Write-Host "All specified services that was found has been built!" -ForegroundColor Green
		Set-Location $initpath
	}
}