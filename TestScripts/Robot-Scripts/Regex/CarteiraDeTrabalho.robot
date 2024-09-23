*** Settings ***
Library           OperatingSystem
Library           String

*** Variables ***
${arq_path}        ./Arquivos-Teste/carteira-de-trabalho.txt

${nome_rgx}                Nome[:].+
${n_carteira_rgx}          \\d{11}
${serie_rgx}               [A-Z][é][a-z]{3}[:]\\s\\d{3}
${data_nasc_rgx}           \\d{2}\\/\\d{2}\\/\\d{4}
${estado_civil_rgx}        [A-Z][a-z]{5}\\s.+
${escolaridade_rgx}        [A-Z][a-z]{3}\\s.{2}\\s.{9}[:].+
${filiação_rgx}            .+[:]\\n\\W\\s[A-Za-z]{3}[:].+\\n\\W\\s.{3}[:]\\s.+


*** Keywords ***
Formatar Informação
    [Arguments]    ${info}    ${rgx}
    ${info_formatada}=    Remove String Using Regexp    ${info}    ${rgx}
    RETURN    ${info_formatada}

Abrir Arquivo e Separar Informações
    ${file}=        Get File        ${arq_path}

    ${nome}=             Get Regexp Matches    ${file}       ${nome_rgx}        
    ${n_carteira}=       Get Regexp Matches    ${file}       ${n_carteira_rgx}
    ${serie}=            Get Regexp Matches    ${file}       ${serie_rgx} 
    ${data_nasc}=        Get Regexp Matches    ${file}       ${data_nasc_rgx}
    ${estado_civil}=     Get Regexp Matches    ${file}       ${estado_civil_rgx}
    ${escolaridade}=     Get Regexp Matches    ${file}       ${escolaridade_rgx}
    ${filiação}=         Get Regexp Matches    ${file}       ${filiação_rgx}

    ${nome}=             Formatar Informação   ${nome}[0]             .+[:]
    ${n_carteira}=       Formatar Informação   ${n_carteira}[0]       .+[:]
    ${serie}=            Formatar Informação   ${serie}[0]            .+[:]
    ${data_nasc}=        Get Variable Value    ${data_nasc}[0]        .+[:]
    ${estado_civil}=     Formatar Informação   ${estado_civil}[0]     .+[:]
    ${escolaridade}=     Formatar Informação   ${escolaridade}[0]     .+[:]
    ${filiação}=         Formatar Informação   ${filiação}[0]         Filiação:
    
*** Tasks ***
TRY
    Abrir Arquivo e Separar Informações
EXCEPT
    Log    Erro ao executar teste