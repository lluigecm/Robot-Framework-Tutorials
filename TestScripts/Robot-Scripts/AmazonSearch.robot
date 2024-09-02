*** Settings ***
Library           RPA.Browser.Selenium
Library           OperatingSystem
Library           Collections
Library           RPA.Excel.Files
Library           ex_lib/Utils.py

*** Variables ***
${site}               https://www.amazon.com.br/
${arq_txt_path}       Arquivos-Teste/prod.txt
@{PRODS_INFO}
@{PRODS_PRICE}
@{PRODS_LINK}


*** Keywords ***
Verify if adds exists
    [Arguments]        ${element}
    ${bool} =          Does Page Contain Element    ${element}
    RETURN             ${bool}

Confirm if png already exists
    [Arguments]        ${img_path}
    ${exists} =        File Should Not Exist        ${img_path}
    RETURN             ${exists}

Get Info From Archive
    [Arguments]        ${arq_txt_path}
    ${content} =       Get File        ${arq_txt_path}
    Log                ${content}
    RETURN             ${content}

Avoid Captcha If Exists
    ${elemento_captcha}    Is Element Visible    //div[@class="a-row a-spacing-large"]
    Sleep                  1s
    IF    ${elemento_captcha} == ${True}
        ## Caso esteja presente, o robô espera o elemento da imagem carregar e faz o download

        Wait Until Element Is Visible    //div[@class="a-row a-text-center"]
        ${file_exists}         Confirm if png already exists    TestScripts\Robot-Scripts\captcha.png           # Não Finalizado devido ao captcha não aparecer
        IF    ${file_exists} == ${True}
            Remove File    TestScripts\Robot-Scripts\captcha.png
        END

        Capture Element Screenshot       //div[@class="a-row a-text-center"]    captcha.png
        TRY
            Move File    ./captcha.png    ./Robot-Scripts/captcha.png
        EXCEPT
            Pass Execution   O arquivo já foi movido
        END
        ${captcha_text} =                IMAGE TO TEXT                          ./Robot-Scripts/captcha.png

        Input Text                       //*[@id="captchacharacters"]    ${captcha_text}
        Sleep                            1s
        Click Button                     //button[@type="submit"]
    END
    
Open Browser Maximized
    Open Browser    ${site}    chrome    options=add_argument("--start-maximized")

Search Product
    ${prod} =                        Get Info From Archive                ${arq_txt_path}
    Wait Until Element Is Visible    //*[@id="twotabsearchtextbox"]
    Input Text                       //*[@id="twotabsearchtextbox"]       ${prod}
    Click Button                     //*[@id="nav-search-submit-button"]

Get Products Info
    Wait Until Element Is Visible          //div[@data-component-type="s-search-result"]
    ${qnt_prods} =    Get Element Count    //div[@data-component-type="s-search-result"]

    FOR    ${i}    IN RANGE    1    ${qnt_prods}+1
        ${prod_name} =             Get Text                     //div[@data-component-type="s-search-result"][${i}]//h2[@class="a-size-mini a-spacing-none a-color-base s-line-clamp-4"]
        TRY
            ${prod_price} =        Get Text                     //div[@data-component-type="s-search-result"][${i}]//span[@class="a-price"]//span[@aria-hidden="true"]
        EXCEPT
            ${prod_price} =        Evaluate                     "Preço não disponível"
        END
        ${prod_link} =         Get Element Attribute            //div[@data-component-type="s-search-result"][${i}]//h2[@class="a-size-mini a-spacing-none a-color-base s-line-clamp-4"]/a    href

        Append To List    ${PRODS_INFO}    ${prod_name}
        Append To List    ${PRODS_PRICE}   ${prod_price}
        Append To List    ${PRODS_LINK}    ${prod_link}
    END

Insert Data in Excel File
    Create Workbook    AmazonSearch.xlsx

    Set Cell Value    1    1    Info
    Set Cell Value    1    2    Preço
    Set Cell Value    1    3    Link

    ${qnt} =    Evaluate    len(${PRODS_INFO})
    FOR    ${i}    IN RANGE    1    ${qnt}+1
        ${empty_line} =    Find Empty Row

        Set Cell Value    ${empty_line}    1    ${PRODS_INFO}[${i-1}]
        Set Cell Value    ${empty_line}    2    ${PRODS_PRICE}[${i-1}]
        Set Cell Value    ${empty_line}    3    ${PRODS_LINK}[${i-1}]
    END

    Save Workbook    AmazonSearch.xlsx

Create Amazon Directory
    TRY
        Create Directory    AmazonResults
    EXCEPT
        Log    This path already exists and isn't a directory
    END

Move Excel File
    TRY
        Move File   AmazonSearch.xlsx    AmazonResults/AmazonSearch.xlsx
    EXCEPT
        Log    Error moving the file
    END


*** Test Cases ***
Test
    Open Browser Maximized
    Avoid Captcha If Exists
    Search Product
    Get Products Info
    Insert Data in Excel File
    Create Amazon Directory
    Move Excel File