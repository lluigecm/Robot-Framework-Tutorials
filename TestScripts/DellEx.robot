*** Settings ***
Library        SeleniumLibrary
Library        Collections
Library        RPA.FileSystem
Library        RPA.Excel.Files

*** Variables ***
${SITE}                https://www.dell.com/pt-br/shop/notebooks/sc/laptops
${LAPTOP_BUTTON}       xpath://li[@data-tier-id='2']
${FILTER_LIST}         //*[@id="unified-masthead-navigation"]/nav/ul/li[3]/ul/li[8]/button
${FILTER_BUTTON}       //*[@id="unified-masthead-navigation"]/nav/ul/li[3]/ul/li[8]/ul/li[7]/a
${FILTER_CAPTCHA}      //*[@id="refiner_37626"]/ol/li[5]/label/span
@{ID_LIST}             g5530w251116bts    g5530w251124bts    g5530w251122w    g5530w251120w   g5530w25001bts
...                    g5530u25001w       g5530u251122w      g5530u251124w    g5530w251122w1  g5530w251120w1
...                    g5530w25002w       g5530u25002w
@{NAMES_LIST}
@{PRICES_LIST}
@{SPECS_LIST}


*** Keywords ***
Abrir Navegador
    Open Browser    ${SITE}    chrome    options=add_argument("--start-maximized")

Filtrar Notebooks
    #Mouse Over                ${LAPTOP_BUTTON}
    #Mouse Over                ${FILTER_LIST}
    #Click Element             ${FILTER_BUTTON}
    Scroll Element Into View  ${FILTER_CAPTCHA}
    Click Element             ${FILTER_CAPTCHA}
    Sleep                     2s

Get Info   
    FOR    ${ID}    IN    @{ID_LIST}
        ${DATA_ELEMENT}    Set Variable    //*[@id='${ID}']/section[2]/div[1]/h3
        ${NAME}            Get Text        ${DATA_ELEMENT}
        Append To List     ${NAMES_LIST}   ${NAME}
    END
    FOR    ${ID}    IN    @{ID_LIST}
        ${DATA_ELEMENT}    Set Variable    //*[@id='${ID}']/section[2]/div[3]
        ${SPECS}           Get Text        ${DATA_ELEMENT}
        Append To List     ${SPECS_LIST}   ${SPECS}
    END
    FOR    ${ID}    IN    @{ID_LIST}
        ${DATA_ELEMENT}    Set Variable    //*[@id='${ID}']/section[3]/div[1]/div[3]/span[2]
        ${PRICE}           Get Text        ${DATA_ELEMENT}
        Append To List     ${PRICES_LIST}  ${PRICE}
    END

Insert in Excel File
    Create Workbook  ${CURDIR}/DellNotebooks.xlsx
    Set Cell Value   1    1    Nome
    Set Cell Value   1    2    Preço
    Set Cell Value   1    3    Especificações
    FOR    ${i}    IN RANGE    1    13
        Set Cell Value    ${i}    1    ${NAMES_LIST}[${i-1}]
        Set Cell Value    ${i}    2    ${PRICES_LIST}[${i-1}]
        Set Cell Value    ${i}    3    ${SPECS_LIST}[${i-1}]
    END
    Save Workbook    ${CURDIR}/DellNotebooks.xlsx
    
*** Tasks ***
Abrir Site Dell
    Abrir Navegador
    Filtrar Notebooks
    
Coletar Dados
    Get info
    Insert in Excel File