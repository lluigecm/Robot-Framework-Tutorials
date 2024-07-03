*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${input_name}           id:firstName
${input_lname}          id:lastName
${input_email}          id:userEmail
${label_gender}         xpath=//label[@for='gender-radio-1']
${input_number}         id:userNumber
${input_date}           id:dateOfBirthInput
${select_month}         xpath=//select[@class='react-datepicker__month-select']
${option_month}         xpath=//option[@value='2']
${select_year}          xpath=//select[@class='react-datepicker__year-select']
${option_year}          xpath=//option[@value='2003']
${div_day}              xpath=//div[@class='react-datepicker__day react-datepicker__day--001 react-datepicker__day--weekend']
${input_subject}        id:subjectsInput
${label_hobbies}        xpath=//label[@for='hobbies-checkbox-1']
${textarea_address}     id:currentAddress
${input_state}          xpath=//div[@class=' css-1hwfws3']
${input_city}           xpath=//div[@class=' css-1wa3eu0-placeholder']
${button_submit}        id:submit

*** Keywords ***
Espera e clica
    [Arguments]                      ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element                    ${locator}

Abrir Navegador
    Open Browser                https://www.google.com  chrome
    Maximize Browser Window

Acessar Site do Forms
    Go To                       https://demoqa.com/automation-practice-form
    Sleep                       1s

Preencher Formulário
    Input Text                  ${input_name}           John
    Sleep                       1s
    Input Text                  ${input_lname}          Doe
    Sleep                       1s
    Input Text                  ${input_email}          john@gmail.com
    Sleep                       1s
    Click Element               ${label_gender}
    Sleep                       1s
    Input Text                  ${input_number}         1234567890
    Sleep                       1s
    Click Element               ${input_date}
    Sleep                       1s
    Espera e clica              ${select_month}
    Sleep                       1s
    Espera e clica              ${option_month}
    Sleep                       1s
    Espera e clica              ${select_year}
    Sleep                       1s
    Espera e clica              ${option_year}
    Click Element               ${div_day}
    Sleep                       2s
    Input Text                  ${input_subject}        English
    Sleep                       1s
    Press Keys                  ${input_subject}        ENTER
    Sleep                       1s
    Scroll Element Into View    ${button_submit}
    Espera e clica              ${label_hobbies}
    Sleep                       1s
    Input Text                  ${textarea_address}     123 Main St
    Sleep                       1s
    Sleep                       1s
    Click Element               ${input_state}
    Sleep                       1s
    Press Keys                  ${input_state}          ENTER
    Sleep                       1s
    Click Element               ${input_city}
    Sleep                       1s
    Press Keys                  ${input_city}           ENTER
    Click Element               ${button_submit}

Fechar Navegador
    Close Browser


*** Test Cases ***
Cenário 1: Abrir Navegador e Preencher Formulário
    Abrir Navegador
    Acessar Site do Forms
    Preencher Formulário
    Fechar Navegador