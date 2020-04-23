<#
    .SYNOPSIS
    Powershell build script using CMake
    .DESCRIPTION
    Usage: ./build.ps1 [[-CMakePath <file_path>] [-Compiler [Clang|MSVC]] [-BuildType [Debug|Release]] [-SkipTests]]

        -CMakePath        Path to cmake.exe if it is not in environment $PATH variable
        -BuildType        Can be one of [Debug|Release], default=Release
        -Compiler         Can be one of [Clang|MSVC], default=Clang
        -SkipTests        Do not build tests

    .EXAMPLE
    .\build.ps1
    To build "Release" configuration and all tests with Clang compiler. Ninja used as CMake generator
    .EXAMPLE
    .\build.ps1 -BuildType Debug -SkipTests -Compiler MSVC
    To build "Debug" configuration and skip tests building using MSVC compiler
    .EXAMPLE
    .\build.ps1 -CMakePath C:\cmake-3.17.0\bin\cmake.exe -BuildType Debug
    To build "Debug" configuration and all tests using CMake 3.17.0
#>

Param(
  [String]$CMakePath,
  [ValidateSet("Debug", "Release")]
  [String]$BuildType = "Release",
  [ValidateSet("Clang", "MSVC")]
  [String]$Compiler = "Clang",
  [Switch]$SkipTests
)

# Stop script if any errors occur
$ErrorActionPreference = 'Stop'

# Setting CMake path
[String]$cmake = "cmake"
if ($CMakePath) {
  $cmake = $CMakePath
}

# Setting build directory
[String]$BuildDir = $PSScriptRoot + "\build\" + $BuildType
if (-not (Test-Path $BuildDir -PathType Container)) {
  New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
}
Set-Location $BuildDir

# Setting tests build
[String]$tests_path = ''
[String]$NoTests = "OFF"
if ($SkipTests -eq $true) {
  $NoTests = "ON"
}

# Set compiler and flags
# For clang compiler add clang.exe, clang++.exe and ninja.exe generator
# to PATH environment variable
[String]$generator_flag     = ''
[String]$generator_name     = ''
[String]$compiler_c         = ''
[String]$compiler_cxx       = ''
[String]$compiler_cxx_flags = ''

if ($Compiler -eq "Clang") {
  $generator_flag     = '-G'
  $generator_name     = 'Ninja'
  $compiler_c         = '-DCMAKE_C_COMPILER:STRING=clang'
  $compiler_cxx       = '-DCMAKE_CXX_COMPILER:STRING=clang++'
  $compiler_cxx_flags = '-DCMAKE_CXX_FLAGS="-m64 -Wall -Wextra -Werror -Wpedantic -pedantic-errors"'
  $tests_path         = $BuildDir + '\test\tests.exe'
} else {
  # Setting Visual Studio variables
  [String]$VSPath = $(& 'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe' `
                        -latest -property installationPath)
  & $VSPath'\VC\Auxiliary\Build\vcvarsall.bat' 'x64'
  $compiler_cxx_flags = '-DCMAKE_CXX_FLAGS="/EHsc /W4 /WX"'
  $tests_path = $BuildDir + '\test\' + $BuildType + '\tests.exe'
}

# Configure CMake and build
[String]$GeneratorFlag   = $generator_flag
[String]$GeneratorName   = $generator_name
[String]$C_Compiler      = $compiler_c
[String]$CXX_Compiler    = $compiler_cxx
[String]$CXX_Flags       = $compiler_cxx_flags
[String]$BuildTests      = '-DSKIP_TESTS=' + $NoTests
[String]$CMakeFilePath   = '../..'
[String]$Verbose         = '' #change to '--debug-output' if needed
[String[]]$arguments     = @($GeneratorFlag, $GeneratorName, `
                             $C_Compiler, $CXX_Compiler, $CXX_Flags, `
                             $BuildTests, $CMakeFilePath, $Verbose)
& $cmake @arguments

$arguments = @('--build', '.', '--config', $BuildType)
& $cmake @arguments

# Run tests
if ($SkipTests -ne $true) {
  if (-not $env:APPVEYOR_JOB_ID) {
    # local test run
    & $tests_path
  } else {
    # upload results to AppVeyor
    $arguments = @('--reporter', 'junit', '--out', 'testresults.xml')
    & $tests_path @arguments
    $wc = New-Object 'System.Net.WebClient'
    $wc.UploadFile("https://ci.appveyor.com/api/testresults/junit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path .\testresults.xml))
  }
}
