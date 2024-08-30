*** Settings ***
Library           RPA.Browser.Selenium
Library           OperatingSystem
Library           Collections
Library           RPA.Excel.Files
Library           ex_lib/Utils.py

*** Variables ***
${site}               https://www.amazon.com.br/
${arq_txt_path}       Arquivos-Teste/prod.txt
${captcha_text}
${remove_chars}       &nbsp;
@{PROD_INFO}
@{PROD_PRICE}
@{PROD_LINK}


*** Keywords ***
Verify if adds exists
    [Arguments]        ${element}
    ${bool} =          Page Should Contain Element    ${element}
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
    ${add_exists} =    Verify if adds exists    //div[@class="a-row a-spacing-base"]
    IF    ${add_exists} == ${True}
        ${cont} =       Evaluate        2
    ELSE
        ${cont} =       Evaluate        3
    END

    FOR    ${i}    IN RANGE    ${cont}      64
        ${prod_info} =         Get Text                //*[@data-index="${cont}"]//h2
        ${prod_link} =         Get Element Attribute   //*[@data-index="${cont}"]//a    href

        TRY
             ${prod_price} =        Get Text           //*[@data-index="${cont}"]/div/div/span/div/div/div[2]/div[3]/div/div/a/span/span
             ${prod_price} =        Evaluate           REMOVE CHARS     ${prod_price}   ${remove_chars}
        EXCEPT
             ${prod_price} =        Evaluate           "Indisponível"
        END

        Append To List    ${PROD_INFO}    ${prod_info}
        Append To List    ${PROD_PRICE}   ${prod_price}
        Append To List    ${PROD_LINK}    ${prod_link}
    END

# Create a keyword to save the product name, price and link in an Excel file

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