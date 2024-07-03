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
    Open Browser                https://www.google.com  chrome  options=add_argument("--start-maximized")

Acessar Site do Forms
    Go To                       https://demoqa.com/automation-practice-form
    Sleep                       1s

Preencher Formulário
    Input Text                  ${input_name}           John
    Input Text                  ${input_lname}          Doe
    Input Text                  ${input_email}          john@gmail.com
    Click Element               ${label_gender}
    Input Text                  ${input_number}         1234567890
    Click Element               ${input_date}
    Espera e clica              ${select_month}
    Espera e clica              ${option_month}
    Espera e clica              ${select_year}
    Espera e clica              ${option_year}
    Click Element               ${div_day}
    Input Text                  ${input_subject}        English
    Press Keys                  ${input_subject}        ENTER
    Scroll Element Into View    ${button_submit}
    Espera e clica              ${label_hobbies}
    Input Text                  ${textarea_address}     123 Main St
    Click Element               ${input_state}
    Press Keys                  ${input_state}          ENTER
    Click Element               ${input_city}
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