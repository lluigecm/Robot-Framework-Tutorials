*** Settings ***
Library           RPA.Browser.Selenium
Library           OperatingSystem
Library           RPA.Excel.Files

*** Variables ***
${browser}        Chrome
${url}            https://www.amazon.com/
${arq_txt_path}   
@{prod_names}
@{prod_prices}
@{prod_links}
${qnt_prod}       ????

*** Keywords ***
# TO DO
# Create a keyword to read the .txt file and return the product name
# Create a keyword to open the Amazon page and search for the product
# Create a keyword to get the product name, price and link, and save them in a list
# Create a keyword to save the product name, price and link in an Excel file
# Create a keyword to create a new dir named AmazonResults
# Create a keyword to move the Excel file to the AmazonResults dir


*** Test Cases ***