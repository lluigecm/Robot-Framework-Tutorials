*** Settings ***
Library           RPA.Browser.Selenium
Library           OperatingSystem
Library           RPA.Excel.Files
Library           ex_lib/ImageReader.py

*** Variables ***
${site}               https://www.amazon.com.br/
${arq_txt_path}       Arquivos-Teste/prod.txt
${captcha_text}
@{prod_names}
@{prod_prices}
@{prod_links}


*** Keywords ***
# TO DO
Confirm if the png already exists
    [Arguments]        ${img_path}
    ${exists} =        File Should Not Exist        ${img_path}
    RETURN             ${exists}
Get Info From Archive
    [Arguments]        ${arq_txt_path}
    ${content} =       Get File        ${arq_txt_path}
    Log                ${content}
    RETURN             ${content}
    
# Create a keyword to open the Amazon page and search for the product
Open Browser and Search
    Open Browser    ${site}    chrome    options=add_argument("--start-maximized")
    #Wait Until Page Contains Element    //*[@id="twotabsearchtextbox"]   timeout=10s
    
    ${elemento_captcha}    Is Element Visible    //div[@class="a-row a-spacing-large"]
    IF    ${elemento_captcha} == ${True}
        ## Caso esteja presente, o robô espera o elemento da imagem carregar e faz o download
        
        Wait Until Element Is Visible    //div[@class="a-row a-text-center"]
        ${file_exists}         Confirm if the png already exists    TestScripts\Robot-Scripts\captcha.png
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


# Create a keyword to get the product name, price and link, and save them in a list
# Create a keyword to save the product name, price and link in an Excel file
# Create a keyword to create a new dir named AmazonResults
Create Amazon Directory
    TRY
        Create Directory    AmazonResults
    EXCEPT
        Log    This path already exists and isn't a directory
    END
# Create a keyword to move the Excel file to the AmazonResults dir
Move Excel File
    TRY
        Move File    AmazonResults.xlsx    AmazonResults
    EXCEPT
        Log    Error moving the file
    END

*** Test Cases ***
Test
    Open Browser and Search