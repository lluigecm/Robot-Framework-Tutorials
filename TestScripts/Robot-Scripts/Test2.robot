*** Settings ***


*** Variables ***
${var1}     345
${opt}      abc
@{list}     12  56  376
&{dict}     simple=${var1}  list=@{list}

*** Keywords ***
Teste
    [Arguments]     ${arg_1}     ${arg_opt}=None     @{args}
    Log     Obrigatório: ${arg_1}
    IF      $arg_opt != None
        Log     Opcional: ${arg_opt}
    END
    FOR     ${each}     IN      @{args}
        Log     Others: ${each}
    END
    RETURN   Keyword concluded

*** Test Cases ***
Teste 1
    Teste    ${var1}     ${opt}     ${list}
