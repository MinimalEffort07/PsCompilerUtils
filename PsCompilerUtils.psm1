$Compilers = "clang-cl.exe", "cl.exe"

function Invoke-Compiler {

    param(
        [Parameter(Mandatory=$False)]
        [String]$Compiler,
        [Parameter(Mandatory=$True, HelpMessage="Input files to compile")]
        [String[]]$InputFiles,
        [Parameter(Mandatory=$False, HelpMessage="Options to pass to compiler")]
        [String[]]$Options,
        [Parameter(Mandatory=$False, HelpMessage="Output file")]
        [String]$OutputFile,
        [Switch]$OverwriteJson,
        [Switch]$Help,
        [Switch]$H
    )

    if ($Help -or $H) {
        Write-Output "Hello from help"
        return
    }

    # FIND A COMPILER
    if (!$Compiler) {
        Write-Output "No compiler provided, finding one"
        foreach ($c in $Compilers) {
            $Compiler = where.exe $c
            if ($Compiler) {
                break;
            }
        }
        if (!$Compiler) {
            Write-Error "Failed to find a compiler"
            return
        }
    } else {
        # FULL PATH WASN'T PROVIDED SO WE FIND IT
        if (!$Compiler.Contains(":")) {
            $Compiler = where.exe $Compiler
        }
    }
    Write-Output "Using compiler: $Compiler"

    # NORMALISE OPTION PREFIXES
    $NormalisedOptions = @()
    foreach($opt in $Options) {
        $NormalisedOptions += $opt.Replace("-", "/")
    }

    $CurrentDirectory = (Get-Location).Path

    $PsEntries = @()

    $InputFiles | ForEach-Object {
        $PsEntries += @{
            'directory' = "$CurrentDirectory"
            'file' = Join-Path "$CurrentDirectory" "$_"
            'output' = (Join-Path "$CurrentDirectory" "$_".Split(".")[0])+".obj"
            'command' = "$Compiler $InputFiles $OutputFilePrefix$OutputFile $Options"
        }
    }

    $PsEntries | ConvertTo-Json | out-file ".\compile_commands.json"

    # SUFFIX OUTFILE IS MISSING
    $OutputFilePrefix = $null
    if ( $OutputFile -and !$OutputFile.ToLower().Contains(".obj") -and !$OutputFile.ToLower().Contains(".exe") ) {

        if ($NormalisedOptions.Contains("/c")) {
            $OutputFilePrefix = "/Fo:"
            $OutputFile = $OutputFile + ".obj"
        } else {
            $OutputFilePrefix = "/Fe:"
            $OutputFile = $OutputFile + ".exe"
        }
    }

    & "$Compiler" $InputFiles $OutputFilePrefix$OutputFile $Options
}
set-alias -Name compile -Value Invoke-Compiler
