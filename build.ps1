<#
    .SYNOPSIS
    Powershell build script using CMake
    .DESCRIPTION
    Usage: ./build.sp1 [[-CMakePath <file_path>] [[-BuildType [Debug|Release]] [-SkipTests]]

        -CMakePath        Path to cmake.exe if it is not in your system/user $PATH variable
        -BuildType        Can be one of [Debug|Release], default=Release
        -SkipTests        Do not build tests
    .EXAMPLE
    .\build.ps1
    To build "Release" configuration and all tests
    .EXAMPLE
    .\build.ps1 -BuildType Debug -SkipTests
    To build "Debug" configuration and skip tests building
    .EXAMPLE
    .\build.ps1 -CMakePath C:\cmake-3.17.0\bin\cmake.exe -BuildType Debug
    To build "Debug" configuration and all tests using CMake 3.17.0
#>

Param(
  [String]$CMakePath,
  [ValidateSet("Debug", "Release")]
  [String]$BuildType = "Release",
  [Switch]$SkipTests
)

# Setting CMake path
[String]$cmake = "cmake"
if ($CMakePath) {
  if (!(Test-Path $CMakePath -PathType Leaf -Include "cmake.exe")) {
    Write-Output "No cmake.exe found in -CMakePath parameter."
    Exit 1
  } else {
    $cmake = $CMakePath
  }
}

# Setting build directory
[String]$BuildDir = $PSScriptRoot + "\build\" + $BuildType
if (!(Test-Path $BuildDir -PathType Container)) {
  New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
}
Set-Location $BuildDir

# Setting tests build
[String]$NoTests = "OFF"
if ($SkipTests -eq $true) {
  $NoTests = "ON"
}

# Setting Visual Studio variables
[String]$VSPath = $(& 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe' `
                      -latest -property installationPath)
& $VSPath'\VC\Auxiliary\Build\vcvarsall.bat' 'x64'

# Setting CMake build variables
[String]$BuildConfig     = '-DCMAKE_BUILD_TYPE=' + $BuildType
[String]$BuildTests      = '-DSKIP_TESTS=' + $NoTests
[String]$CMakeFilePath   = '..\..'

# Configure CMake and build
[String[]]$arguments = @($BuildConfig, $BuildTests, $CMakeFilePath)
& $cmake @arguments

$arguments = @('--build', '.')
& $cmake @arguments

# Run tests
if ($SkipTests -ne $true) {
  & $BuildDir'\test\Debug\tests.exe'
}