*** Settings ***
Library     RPA.Excel.Files
Library     OperatingSystem
Library     Collections
Library     String

*** Variables ***
${EXCEL_FILE}    ${CURDIR}/Planilha.xlsx
${DATA_FILE}     ${CURDIR}/DadosPlanilha.txt

*** Keywords ***
Data Extraction
    ${data_txt}         Get File          ${DATA_FILE}
    ${data_lines_txt}   Split To Lines    ${data_txt}
    [Return]            ${data_lines_txt}

Insert Data In Excel
    [Arguments]         ${names}
    Open Workbook       ${EXCEL_FILE}
    FOR     ${i}    ${name}   IN ENUMERATE  @{names}
        ${i}                Evaluate        ${i} + 1
        Set Cell Value      ${i}       A    ${i}
        Set Cell Value      ${i}       B    ${name}
    END
    Save Workbook
    Close Workbook

*** Test Cases ***
Task 1
    ${name_list}            Data Extraction
    Insert Data In Excel    ${name_list}