*** Settings ***
Library           RPA.Browser.Selenium
Library           OperatingSystem
Library           RPA.Excel.Files

*** Variables ***
${browser}            Chrome
${url}                https://www.amazon.com.br/
${arq_txt_path}       Arquivos-Teste/prod.txt
@{prod_names}
@{prod_prices}
@{prod_links}


*** Keywords ***
# TO DO
Get Info From Archive
    [Arguments]        ${arq_txt_path}
    ${content} =       Get File        ${arq_txt_path}
    Log                ${content}
    RETURN             ${content}
    
# Create a keyword to open the Amazon page and search for the product
# Create a keyword to get the product name, price and link, and save them in a list
# Create a keyword to save the product name, price and link in an Excel file
# Create a keyword to create a new dir named AmazonResults
# Create a keyword to move the Excel file to the AmazonResults dir


*** Test Cases ***
Test 1
    Get Info From Archive    ${arq_txt_path}