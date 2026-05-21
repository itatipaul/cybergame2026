# JailPS – SafePS

Author - Senpai
Challenge: JailPS - Safeps
Category: Misc / PowerShell Jail
Points: 451
Goal: Bypass a "hardened" PowerShell environment to read the $FLAG variable.
1. Analysis

The challenge provides a .ps1 script that acts as a restricted shell. It uses a massive blacklist of cmdlets, aliases, and dangerous characters.

Key Restrictions:

    String Filtering: Blocks "flag", "get-variable", "gv", "ls", "dir", "gci", and even the flag prefix "sk".

    Character Filtering: Blocks $, ., _, {, }, [, ], and =.

    Length Limit: Input must be under 60 characters.

The Vulnerability:
The echo command logic allows for execution if the input isn't wrapped in quotes:
PowerShell

$sb = [ScriptBlock]::Create($exprTrimmed)
$result = & $sb

This means if we can pass a string that doesn't trigger the regex but evaluates to a command inside the ScriptBlock, we get full execution.
2. Exploitation Strategy

Standard variable access ($FLAG) and cmdlets (Get-Variable) were blocked by the literal string filter. However, the filter only checked the raw input before execution.

By using string concatenation and the Call Operator (&), we can reconstruct a forbidden command at runtime:

    Command Reconstruction: "g"+"v" evaluates to gv (the alias for Get-Variable).

    Wildcard Bypass: Using F* instead of FLAG avoids the "flag" and "sk" string filters.

    Execution: Wrapping the logic in parentheses ( ) ensures it evaluates as a single expression.

3. Final Payload
PowerShell

echo (&("g"+"v") "F*")

4. Flag

SK-CERT{1_l0v3_p0w45h3LLz_h0P3_u2}
