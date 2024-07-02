Documentation  Este arquivo contém a estrutura de um arquivo Robot Framework

*** Settings ***
Library  SeleniumLibrary
    #  Settings define as configurações do arquivo

*** Variables ***
${var1}  value1
${var2}  value2
${var3}  value3
#  Variables definem as variáveis do arquivo

*** Keywords ***

# Keywords definem as ações que serão executadas nos testes


*** Test Cases ***
Cenário 1: Abrir Navegador
    Open Browser  https://www.google.com/  chrome
    #  Abrindo o navegador

Cenário 2: Acessar o site do Robot
    Go To   https://robotframework.org/
    #  Aceessando o site do Robot

Cenário 3: Fechar Navegador
    Close Browser
    #  Fechando o navegador
