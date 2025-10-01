*** Settings ***
Documentation     Palavras-chave para testes de Login - ServeRest API
Library           RequestsLibrary
Resource          ../variables.resource
Resource          usuario.resource

*** Variables ***
${LOGIN_EMAIL}    ${EMPTY}
${LOGIN_PASS}     ${EMPTY}
${TOKEN_GLOBAL}   ${EMPTY}

*** Keywords ***
Setup Login Tests
    [Documentation]    Cria usuário para testes de login
    Create Session    serverest    ${BASE_URL}
    ${response}    ${email}=    Cadastrar Usuario Valido    QA User Login Test    true
    Set Suite Variable    ${LOGIN_EMAIL}    ${email}
    Set Suite Variable    ${LOGIN_PASS}    ${VALID_PASSWORD}

Gerar Token Global
    [Documentation]    Gera um token válido e armazena globalmente para uso em todos os testes
    ${response_usuario}    ${email}=    Cadastrar Usuario Valido
    Set Suite Variable    ${LOGIN_EMAIL}    ${email}
    Set Suite Variable    ${LOGIN_PASS}    ${VALID_PASSWORD}
    ${response_login}=    Realizar Login Com Usuario Cadastrado    ${email}
    ${token}=    Set Variable    ${response_login.json()['authorization']}
    Set Global Variable    ${TOKEN_GLOBAL}    ${token}

Realizar Login Com Usuario Cadastrado
    [Documentation]    Realiza login com usuário cadastrado
    [Arguments]    ${email}=${LOGIN_EMAIL}
    ${data}=    Create Dictionary    email=${email}    password=${LOGIN_PASS}
    ${response}=    POST On Session    serverest    /login    json=${data}    expected_status=200
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    authorization
    RETURN    ${response}

Realizar Login Com Credenciais Invalidas
    [Documentation]    Tenta realizar login com credenciais inválidas
    [Arguments]    ${email}    ${password}
    ${data}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    serverest    /login    json=${data}    expected_status=401
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)email.*ou.*senha.*inválido
    RETURN    ${response}

Expiração de Token Após 10 Minutos
    [Documentation]    Verifica se o token expira após 10 minutos
    Sleep    600s
    ${headers}=    Create Dictionary    Authorization=${TOKEN_GLOBAL}
    &{body_produto}=  Create Dictionary    nome=Produto de Teste    preco=100    descricao=Teste    quantidade=10
    ${response}=    POST On Session   serverest    /produtos    headers=${headers}    json=${body_produto}
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message
    Should Match Regexp    ${response.json()['message']}    (?i)token.*inválido.*expirad
    RETURN    ${response}