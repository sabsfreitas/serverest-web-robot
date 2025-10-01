*** Settings ***
Documentation    Keywords específicas para operações administrativas
Library          RequestsLibrary
Library          Collections
Resource         ../variables.resource
Resource         usuario.resource
Resource         login.resource

*** Keywords ***

Setup User Session
    [Documentation]    Cria sessão e token de usuário comum
    Create Session    serverest    ${BASE_URL}
    ${response}    ${email}=    Cadastrar Usuario Valido    Regular User    false
    ${login_data}=    Create Dictionary    email=${email}    password=${VALID_PASSWORD}
    ${response_login}=    POST On Session    serverest    /login    json=${login_data}    expected_status=200
    ${token}=    Set Variable    ${response_login.json()['authorization']}
    RETURN    ${token}

Cadastro de produto bloqueado para usuário comum
    [Documentation]    Tenta cadastrar produto usando token de usuário comum e verifica que não é permitido
    [Arguments]    ${token}
    ${payload}=    Create Dictionary
    ...    nome=Produto Teste Usuário Comum
    ...    preco=100
    ...    descricao=Descrição do produto teste usuário comum
    ...    quantidade=5
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    serverest    /produtos    json=${payload}    headers=${headers}    expected_status=403
    Should Be Equal As Strings    ${response.status_code}    403
    Should Match Regexp    ${response.json()['message']}    (?i)rota.*exclusiva.*administradores
    RETURN    ${response}