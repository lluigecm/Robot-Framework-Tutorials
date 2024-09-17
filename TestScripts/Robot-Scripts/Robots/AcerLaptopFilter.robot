*** Settings ***
Library        SeleniumLibrary
Library        Collections
Library        RPA.FileSystem
Library        RPA.Excel.Files


*** Variables ***
${SITE}                    https://br-store.acer.com/
${LAPTOP_OPTION}           xpath://a[@href='/aspire']
${AD_PANEL}                //*[@id="ins-frameless-overlay"]
${CLOSE_AD}                //*[@id="close-button-1545222288830"]
${QNT_LAPTOPS}             11
@{LAPTOPS_INFO}
@{LAPTOPS_PRICES}
@{LAPTOPS_LINKS}


*** Keywords ***
Abrir Navegador
    Open Browser    ${SITE}    chrome    options=add_argument("--start-maximized")

Fechar Navegador
    Close Browser

Filtrar Notebooks
    Click Element                         ${LAPTOP_OPTION}
    Sleep                                 8s
    #Wait Until Element Is Visible         ${AD_PANEL}
    Click Element                         ${CLOSE_AD}
    Sleep                                 2s

Extrair Informações
    FOR    ${i}    IN RANGE    ${QNT_LAPTOPS}
        Scroll Element Into View             //*[@id="gallery-layout-container"]/div[${i+1}]/section/a/article/div[3]/div[1]/div/div[2]/div/h3/span
        ${LAP_INFOS}      Set Variable       //*[@id="gallery-layout-container"]/div[${i+1}]/section/a/article/div[3]/div[1]/div/div[2]/div/h3/span
        ${LAP_INFO}       Get Text           ${LAP_INFOS}
        Append To List    ${LAPTOPS_INFO}    ${LAP_INFO}
    END
    FOR  ${i}      IN RANGE    ${QNT_LAPTOPS}
        Scroll Element Into View             //*[@id="gallery-layout-container"]/div[${i+1}]/section/a/article/div[3]/div[1]/div/div[5]/span/span/span
        ${LAP_PRICES}     Set Variable       //*[@id="gallery-layout-container"]/div[${i+1}]/section/a/article/div[3]/div[1]/div/div[5]/span/span/span
        ${LAP_PRICE}      Get Text           ${LAP_PRICES}
        Append To List    ${LAPTOPS_PRICES}  ${LAP_PRICE}
    END
    FOR  ${i}      IN RANGE    ${QNT_LAPTOPS}
        Scroll Element Into View                     //*[@id="gallery-layout-container"]/div[${i+1}]/section/a
        ${LAP_LINKS}      Set Variable               //*[@id="gallery-layout-container"]/div[${i+1}]/section/a
        ${LAP_LINK}       Get Element Attribute      ${LAP_LINKS}    href
        Append To List    ${LAPTOPS_LINKS}           ${LAP_LINK}
    END


Inserir em Arquivo Excel
    Create Workbook  ${CURDIR}/AcerNotebooks.xlsx
    Set Cell Value   1    1    Infos
    Set Cell Value   1    2    Preço
    Set Cell Value   1    3    Links
    FOR    ${i}    IN RANGE    1    12
        Set Cell Value    ${i}    1    ${LAPTOPS_INFO}[${i-1}]
        Set Cell Value    ${i}    2    ${LAPTOPS_PRICES}[${i-1}]
        Set Cell Value    ${i}    3    ${LAPTOPS_LINKS}[${i-1}]
    END
    Save Workbook    ${CURDIR}/AcerNotebooks.xlsx

*** Tasks ***
Task 1
    Abrir Navegador
    Filtrar Notebooks
    Extrair Informações
    Inserir em Arquivo Excel