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
        $NormalisedOptions.Add($opt.Replace("-", "/"))
    }

    # SUFFIX OUTFILE IS MISSING
    if ( $OutputFile -and !$OutputFile.ToLower().Contains(".obj") -and !$OutputFile.ToLower().Contains(".exe") ) {

        if ($NormalisedOptions.Contains("/c")) {
            $OutputFile = "/Fo:" + $OutputFile + ".obj"
        } else {
            $OutputFile = "/Fe:" + $OutputFile + ".exe"
        }
    }

    & "$Compiler" $InputFiles $OutputFile $Options
}
set-alias -Name compile -Value Invoke-Compiler
