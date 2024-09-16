# Run dotnet restore in the current directory
dotnet restore

# Set the paths to your project files
$entryProject = ".\entry\entry.csproj"
$refL1Project = ".\ref-l1\ref-l1.csproj"
$refL2Project = ".\ref-l2\ref-l2.csproj"

# Build ref-l2.csproj without building its project references
dotnet build $refL2Project -p:BuildProjectReferences=false

# Build ref-l1.csproj without building its project references
dotnet build $refL1Project -p:BuildProjectReferences=false

# Build entry.csproj without building its project references and capture detailed output
$logFile = "build_entry.log"
dotnet build $entryProject -p:BuildProjectReferences=false -v:detailed > $logFile

# Read the build log
$logContent = Get-Content $logFile -Raw

# Construct the regex pattern to match the specific copy operation
$pattern = [regex]::Escape("Copying file from ") + ".*" + [regex]::Escape("ref-l2") + ".*" + [regex]::Escape("staticwebassets.build.endpoints.json") + ".*" + [regex]::Escape("to ") + ".*" + [regex]::Escape("entry") + ".*" + [regex]::Escape("ref-l2.staticwebassets.endpoints.json")

# Check if the specific copy operation occurred during the build
if ($logContent -match $pattern) {
    Write-Host "The file 'staticwebassets.build.endpoints.json' from 'ref-l2' was copied during the build of 'entry.csproj'."
} else {
    Write-Host "The file 'staticwebassets.build.endpoints.json' from 'ref-l2' was NOT copied during the build of 'entry.csproj'."
}
