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
    
Open Browser and Search
    Open Browser    ${site}    chrome    options=add_argument("--start-maximized")

    ${elemento_captcha}    Is Element Visible    //div[@class="a-row a-spacing-large"]
    IF    ${elemento_captcha} == ${True}
        ## Caso esteja presente, o robô espera o elemento da imagem carregar e faz o download
        
        Wait Until Element Is Visible    //div[@class="a-row a-text-center"]
        ${file_exists}         Confirm if png already exists    TestScripts\Robot-Scripts\captcha.png
        IF    ${file_exists} == ${True}
            Remove File    TestScripts\Robot-Scripts\captcha.png
        END

        Capture Element Screenshot       //div[@class="a-row a-text-center"]    captcha.png
        ${captcha_text} =                IMAGE TO TEXT                          captcha.png
        Log                              ${captcha_text}
    END
    
    ${prod} =        Get Info From Archive                ${arq_txt_path}
    Input Text       //*[@id="twotabsearchtextbox"]       ${prod}
    Click Button     //*[@id="nav-search-submit-button"]

Get Products Info
    ${qnt_prods} =    Get Element Count    //div[@data-component-type="s-search-result"]

    FOR    ${i}    IN RANGE    1    ${qnt_prods}+1
        ${prod_name} =         Get Text                         //div[@data-component-type="s-search-result"][${i}]//h2[@class="a-size-mini a-spacing-none a-color-base s-line-clamp-4"]
        ${prod_price} =        Get Text                         //div[@data-component-type="s-search-result"][${i}]/div/div/div/div/span/div/div/div[2]/div[4]/div/div/a/span/span
        ${prod_prices} =       REMOVE CHARS    ${prod_price}    &nbsp
        ${prod_link} =         Get Element Attribute            //div[@data-component-type="s-search-result"][${i}]/div/div/div/div/span/div/div/div[2]/div[4]/div/div/a    href

        Append To List    ${PRODS_INFO}    ${prod_name}
        Append To List    ${PRODS_PRICE}    ${prod_prices}
        Append To List    ${PRODS_LINK}    ${prod_link}
    END

# Create a keyword to save the product name, price and link in an Excel file
Insert Data in Excel File
    Create Workbook    AmazonResults.xlsx

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

    Save Workbook    AmazonResults.xlsx

Create Amazon Directory
    TRY
        Create Directory    AmazonResults
    EXCEPT
        Log    This path already exists and isn't a directory
    END

Move Excel File
    TRY
        Move File    Robot-Scripts/AmazonResults.xlsx    ./AmazonResults/AmazonResults.xlsx
    EXCEPT
        Log    Error moving the file
    END


*** Test Cases ***
Test
    Open Browser and Search
    Get Products Info