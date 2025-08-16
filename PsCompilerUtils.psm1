$Compilers = "clang++.exe", "clang-cl.exe", "cl.exe"

function Invoke-Compiler {

    param(
        [Parameter(Mandatory=$False)]
        [String]$Compiler,
        [Parameter(Mandatory=$True, ParameterSetName="in", HelpMessage="Input files to compile")]
        [String[]]$InputFiles,
        [Parameter(Mandatory=$False, ParameterSetName="options", HelpMessage="Options to pass to compiler")]
        [String[]]$Options,
        [Switch]$Help,
        [Switch]$H 
    )

    if ($Help || $H) {
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

}
set-alias -Name compile -Value Invoke-Compiler
