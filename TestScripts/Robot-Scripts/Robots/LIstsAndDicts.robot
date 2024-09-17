*** Settings ***
Library     DateTime
Library     Collections

*** Variables ***
@{dates}

*** Keywords ***
Current Date/Hour
    FOR         ${i}       IN RANGE     5
        ${current_date}    Get Current Date    result_format=%d/%m/%Y %H:%M:%S
        Append To List     ${dates}      ${current_date}
        Sleep              1s
    END
    FOR    ${item}    IN    @{dates}
        Log    ${item}
    END

*** Tasks ***
Teste 1
    Current Date/Hour