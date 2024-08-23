*** Settings ***
Library     RPA.PDF
Library     Collections
Library     String

*** Variables ***
${PDF_PATH}      ${CURDIR}/PDFTESTE.pdf
${key_word}       Lorem

*** Keywords ***
Get PDF Text
    ${qnt}          Set Variable        0
    Open Pdf        ${PDF_PATH}
    ${pdf_dict}     Get Text From Pdf
    Close Pdf
    ${conteudo}     Get Dictionary Values    ${pdf_dict}
    FOR    ${pag}    IN    @{conteudo}
        Log    ${pag}
        @{check_key_word}   Get Regexp Matches    ${pag}    ${key_word}
        ${qnt}              Evaluate              ${qnt} + len(@{check_key_word})
        IF  @{check_key_word} != @{EMPTY}
            Pass Execution    PDF aproved
        END
    END

*** Test Cases ***
Teste 1
    Get PDF Text